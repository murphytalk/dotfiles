---
description: Schwab API 下单、行情流（streaming）踩坑经验——REST API 用法、WebSocket streaming 架构、bid/ask 独立采集、SUBS race condition 修复等
---

# Schwab API & Streaming 经验总结

## 1. REST API (`my_schwab/api.py`)

```python
# 创建客户端
from my_schwab.api import create_client, get_quotes, get_account, get_tx
c = create_client()  # token file: ~/.finance-credentials/schwab.token.json

# 获取行情（同步）
quotes = get_quotes(["AAPL", "TSLA"])
# 返回 list[MktData]: .ticker, .price, .bid, .ask, .quote_date

# 获取账户
acc_hash, acc = get_account(c)
c.get_orders_for_account(acc_hash, max_results=100, status="WORKING")
c.place_order(acc_hash, order_spec)  # 返回 201 成功，429 限流
c.get_order(order_id, acc_hash)
c.replace_order(acc_hash, order_id, new_spec)
c.get_transactions(acc_hash, start_date=..., end_date=..., transaction_types=[...])
```

## 2. Streaming (`my_schwab/streaming.py`)

### 架构
```
主线程                              后台线程 (daemon)
   │                                    │
   │ init_streaming(handler) ──────────►│ asyncio.new_event_loop()
   │                                    │ _stream_coro(client):
   │                                    │   StreamClient(client)
   │                                    │   注册 handlers
   │                                    │   await login()  ← WebSocket 连接
   │                                    │   while True:
   │                                    │     await handle_message()
   │                                    │
   │ subscribe_equity("AAPL") ─────────►│ level_one_equity_subs/add
   │                                    │
   │                                    │ ← WebSocket push
   │                                    │ _on_equity_quote(msg)
   │                                    │ _handle_quote_item(item)
   │                                    │   → _market_snapshots 更新
   │                                    │   → handler 回调
   │                                    │
   │ get_market_snapshot("AAPL") ←──────│ _market_snapshots (Lock 保护)
```

### 幂等初始化
```python
def init_streaming(handler) -> None:
    global _thread
    if _thread is not None and _thread.is_alive():
        return  # 已在运行，复用
    # ... 创建新线程和 event loop
```

### **致命的 race condition：SUBS 必须在 login 后发送**

**现象：** 在主线程调用 `subscribe_equity()` 时，后台线程可能还没完成 WebSocket 登录。此时通过 `asyncio.run_coroutine_threadsafe` 提交的 SUBS 协程会在 login 之前执行，导致服务器不返回数据。

**日志表现：** streaming 显示 `logged in`，后续只收到心跳 `heartbeat`，没有任何 equity quote 数据。`Stream snapshot: ICOP bid=- ask=- last=-`。

**修复：** 用 `_pending_tickers: list[str]` 队列。`subscribe_equity()` 检测到 streaming 未 ready 时入队而不是直接调度。`_stream_coro` 在 `await login()` 完成后再从队列取出 tickers 统一 SUBS。

```python
# subscribe_equity —— 主线程安全
def subscribe_equity(ticker: str) -> None:
    if _equity_sub_started and _stream_client is not None and _loop is not None:
        asyncio.run_coroutine_threadsafe(
            _stream_client.level_one_equity_add([ticker]), _loop)
    else:
        _pending_tickers.append(ticker)  # 排队等 login 后处理

# _stream_coro —— 后台 asyncio 线程
async def _stream_coro(client) -> None:
    _stream_client = StreamClient(client)
    _stream_client.add_level_one_equity_handler(_on_equity_quote)
    await _stream_client.login()
    # login 完成后才处理 pending tickers
    if _pending_tickers:
        tickers = list(_pending_tickers)
        _pending_tickers.clear()
        await _stream_client.level_one_equity_subs(tickers)
        _equity_sub_started = True
    while True:
        await _stream_client.handle_message()
```

### SDK 字段 relabel 机制

Schwab WebSocket 协议用数字表示字段，SDK 的 `relabel_message()` 在 dispatch 给 handler 之前把数字 key 转换成字符串名。**但只转换消息中实际存在的字段。**

```python
# LevelOneEquityFields 枚举（部分）
# 0=SYMBOL, 1=BID_PRICE, 2=ASK_PRICE, 3=LAST_PRICE, 4=BID_SIZE, 5=ASK_SIZE, ...

# 原始消息可能只有部分字段：
# {"key": "ICOP", "2": 50.4, "3": 50.28, "5": 100, ...}
#         没有 1=BID_PRICE
# 处理后：{"key": "ICOP", "ASK_PRICE": 50.4, "LAST_PRICE": 50.28, "ASK_SIZE": 100, ...}
#         item.get("BID_PRICE") → None   ⚠️
```

### bid/ask 独立采集

```
❌ 错误：if last_price is None: return   → 跳过 bid/ask 保存
✅ 正确：bid/ask 保存与 last_price 无关
```

```python
def _handle_quote_item(item, ts_field):
    # 先存 bid/ask（不受 last_price 影响）
    with _market_snapshot_lock:
        _market_snapshots[symbol] = {
            "bid": float(bid) if bid is not None else None,
            "ask": float(ask) if ask is not None else None,
            "last": float(last_price) if last_price is not None else None,
        }
    # 再调用 handler（只有 last_price 存在时）
    if _handler and last_price is not None:
        _handler(symbol, float(last_price), quote_date)
```

### 消费端检查

消息里经常只有 ASK 没有 BID，或只有 BID 没有 ASK。消费端要分别处理：

```python
snap = get_market_snapshot(ticker)
if snap:
    new_bid = snap.get("bid")
    new_ask = snap.get("ask")
    if new_ask > 0 and new_bid > 0:
        price = (new_bid + new_ask) / 2
    elif new_ask > 0:
        price = new_ask
    elif new_bid > 0:
        price = new_bid
```

## 3. 下单 (`my_schwab/trade.py`)

```python
# 限价买单
from schwab.orders.equities import equity_buy_limit
order_spec = equity_buy_limit("AAPL", 10, "150.00").build()
c.place_order(acc_hash, order_spec)

# 订单状态
TERMINAL_STATES = {"FILLED", "CANCELED", "EXPIRED", "REJECTED", "REPLACED"}
PLACED_STATUSES = {"FILLED", "WORKING", "QUEUED", "ACCEPTED", ...}

# 获取状态
resp = c.get_order(order_id, acc_hash)
data = resp.json()
status = data["status"]           # WORKING / FILLED / REJECTED / ...
detail = data.get("statusDescription")  # 拒绝原因等
```

## 4. 常见陷阱

| 陷阱 | 现象 | 修复 |
|------|------|------|
| SUBS 在 login 前发送 | 只收到心跳，无 quote 数据 | defer 到 login 后 + `_pending_tickers` 排队 |
| `last_price` None 时 early return | bid/ask 也丢失 | bid/ask 独立采集，不受 last_price 影响 |
| 消息中只有 ASK 没有 BID | `snap["bid"]` 为 None → 价格不更新 | 单边价格也可用 |
| `shutdown_streaming()` 时 event loop 已停 | asyncio Task destroyed 警告 | 全包裹 `try/except Exception: pass` |
| `init_streaming` 重复调用 | 多个 WebSocket 连接 | 检查 `_thread.is_alive()` 做幂等 |
| `snap.get("bid", 0)` 当值为 None | 返回 None 而非 0，`None > 0` 报错 | 先用 `is not None` 判空再比较 |

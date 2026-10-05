#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
CANDIDATES_FILE = SCRIPT_DIR / "model-candidates.json"
SETTINGS_FILE = Path("~/.pi/agent/settings.json").expanduser()


def load_json(filepath: Path) -> dict:
    if not filepath.exists():
        return {}
    with open(filepath, "r", encoding="utf-8") as f:
        return json.load(f)


def save_json(filepath: Path, data: dict) -> None:
    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def format_candidate(candidate: dict) -> str:
    model = candidate.get("model", "")
    thinking = candidate.get("thinking")
    if thinking:
        return f"{model}|{thinking}"
    return model


def prompt_role_selection(role: str, candidates: list) -> dict:
    print(f"\nSelect model for role '{role}':")
    for idx, cand in enumerate(candidates, start=1):
        formatted = format_candidate(cand)
        print(f"  {idx}) {formatted}")

    while True:
        try:
            choice_str = input(f"Enter choice [1-{len(candidates)}]: ").strip()
            choice = int(choice_str)
            if 1 <= choice <= len(candidates):
                return candidates[choice - 1]
            print(f"Invalid choice. Please enter a number between 1 and {len(candidates)}.")
        except (ValueError, EOFError, KeyboardInterrupt) as e:
            if isinstance(e, (EOFError, KeyboardInterrupt)):
                print("\nAborted.")
                sys.exit(1)
            print(f"Invalid input. Please enter a number between 1 and {len(candidates)}.")


def main():
    parser = argparse.ArgumentParser(description="Select model for roles in subagents")
    parser.add_argument("-r", "--role", help="Specific role to select model for")
    args = parser.parse_args()

    candidates_data = load_json(CANDIDATES_FILE)
    if not candidates_data:
        print(f"Error: Could not load candidates from {CANDIDATES_FILE}", file=sys.stderr)
        sys.exit(1)

    if args.role:
        if args.role not in candidates_data:
            print(f"Error: Role '{args.role}' not found in {CANDIDATES_FILE}", file=sys.stderr)
            print(f"Available roles: {', '.join(candidates_data.keys())}", file=sys.stderr)
            sys.exit(1)
        roles_to_process = [args.role]
    else:
        roles_to_process = list(candidates_data.keys())

    selected_overrides = {}
    for role in roles_to_process:
        candidates = candidates_data[role]
        if not candidates:
            print(f"Warning: No candidates for role '{role}', skipping.")
            continue
        selected_candidate = prompt_role_selection(role, candidates)
        selected_overrides[role] = selected_candidate

    settings = load_json(SETTINGS_FILE)
    if "subagents" not in settings or not isinstance(settings["subagents"], dict):
        settings["subagents"] = {}
    if "agentOverrides" not in settings["subagents"] or not isinstance(settings["subagents"]["agentOverrides"], dict):
        settings["subagents"]["agentOverrides"] = {}

    for role, candidate in selected_overrides.items():
        settings["subagents"]["agentOverrides"][role] = candidate

    save_json(SETTINGS_FILE, settings)
    print("\nUpdated subagents.agentOverrides in settings.json successfully:")
    for role, cand in selected_overrides.items():
        print(f"  {role}: {format_candidate(cand)}")


if __name__ == "__main__":
    main()

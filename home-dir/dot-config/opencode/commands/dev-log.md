Review the conversation history and generate a dev log entry for today.

Steps:
1. Determine today's date (YYYY-MM-DD format)
2. Read the existing `dev-log.md` from the project root if it exists
3. Extract items already logged under today's date entry (to avoid duplicates)
4. From the conversation history, summarize what was done — code written, bugs fixed, decisions made, files changed — as a brief bullet list
5. Remove any items that are already present in today's existing entry
6. If today's date header already exists in dev-log.md, append only the new unique items under it
7. If today's date header does not exist, prepend a new entry at the top of the file in this format:

## YYYY-MM-DD
- item 1
- item 2

8. Write the updated content back to dev-log.md

Write a python script `sel-role-model.py` here.

- Only uses stdlib
- Uses argparse
- It loads the models by role from file `model-candidates.json` in the same directory
- If no cmd line arg is provided, then it asks which model to choose for each role one by one
  - The model name should be listed as model value|thinking value , each is prefixed with a number (starts from 1) to let user select
  - User selects by number
  - Go through all roles, then populate the subagents.agentOverrides with the selected role/models
- cmd line options
  - `-r <role>` : only list the model candidates for that particular role for user to select

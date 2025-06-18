# AI Agent Workspace

WIP

### Usage

Add the following configuration to your Claude for Desktop configuration file.

MacOS:

```json
"shell-command": {
  "command": "docker",
  "args": [
    "run",
    "--rm",
    "-i",
    "--mount",
    "type=bind,src=/Users/user-name/MCPHome,dst=/home/mcp",
    "ghcr.io/kaznak/shell-command-mcp:latest"
  ]
}
```

Replace `/Users/user-name/ClaudeWorks` with the directory you want to make available to the container.

Windows:

```json
"shell-command": {
   "command": "docker",
   "args": [
      "run",
      "--rm",
      "-i",
      "--mount",
      "type=bind,src=\\\\wsl.localhost\\Ubuntu\\home\\user-name\\MCPHome,dst=/home/mcp",
      "ghcr.io/kaznak/shell-command-mcp:latest"
   ]
}
```

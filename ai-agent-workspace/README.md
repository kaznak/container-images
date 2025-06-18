# AI Agent Workspace

An Ubuntu-based Docker image designed for AI Coding Agents, such as Claude for Desktop, to run in a containerized environment. This image provides a consistent and isolated workspace for AI agents to operate, ensuring that dependencies and configurations do not interfere with the host system.

## Usage

This image is itended to be used with the Home Directory mounted to the container.
Before running, setup Home Directory for AI Agent Workspace.
Such as  `.claude`, `.kube`, `.ssh`, `.config`, `.local`, etc.

### Linux

```bash
HOST_DIRECTORY_FOR_AI_AGENT_WORKSPACE=/home/kaznak/MCPHome
docker run --rm -it --mount type=bind,source=$HOST_DIRECTORY_FOR_AI_AGENT_WORKSPACE,target=/home/ubuntu ghcr.io/kaznak/ai-agent-workspace:ubuntu-latest -- bash -l -c "claude mcp serve"
```

### Claude for Desktop

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
        "type=bind,src=/Users/user-name/MCPHome,dst=/home/ubuntu",
        "ghcr.io/kaznak/ai-agent-workspace:ubuntu-latest",
        "--",
        "bash",
        "-l",
        "-c",
        "claude mcp serve"
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
        "type=bind,src=\\\\wsl.localhost\\Ubuntu\\home\\user-name\\MCPHome,dst=/home/ubuntu",
        "ghcr.io/kaznak/ai-agent-workspace:ubuntu-latest"
        "--",
        "bash",
        "-l",
        "-c",
        "claude mcp serve"
    ]
}
```

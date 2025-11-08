Cursor setup for VS Code (macOS)

This file contains step-by-step instructions, settings snippets, and keybindings to install and use Cursor (the AI-powered coding assistant) in VS Code on macOS.

1) Install the Cursor extension in VS Code (UI)
- Open VS Code.
- Open Extensions: Command + Shift + X.
- Search for "Cursor" (publisher: cursor.dev or similar). Confirm the publisher in the Marketplace entry.
- Click "Install".

2) Install via command line (optional)
- Ensure the `code` command is available in your PATH. In VS Code, Command Palette (Command + Shift + P) → "Shell Command: Install 'code' command in PATH".
- Then run (replace extension id with the marketplace id if different):

```bash
code --install-extension cursor.cursor
```

3) Sign in and authorize
- After installation open the Cursor pane (look for Cursor's icon in the Activity Bar or Command Palette → "Cursor: Open").
- Click "Sign in" and follow the web flow. Cursor may ask to connect via GitHub/Google/email depending on your account type.
- Grant workspace file access when prompted. The extension usually needs read access; write access is optional.

4) Configure privacy / file exclusion
- Add a setting to your workspace `settings.json` to exclude sensitive files from being sent to Cursor's servers (if the extension supports it). Example snippet:

```json
// Add to .vscode/settings.json or VS Code User settings
{
  "cursor.upload.exclude": [
    "**/secrets/**",
    "**/.env",
    "**/android/**",
    "**/ios/**"
  ],
  "cursor.experimental.enableInline": true
}
```

Note: `cursor.upload.exclude` may vary; check Cursor extension docs for the exact setting name.

5) Useful keybindings (paste into `.vscode/keybindings.json` or your global keybindings)

```json
[
  {
    "key": "cmd+alt+e",
    "command": "cursor.explainSelection",
    "when": "editorTextFocus && editorHasSelection"
  },
  {
    "key": "cmd+alt+g",
    "command": "cursor.generateTests",
    "when": "editorTextFocus"
  },
  {
    "key": "cmd+alt+r",
    "command": "cursor.refactor",
    "when": "editorTextFocus"
  }
]
```

Adjust the `command` names if Cursor uses different command IDs—open Command Palette and type "Cursor:" to list exact commands.

6) First run (try it)
- Open `lib/main.dart`.
- Select the `_incrementCounter` function.
- Press Command + Shift + P → type "Cursor: Explain Selection" (or use the keybinding you set) and read the explanation in the Cursor pane.
- Ask follow-ups in the Cursor pane (e.g., "Add a unit test for _incrementCounter").

7) Troubleshooting
- If the extension doesn't show up: reload window (Command + Shift + P → Developer: Reload Window).
- If the `code` CLI isn't found: use Command Palette to install the shell command.
- If Cursor requests payment or API key: check your Cursor account dashboard.

8) Notes
- I can't install the extension on your machine from here. These instructions let you complete installation locally.
- If you want, I can produce a short AppleScript or `brew` commands to automate parts of this; tell me if you'd like automation.


If you'd like, I can now:
- Create the `.vscode/settings.json` and `.vscode/keybindings.json` files in your project with the snippets above.
- Or provide a short shell script to open VS Code and run the `code --install-extension` command.

Tell me which of the two you'd like me to add to your workspace.

# Implementation incident review

The working theme initially failed intermittently despite correct CSS. The final project incorporates the following fixes:

- macOS LaunchServices discarded Chromium debugging flags. The launcher now starts the official executable through a user-level `launchd` job.
- `launchd` jobs did not reliably inherit `HOME`. Shared shell code resolves the current user's home directory when the variable is missing.
- Two shell helpers returned the status of their final conditional expression, reporting failure after successful work. Successful helper paths now return explicitly or end with successful commands.
- The home-suggestion selector was under-escaped inside a CDP JavaScript string. Verification now resolves `.group\\/home-suggestions` correctly and must return `pass: true`.
- A Computer Use child process could inherit the CDP listener. Port ownership now accepts the official Codex process and verified descendants, while rejecting unrelated listeners.
- A large bundled Node binary made GitHub delivery impractical. Version 1.0.0 validates and reuses Codex's own signed Node instead.
- Static preview images were not accepted as release evidence. Final signoff requires JSON from the live DOM verifier plus a CDP screenshot.
- A manually submitted legacy repair job entered launchd's inferred keepalive retry loop and repeatedly replaced a new injection with stale code. Version 2.2.0 removes that label during install/start/restore and uses explicit plist-backed LaunchAgents for the injector and restart watchdog.
- The previous reload verifier reinjected its own payload after `Page.reload`, which could hide a dead daemon. Verify mode now waits for the persistent injector to recover the renderer before it can pass.

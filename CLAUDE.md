# Personal macOS dotfiles

Lives at `~/.dotfiles`. **Do not move under `~/Documents/`** — macOS TCC blocks system daemons (e.g. Karabiner-Core-Service) from reading that path, which silently breaks any config they reach through a symlink.

## install.sh is both installer and updater

Re-running is safe. Every step detects the current state and reports `[skip]` / `+ installed` / `^ updated` / `! failed` in the end-of-run summary.

```
cd ~/.dotfiles && git pull && ./install.sh
```

Idempotency contract — all of these must report `SKIPPED+=` when the target state already matches, never blindly re-do:

- `brew_install`, `brew_cask_install`, `go_get` — package installs
- `defaults_write` — macOS defaults (reads current value first)
- `link_config` — symlinks dotfiles into `$HOME` (backs up a real dir if one is blocking the symlink)
- `relocate_to_ssd` — migrates a local path into the SSD and symlinks back, or just creates the symlink on a fresh machine

Anything new added to `install.sh` should mutate the `INSTALLED` / `UPDATED` / `SKIPPED` / `FAILED` arrays so the summary stays meaningful.

## Symlink layout (handled by `link_config`)

| Repo path | Symlinks to |
|---|---|
| `karabiner/` | `~/.config/karabiner` |
| `ghostty/` | `~/.config/ghostty` |
| `tmux/` | `~/.config/tmux` |
| `starship/` | `~/.config/starship` |
| `nvim/` | `~/.config/nvim` |
| `scripts/` | `~/.config/scripts` |
| `.aerospace.toml` | `~/.aerospace.toml` |
| `.zshrc` | `~/.zshrc` |

`scripts/` reaches `PATH` via `$HOME/.config/scripts` in `.zshrc` — that entry only resolves because the symlink is in place, so don't drop the `link_config` call for it. Lazy.nvim writes `lazy-lock.json` back through the `nvim/` symlink into the repo, which is intentional (the lockfile is tracked).

## External SSD relocations: `/Volumes/Barandiaran` (Crucial X9 1 TB, USB 3.2 Gen 2)

Heavy dev-tool data lives on the SSD to keep the internal disk free. **The relocated tools fail to find data when the SSD isn't mounted** — `install.sh` checks for the volume and logs `[skip]` for the relocation block when it's missing, never failing.

| Tool | Method | SSD path |
|---|---|---|
| Android SDK / AVDs | env var (`ANDROID_HOME`, `ANDROID_AVD_HOME` in `.zshrc`) | `/Volumes/Barandiaran/Dev/android/{sdk,avd}` |
| iOS Simulator (user data) | symlink `~/Library/Developer/CoreSimulator` → SSD | `/Volumes/Barandiaran/Dev/ios/CoreSimulator` |
| OrbStack (Docker) | GUI-only: Settings → Storage → Move data folder | `/Volumes/Barandiaran/orbstack` |

Two patterns because not every tool offers an env-var override:
- **env var** when supported (Android) — just pre-create the dirs.
- **symlink** when the path is hardcoded (iOS Simulator) — `relocate_to_ssd` migrates a real dir into the SSD path then symlinks back.

`/Library/Developer/CoreSimulator/` (root-owned, holds runtime DMGs) is intentionally **not** relocated — moving needs sudo and breaks when Apple updates runtimes.

## One-time GUI steps (post-install, can't be scripted)

The underlying plists can't be pre-seeded without corruption, so these stay manual on a fresh machine:

1. **OrbStack** — Settings → Storage → move data folder to `/Volumes/Barandiaran/orbstack`. Disable "Start at login" so it doesn't try to launch when the SSD isn't mounted.
2. **Android Studio** — Settings → Languages & Frameworks → Android SDK → set Android SDK Location to `/Volumes/Barandiaran/Dev/android/sdk`.
3. **Xcode** — `xcodes install --latest --select` (Apple ID prompt), then `sudo xcodebuild -license accept` and `xcodebuild -runFirstLaunch`.
4. **Karabiner-Elements** — first launch may need Input Monitoring + Accessibility granted in System Settings.

## Conventions

- Commit messages match the existing log: `Feat: <description>` (capitalized).
- `.DS_Store` files: gitignored, but a few historical ones are still tracked. Leave them; not worth a cleanup commit.

# AGENTS.md - dz6 Development Guide

## Project Overview

Vim-inspired TUI hex editor written in Rust. Uses memory-mapped files for large file performance.

## Key Commands

```bash
cargo build          # Build
cargo test           # Run tests (inline only, no tests/ directory)
cargo run -- <file>  # Run with file
cargo fmt            # Format code (required before commits)
```

## Architecture

- **Entrypoint**: `src/main.rs` → `app::App`
- **Core modules**:
  - `app.rs` - Main application state & file handling
  - `hex/` - Hex view, editing, search, selection, strings extraction
  - `text/` - Text view (less developed than hex view)
  - `global/` - Calculator, goto, status bar, logging
  - `commands.rs` - Command bar (`:`) parsing
  - `database.rs` - Bookmark/comment persistence (`.dz6` files)
- **Memory mapping**: Uses `mmap-io` crate; files are memory-mapped, not fully loaded
- **TUI**: Built with `ratatui` + `crossterm`

## Rust Edition

Uses **Rust 2024** edition (not 2021). Requires up-to-date Rust toolchain.

## Code Style

- Run `cargo fmt` before commits (per CONTRIBUTING.md)
- No separate test directory; tests are inline in `src/**/*.rs` under `#[cfg(test)]` modules

## User Configuration

Users can create `$HOME/.dz6init` with one command per line for persistent settings (see README.md commands section).

## Release Process

Automated via `cargo-dist` (v0.30.3). See `.github/workflows/release.yml` and `dist-workspace.toml`. Targets: macOS (arm64/x64), Linux (gnu/musl), Windows.

**Testing releases on your fork**:
1. Run `./scripts/test-release.sh 0.7.0-test.1` to create test release
2. Monitor build at https://github.com/Gutem/dz6/actions
3. Download and test artifacts locally
4. Clean up test tag before PR

**Creating actual release**:
1. Merge PR to mentebinaria/dz6
2. Tag and push: `git tag v0.7.0 && git push upstream --tags`
3. Workflows auto-create release, Homebrew formula PR, and Nix flake PR

See `RELEASE-TESTING.md` for detailed testing guide.

## Key Dependencies

- `ratatui` - TUI framework
- `crossterm` - Terminal control
- `mmap-io` - Memory-mapped file I/O
- `clap` - CLI argument parsing
- `regex` - Search functionality
- `evalexpr` - Calculator

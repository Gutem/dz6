# Release Testing Guide

## Testing Releases on Your Fork

Before creating a PR to mentebinaria/dz6, test the release process on Gutem/dz6.

### Automated Method (Recommended)

```bash
# Create a test release
./scripts/test-release.sh 0.7.0-test.1

# This will:
# - Update version in Cargo.toml, Homebrew, and Nix
# - Create and push tag v0.7.0-test.1
# - Trigger test build workflow
```

### Manual Method

```bash
# 1. Create a test tag
git tag v0.7.0-test.1
git push origin v0.7.0-test.1

# 2. Monitor the build
open https://github.com/Gutem/dz6/actions

# 3. Download and test artifacts

# 4. Clean up test tag
git tag -d v0.7.0-test.1
git push origin :refs/tags/v0.7.0-test.1
```

### What Gets Tested

1. **Build artifacts** - Binary compilation for all platforms
2. **Homebrew formula** - SHA256 checksums are calculated correctly
3. **Nix flake** - Build succeeds with Nix
4. **Cross-platform** - macOS (Intel/ARM), Linux, Windows

### Testing the Artifacts

After the workflow completes:

```bash
# Download artifacts from GitHub Actions
gh run download

# Test macOS binary (if on macOS)
tar -xzf dz6-aarch64-apple-darwin.tar.gz
./dz6 --version
./dz6 test-file.bin

# Test Linux binary (requires Docker)
docker run --rm -v $(pwd):/app -w /app alpine sh -c "
  tar -xzf dz6-x86_64-unknown-linux-musl.tar.gz
  ./dz6 --version
"

# Test Windows binary (requires Wine or Windows)
# unzip dz6-x86_64-pc-windows-msvc.zip
# wine dz6.exe --version
```

### Before Creating PR

1. ✅ Test release workflow succeeds
2. ✅ Download and test all binary artifacts
3. ✅ Revert test version changes
4. ✅ Update version to final (e.g., 0.7.0)
5. ✅ Update CHANGELOG.md
6. ✅ Run `cargo fmt`
7. ✅ Create PR to mentebinaria/dz6

### Checklist for Actual Release

After PR is merged to mentebinaria/dz6:

```bash
# In mentebinaria/dz6 repo
git checkout main
git pull upstream main
git tag v0.7.0
git push upstream main --tags

# This triggers:
# - Binary builds via cargo-dist
# - GitHub Release creation
# - Homebrew formula PR
# - Nix flake PR
```

### Troubleshooting

**Build fails on specific platform**:
- Check the workflow logs for compilation errors
- Ensure all dependencies are available for that platform
- Test locally with Docker (Linux) or VMs

**Homebrew formula checksum mismatch**:
- The workflow auto-generates checksums
- Check that the correct artifacts are being downloaded

**Nix build fails**:
- Ensure `flake.lock` is updated
- Check Nixpkgs version compatibility
- Test locally: `nix build . --show-trace`

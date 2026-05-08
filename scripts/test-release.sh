#!/bin/bash
set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 0.7.0-test.1"
  exit 1
fi

TAG="v${VERSION}"

echo "=== Testing release for version ${VERSION} ==="
echo ""
echo "This will:"
echo "1. Update Cargo.toml version to ${VERSION}"
echo "2. Create tag v${VERSION}"
echo "3. Push to Gutem/dz6"
echo "4. Trigger test release build"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted"
  exit 1
fi

# Update version in Cargo.toml
echo "Updating Cargo.toml..."
sed -i.bak "s/^version = \".*\"/version = \"${VERSION}\"/" Cargo.toml
rm Cargo.toml.bak

# Update version in Homebrew formula
echo "Updating Homebrew formula..."
sed -i.bak "s/version \".*\"/version \"${VERSION}\"/" Formula/dz6.rb
rm Formula/dz6.rb.bak

# Update version in flake.nix
echo "Updating flake.nix..."
sed -i.bak "s/version = \".*\";/version = \"${VERSION}\";/" flake.nix
rm flake.nix.bak

# Commit changes
echo "Committing..."
git add Cargo.toml Formula/dz6.rb flake.nix
git commit -m "chore: bump version to ${VERSION} for testing"

# Create tag
echo "Creating tag ${TAG}..."
git tag -a "${TAG}" -m "Test release ${VERSION}"

# Push to origin (Gutem/dz6)
echo "Pushing to Gutem/dz6..."
git push origin main --tags

echo ""
echo "✓ Tag ${TAG} pushed to Gutem/dz6"
echo ""
echo "Next steps:"
echo "1. Check workflow at: https://github.com/Gutem/dz6/actions"
echo "2. Download artifacts and test them"
echo "3. If successful, create PR to mentebinaria/dz6"
echo "4. Don't forget to:"
echo "   - Revert test version changes"
echo "   - Use proper version (0.7.0) in PR"
echo "   - Delete test tag: git tag -d ${TAG} && git push origin :refs/tags/${TAG}"

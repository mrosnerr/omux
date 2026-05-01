# Releasing OpenMUX

OpenMUX now has a first-pass release flow built around generated GitHub Releases and downloadable archives.

## Local packaging

Build release artifacts locally with:

```bash
make package-release RELEASE_VERSION=0.1.0
```

That command writes artifacts to `dist/release/`:

- `OpenMUX-<version>-macos-unsigned.zip`
- `omux-<version>-macos.tar.gz`
- `checksums.txt`

The app archive is produced from the existing unsigned app bundle flow in `Scripts/publish-unsigned.sh`. The CLI archive packages the release-built `omux` binary plus the repository license.

The app bundle also includes a bundled CLI binary at `OpenMUX.app/Contents/MacOS/omux`, so users who install only the app can:

- choose **OpenMUX → Install omux CLI** inside the app for the one-click install flow
- or link it from Terminal with:

```bash
/Applications/OpenMUX.app/Contents/MacOS/omux install-cli
```

By default that command installs `omux` into the first preferred directory already on `PATH`, or falls back to `~/.local/bin/omux` and prints the shell export line to add.

## GitHub Release flow

Pushing a version tag triggers [`.github/workflows/release.yml`](../.github/workflows/release.yml):

```bash
git tag v0.1.0
git push origin v0.1.0
```

The workflow:

1. builds the vendored Ghostty runtime
2. verifies the repository
3. runs `make package-release`
4. publishes a GitHub Release with the packaged artifacts attached
5. lets GitHub generate release notes automatically

Generated release notes are configured through [`.github/release.yml`](../.github/release.yml). Categorization depends on pull request labels, so the changelog improves as labels are used consistently.

## Current distribution status

The current GitHub Release automation publishes **unsigned** macOS artifacts. That is useful for early testers and internal dogfooding, but a public macOS release should move to:

1. Developer ID signing
2. notarized `.dmg` distribution
3. Homebrew cask publishing for the app
4. Homebrew formula or bottle publishing for `omux`

## Next step for public macOS installs

When Apple signing credentials are available, upgrade the release flow by:

1. signing the generated `.app` with a Developer ID Application certificate
2. building a distributable `.dmg`
3. notarizing and stapling the `.dmg`
4. attaching the notarized `.dmg` to the GitHub Release instead of, or alongside, the unsigned zip

That keeps the current tag/release/changelog flow intact while replacing the unsigned artifact with a Gatekeeper-friendly download.

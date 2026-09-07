# Releasing simple-nfsd

## Version source of truth

`CMakeLists.txt` (or the project `VERSION` file) sets the product version. Keep **CHANGELOG.md**, packaging metadata, and git tags aligned with that version for the release you publish.

## Pre-release

1. Update [CHANGELOG.md](CHANGELOG.md) (`Unreleased` → new section with date).
2. Bump version in CMake / VERSION files if needed.
3. Run the [project/RELEASE_CHECKLIST.md](project/RELEASE_CHECKLIST.md).
4. Prefer `project/PROGRESS_REPORT.md` over roadmap checkmarks when deciding readiness.

## Build and test

```sh
cmake -S . -B build -DENABLE_TESTS=ON
cmake --build build
cd build && ctest --output-on-failure
```

Adjust CMake options to match this project's conventions (`BUILD_VERSION`, static builds, etc.).

## Tag and publish

```sh
git tag -a v0.5.0 -m "Release v0.5.0"
git push origin v0.5.0
```

1. Create a GitHub Release for the tag; paste the matching **CHANGELOG.md** section.
2. Optional: attach CPack / `make package` artifacts with `gh release upload`.

## Verify an existing tag (optional)

If this repo has `scripts/verify-release-build.sh`:

```sh
./scripts/verify-release-build.sh v0.5.0
```

Otherwise, check out the tag in a clean worktree and run the build/test commands above.


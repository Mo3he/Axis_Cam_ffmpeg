#!/usr/bin/env sh
# Thin dispatcher around the per-architecture Dockerfiles in aarch64/ and arm/.
# Builds one or both ACAP .eap packages and drops them at the repo root.
#
#   ./build.sh              # build both aarch64 and armv7hf
#   ./build.sh aarch64      # build only aarch64
#   ./build.sh armv7hf      # build only armv7hf (alias: arm)
#
# Override the container runtime with RUNTIME=docker|podman if autodetect is
# wrong. Apple's `container` tool is not auto-selected; build the subdir
# Dockerfile directly if you prefer it (see aarch64/README.md).
set -eu

REPO_ROOT=$(cd -P "$(dirname "$0")" && pwd)

# Map an architecture name to its source subdirectory.
arch_dir() {
	case "$1" in
	aarch64) echo aarch64 ;;
	armv7hf | arm) echo arm ;;
	*)
		echo "Error: unknown architecture '$1' (use aarch64 or armv7hf)" >&2
		exit 1
		;;
	esac
}

# Auto-detect container runtime: prefer docker when its daemon is reachable,
# otherwise fall back to podman.
if [ -z "${RUNTIME:-}" ]; then
	if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
		RUNTIME=docker
	elif command -v podman >/dev/null 2>&1; then
		RUNTIME=podman
	elif command -v docker >/dev/null 2>&1; then
		RUNTIME=docker
	else
		echo 'Error: neither docker nor podman found in PATH' >&2
		exit 1
	fi
fi
echo "==> Using container runtime: ${RUNTIME}"

# build_arch <arch>: build the subdir Dockerfile and extract the .eap to root.
build_arch() {
	ARCH=$1
	DIR=$(arch_dir "$ARCH")
	TAG="ffmpeg-acap-${DIR}-$$"
	echo "==> Building ${ARCH} (${DIR}/Dockerfile)..."
	"$RUNTIME" build -t "$TAG" "${REPO_ROOT}/${DIR}"

	# Copy the packaged .eap out of the built image via a throwaway container.
	CID=$("$RUNTIME" create "$TAG")
	TMP=$(mktemp -d)
	"$RUNTIME" cp "${CID}:/opt/app/." "$TMP/" >/dev/null 2>&1 ||
		"$RUNTIME" cp "${CID}:/opt/app" "$TMP/"
	find "$TMP" -name '*.eap' -exec cp {} "${REPO_ROOT}/" \;
	rm -rf "$TMP"
	"$RUNTIME" rm -f "$CID" >/dev/null 2>&1 || true
	"$RUNTIME" rmi -f "$TAG" >/dev/null 2>&1 || true
}

echo '==> Cleaning old .eap files...'
rm -f "${REPO_ROOT}"/*.eap

if [ "$#" -eq 0 ]; then
	set -- aarch64 armv7hf
fi
for a in "$@"; do
	build_arch "$a"
done

echo '==> Done!'
ls -lh "${REPO_ROOT}"/*.eap

#!/usr/bin/env sh

# Note: pipefail is not supported in POSIX shell and will be silently ignored, unless bash is used
set -eo pipefail

# Check if Emacs is installed and working
if ! command -v emacs >/dev/null 2>&1; then
    echo "ERROR: Emacs not found"
    exit 1
fi

# Check Emacs version
if ! emacs --version >/dev/null 2>&1; then
    echo "ERROR: Emacs version check failed"
    exit 1
fi

# Check if essential tools are available
for tool in git ripgrep fd-find fzf gcc cmake gdb clang; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "WARNING: $tool not found in PATH"
    fi
done

# Check if fonts directory exists
if [ ! -d "/usr/share/fonts" ]; then
    echo "WARNING: Fonts directory not found"
fi

echo "Health check passed: All core components are working"
exit 0

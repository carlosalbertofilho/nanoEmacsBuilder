#!/usr/bin/env sh

# Note: pipefail is not supported in POSIX shell and will be silently ignored, unless bash is used
set -eo pipefail

echo "Testing nano Emacs Docker image..."

# Test Emacs installation
echo "Testing Emacs..."
emacs --version | head -1 || exit 1

# Test development tools
echo "Testing development tools..."
gcc --version | head -1 || exit 1
git --version || exit 1
python3 --version || exit 1

# Test search tools
echo "Testing search tools..."
rg --version || exit 1
fd --version || exit 1
fzf --version || exit 1

# Test build tools
echo "Testing build tools..."
cmake --version | head -1 || exit 1
make --version | head -1 || exit 1

# Test if norminette is available (if installed)
if command -v norminette >/dev/null 2>&1; then
    echo "Testing norminette..."
    norminette --version || echo "Warning: norminette test failed"
fi

# Test fonts availability
echo "Testing fonts..."
fc-list | grep -i "JetBrains\|Fira" && echo "Nerd fonts found" || echo "Warning: Nerd fonts not found"

# Test Emacs basic functionality
echo "Testing Emacs basic functionality..."
emacs --batch --eval "(message \"Emacs test successful\")" || exit 1

echo "All tests passed successfully!"
exit 0

#!/usr/bin/env sh

# Note: pipefail is not supported in POSIX shell and will be silently ignored, unless bash is used
set -eo pipefail

echo "Testing nano Emacs Docker image with Dirvish support..."

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
fzf --version || exit 1

# Test fd (essential for Dirvish)
echo "Testing fd (essential for Dirvish)..."
if command -v fd >/dev/null 2>&1; then
    fd --version || exit 1
    echo "✓ fd available for Dirvish"
elif command -v fdfind >/dev/null 2>&1; then
    fdfind --version || exit 1
    echo "✓ fdfind available (will work as fd for Dirvish)"
else
    echo "ERROR: fd/fdfind not found - required for Dirvish"
    exit 1
fi

# Test build tools
echo "Testing build tools..."
cmake --version | head -1 || exit 1
make --version | head -1 || exit 1

# Test Dirvish preview dependencies
echo "Testing Dirvish preview dependencies..."

# Image preview with vipsthumbnail
if command -v vipsthumbnail >/dev/null 2>&1; then
    echo "✓ vipsthumbnail available for image preview"
elif command -v vips >/dev/null 2>&1; then
    vips --version | head -1 || echo "Warning: vips found but version check failed"
    echo "✓ vips available for image processing"
else
    echo "WARNING: vipsthumbnail/vips not found - image preview will be unavailable"
fi

# Video preview with ffmpegthumbnailer
if command -v ffmpegthumbnailer >/dev/null 2>&1; then
    ffmpegthumbnailer -h >/dev/null 2>&1 && echo "✓ ffmpegthumbnailer available for video preview" || echo "Warning: ffmpegthumbnailer found but test failed"
else
    echo "INFO: ffmpegthumbnailer not found - video preview will be unavailable"
fi

# PDF preview with pdftoppm
if command -v pdftoppm >/dev/null 2>&1; then
    pdftoppm -h >/dev/null 2>&1 && echo "✓ pdftoppm available for PDF preview" || echo "Warning: pdftoppm found but test failed"
else
    echo "INFO: pdftoppm not found - PDF preview will be unavailable"
fi

# Media info with mediainfo
if command -v mediainfo >/dev/null 2>&1; then
    mediainfo --version | head -1 || echo "Warning: mediainfo found but version check failed"
    echo "✓ mediainfo available for media metadata"
else
    echo "INFO: mediainfo not found - media info will be unavailable"
fi

# Font preview with ImageMagick
if command -v magick >/dev/null 2>&1; then
    magick --version | head -1 || echo "Warning: magick found but version check failed"
    echo "✓ ImageMagick available for font preview"
elif command -v convert >/dev/null 2>&1; then
    convert --version | head -1 || echo "Warning: convert found but version check failed"
    echo "✓ ImageMagick (convert) available for font preview"
else
    echo "INFO: ImageMagick not found - font preview will be unavailable"
fi

# Archive preview with 7zip
if command -v 7z >/dev/null 2>&1; then
    7z | head -5 >/dev/null 2>&1 && echo "✓ 7z available for archive preview" || echo "Warning: 7z found but test failed"
elif command -v 7za >/dev/null 2>&1; then
    7za | head -5 >/dev/null 2>&1 && echo "✓ 7za available for archive preview" || echo "Warning: 7za found but test failed"
else
    echo "INFO: 7zip not found - archive preview will be unavailable"
fi

# rsync for dirvish-rsync extension
if command -v rsync >/dev/null 2>&1; then
    rsync --version | head -1 || echo "Warning: rsync found but version check failed"
    echo "✓ rsync available for file synchronization"
else
    echo "INFO: rsync not found - dirvish-rsync extension will be unavailable"
fi

# Test if norminette is available (if installed)
if command -v norminette >/dev/null 2>&1; then
    echo "Testing norminette..."
    norminette --version || echo "Warning: norminette test failed"
    echo "✓ norminette available for 42 School projects"
fi

# Test fonts availability
echo "Testing fonts..."
if fc-list | grep -i "JetBrains\|Fira" >/dev/null 2>&1; then
    echo "✓ Nerd fonts found"
    fc-list | grep -c "JetBrains\|Fira" | sed 's/^/  Found fonts: /'
else
    echo "Warning: Nerd fonts not found"
fi

# Test Emacs basic functionality
echo "Testing Emacs basic functionality..."
emacs --batch --eval "(message \"Emacs test successful\")" || exit 1

# Test GNU ls compatibility (important for Dirvish)
echo "Testing GNU ls compatibility for Dirvish..."
if ls --version 2>/dev/null | grep -q "GNU"; then
    echo "✓ GNU ls detected - full Dirvish compatibility"
elif command -v gls >/dev/null 2>&1 && gls --version 2>/dev/null | grep -q "GNU"; then
    echo "✓ GNU ls available as 'gls' - Dirvish compatible"
else
    echo "WARNING: GNU ls not detected - some Dirvish features may not work properly"
fi

echo ""
echo "=== Test Summary ==="
echo "✓ Core functionality: PASSED"
echo "✓ Development tools: PASSED"
echo "✓ Search tools: PASSED"
echo "✓ Dirvish core dependencies: PASSED"
echo "✓ Preview dependencies: CHECKED (see details above)"
echo ""
echo "All tests completed successfully!"
echo "Image is ready for nano Emacs with full Dirvish support!"
exit 0

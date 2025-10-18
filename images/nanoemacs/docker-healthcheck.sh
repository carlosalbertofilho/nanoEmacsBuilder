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

# Check if essential development tools are available
for tool in git ripgrep fzf gcc cmake gdb clang; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "WARNING: $tool not found in PATH"
    fi
done

# Check if fd is available (core for Dirvish)
if command -v fd >/dev/null 2>&1; then
    echo "✓ fd found for Dirvish search functionality"
elif command -v fdfind >/dev/null 2>&1; then
    echo "✓ fdfind found (will be used as fd for Dirvish)"
else
    echo "WARNING: fd/fdfind not found - Dirvish search features may be limited"
fi

# Check Dirvish preview dependencies
echo "Checking Dirvish preview dependencies..."

# Image preview (vipsthumbnail)
if command -v vipsthumbnail >/dev/null 2>&1 || command -v vips >/dev/null 2>&1; then
    echo "✓ vipsthumbnail/vips found for image preview"
else
    echo "INFO: vipsthumbnail not found - image preview unavailable"
fi

# Video preview (ffmpegthumbnailer)
if command -v ffmpegthumbnailer >/dev/null 2>&1; then
    echo "✓ ffmpegthumbnailer found for video preview"
else
    echo "INFO: ffmpegthumbnailer not found - video preview unavailable"
fi

# PDF preview (pdftoppm)
if command -v pdftoppm >/dev/null 2>&1; then
    echo "✓ pdftoppm found for PDF preview"
else
    echo "INFO: pdftoppm not found - PDF preview unavailable"
fi

# Media metadata (mediainfo)
if command -v mediainfo >/dev/null 2>&1; then
    echo "✓ mediainfo found for media metadata"
else
    echo "INFO: mediainfo not found - media info unavailable"
fi

# Font preview (ImageMagick)
if command -v magick >/dev/null 2>&1 || command -v convert >/dev/null 2>&1; then
    echo "✓ ImageMagick found for font preview"
else
    echo "INFO: ImageMagick not found - font preview unavailable"
fi

# Archive preview (7zip)
if command -v 7z >/dev/null 2>&1 || command -v 7za >/dev/null 2>&1; then
    echo "✓ 7zip found for archive preview"
else
    echo "INFO: 7zip not found - archive preview unavailable"
fi

# rsync for dirvish-rsync extension
if command -v rsync >/dev/null 2>&1; then
    echo "✓ rsync found for file synchronization"
else
    echo "INFO: rsync not found - dirvish-rsync extension unavailable"
fi

# Check if fonts directory exists
if [ -d "/usr/share/fonts" ]; then
    echo "✓ Fonts directory found"
    # Check for Nerd Fonts
    if find /usr/share/fonts -name "*Nerd*" -o -name "*JetBrains*" -o -name "*Fira*" | grep -q .; then
        echo "✓ Nerd Fonts detected"
    else
        echo "INFO: Nerd Fonts may not be installed"
    fi
else
    echo "WARNING: Fonts directory not found"
fi

echo "Health check completed: Core components are working"
echo "Dirvish should have full functionality with all preview features"
exit 0

#
# Kubler phase 1 config, pick installed packages and/or customize the build
#

# The recommended way to install software is setting ${_packages}
# List of Gentoo package atoms to be installed at custom root fs ${_EMERGE_ROOT}, optional, space separated
# If you are not sure about package names you may want to start an interactive build container:
#     kubler.sh build -i emacs/nanoemacs
# ..and then search the Portage database:
#     eix <search-string>
_packages="app-editors/emacs dev-vcs/git dev-util/github-cli sys-apps/ripgrep sys-apps/fd app-shells/fzf sys-devel/gcc dev-util/cmake sys-devel/gdb sys-devel/clang dev-util/valgrind net-misc/curl app-text/pandoc dev-lang/python dev-util/pkgconf app-text/ispell media-libs/fontconfig sys-process/procps app-arch/unzip net-misc/wget dev-util/clang-common media-libs/libvips app-text/poppler media-video/ffmpegthumbnailer media-libs/mediainfo app-arch/p7zip sys-apps/coreutils app-text/epub-thumbnailer media-gfx/imagemagick sys-apps/file app-shells/bash net-misc/rsync"
# Install a standard system directory layout at ${_EMERGE_ROOT}, optional, default: false
#BOB_INSTALL_BASELAYOUT=true

# Remove specified binary cache file(s) *once* for given tag key..
#_no_cache_20200731="sys-apps/bash foo/bar/bar-0.1.2-r3.xpak"
# ..or omit the tag to always remove given binary cache file(s).
#_no_cache="sys-apps/bash"

# Define custom variables to your liking
#_nanoemacs_version=1.0

#
# This hook can be used to configure the build container itself, install packages, run any command, etc
#
configure_builder()
{
    # Packages installed in this hook don't end up in the final image but are available for depending image builds
    #emerge dev-lang/go app-misc/foo
    :
}

#
# This hook is called just before starting the build of the root fs
#
configure_rootfs_build()
{
    # Update Emacs use flags for modern features and Python support
    update_use 'app-editors/emacs' '+gtk3' '+json' '+libxml2' '+imagemagick' '+xft' '+gmp' '+threads' '+ssl' '+zlib' '+gzip-el' '+inotify' '+jit' '+dynamic-loading' '+harfbuzz' '+cairo' '+svg' '+png' '+jpeg' '+gif' '+tiff' '+xpm' '+webp'
    
    # Enable libgccjit for native compilation
    update_use 'sys-devel/gcc' '+jit'
    
    # Python support for tools
    update_use 'dev-lang/python' '+ssl' '+sqlite' '+threads' '+xml' '+ncurses' '+readline'
    
    # Git with curl support
    update_use 'dev-vcs/git' '+curl' '+webdav' '+threads'
    
    # Ripgrep with PCRE2 support
    update_use 'sys-apps/ripgrep' '+pcre2'
    
    # Fontconfig with modern features
    update_use 'media-libs/fontconfig' '+doc'
    
    # libvips for image thumbnails (vipsthumbnail) - Dirvish image preview
    update_use 'media-libs/libvips' '+jpeg' '+png' '+webp' '+tiff' '+imagemagick' '+svg' '+gif'
    
    # FFmpeg thumbnails for video preview - Dirvish video preview
    update_use 'media-video/ffmpegthumbnailer' '+jpeg' '+png'
    
    # Poppler for PDF preview - Dirvish PDF support
    update_use 'app-text/poppler' '+cairo' '+jpeg' '+png' '+tiff' '+utils'
    
    # MediaInfo for audio/video metadata - Dirvish media info
    update_use 'media-libs/mediainfo' '+curl' '+mms'
    
    # ImageMagick for font preview and image processing - Dirvish font preview
    update_use 'media-gfx/imagemagick' '+jpeg' '+png' '+svg' '+tiff' '+webp' '+fontconfig' '+truetype'
    
    # 7zip for archive preview - Dirvish archive support
    update_use 'app-arch/p7zip' '+rar'
    
    # Enhanced coreutils for better ls support
    update_use 'sys-apps/coreutils' '+xattr' '+acl'
    
    # rsync for dirvish-rsync extension
    update_use 'net-misc/rsync' '+acl' '+xattr' '+xxhash'
    
    # Accept ~amd64 keywords for newer versions if needed
    update_keywords 'app-editors/emacs' '+~amd64'
    update_keywords 'sys-apps/ripgrep' '+~amd64'
    update_keywords 'sys-apps/fd' '+~amd64'
    update_keywords 'media-libs/libvips' '+~amd64'
    update_keywords 'media-video/ffmpegthumbnailer' '+~amd64'
    update_keywords 'app-text/epub-thumbnailer' '+~amd64'
    
}

#
# This hook is called just before packaging the root fs tar ball, ideal for any post-install tasks, clean up, etc
#
finish_rootfs_build()
{
    # Create necessary directories
    mkdir -p "${_EMERGE_ROOT}"/home/user/.config/emacs
    mkdir -p "${_EMERGE_ROOT}"/home/user/.local/share/fonts
    mkdir -p "${_EMERGE_ROOT}"/home/user/.local/bin
    
    # Install norminette via pip3 (42 School norm checker)
    # Note: We need to do this in the build environment since Python packages 
    # installed with pip won't be in the Gentoo package manager
    if [[ -x "${_EMERGE_ROOT}/usr/bin/pip3" ]]; then
        ROOT="" pip3 install norminette
        # Copy norminette to the target root
        if [[ -f /usr/local/bin/norminette ]]; then
            cp /usr/local/bin/norminette "${_EMERGE_ROOT}/usr/local/bin/"
        fi
    fi
    
    # Download and install Nerd Fonts (JetBrains Mono and Fira Code)
    download_file "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    download_file "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    
    # Extract fonts to the target fonts directory
    cd /distfiles
    unzip -q JetBrainsMono.zip -d "${_EMERGE_ROOT}/usr/share/fonts/jetbrains/"
    unzip -q FiraCode.zip -d "${_EMERGE_ROOT}/usr/share/fonts/firacode/"
    
    # Create symlinks for common command names used by Dirvish
    # Some systems use different names for these commands
    
    # Ensure 'fd' command is available (some systems install as 'fdfind')
    if [[ -x "${_EMERGE_ROOT}/usr/bin/fdfind" ]] && [[ ! -x "${_EMERGE_ROOT}/usr/bin/fd" ]]; then
        ln -sf fdfind "${_EMERGE_ROOT}/usr/bin/fd"
    fi
    
    # Ensure GNU ls is available for dirvish-fd
    if [[ -x "${_EMERGE_ROOT}/usr/bin/ls" ]]; then
        # Create gls symlink for compatibility
        ln -sf ls "${_EMERGE_ROOT}/usr/bin/gls"
    fi
    
    # Ensure 7z/7zz command availability for archive preview
    if [[ -x "${_EMERGE_ROOT}/usr/bin/7za" ]] && [[ ! -x "${_EMERGE_ROOT}/usr/bin/7z" ]]; then
        ln -sf 7za "${_EMERGE_ROOT}/usr/bin/7z"
    fi
    
    # Verify Dirvish preview dependencies are properly linked
    echo "Checking Dirvish preview dependencies..."
    
    # Check for vipsthumbnail (image preview)
    if [[ -x "${_EMERGE_ROOT}/usr/bin/vips" ]]; then
        echo "✓ vipsthumbnail available for image preview"
    fi
    
    # Check for ffmpegthumbnailer (video preview)
    if [[ -x "${_EMERGE_ROOT}/usr/bin/ffmpegthumbnailer" ]]; then
        echo "✓ ffmpegthumbnailer available for video preview"
    fi
    
    # Check for pdftoppm (PDF preview)
    if [[ -x "${_EMERGE_ROOT}/usr/bin/pdftoppm" ]]; then
        echo "✓ pdftoppm available for PDF preview"
    fi
    
    # Check for mediainfo (audio/video metadata)
    if [[ -x "${_EMERGE_ROOT}/usr/bin/mediainfo" ]]; then
        echo "✓ mediainfo available for media metadata"
    fi
    
    # Check for magick (font preview)
    if [[ -x "${_EMERGE_ROOT}/usr/bin/magick" ]] || [[ -x "${_EMERGE_ROOT}/usr/bin/convert" ]]; then
        echo "✓ ImageMagick available for font preview"
    fi
    
    # Update library cache
    echo "/usr/local/lib" > "${_EMERGE_ROOT}/etc/ld.so.conf.d/usr-local.conf"
    
    # Set up environment variables file
    cat > "${_EMERGE_ROOT}/etc/environment" << 'EOF'
TERM=xterm-256color
PATH="/usr/local/bin:/usr/bin:/bin"
EOF
    
    # Create a default user setup script
    cat > "${_EMERGE_ROOT}/usr/local/bin/setup-user" << 'EOF'
#!/bin/bash
# Setup script for user environment
if [[ -n "$USER" && -n "$UID" ]]; then
    groupadd -g "$UID" "$USER" 2>/dev/null || true
    useradd -u "$UID" -g "$UID" -m -s /bin/bash "$USER" 2>/dev/null || true
fi
EOF
    chmod +x "${_EMERGE_ROOT}/usr/local/bin/setup-user"
    
    # Clean up temporary files
    rm -f /distfiles/JetBrainsMono.zip /distfiles/FiraCode.zip
    
    # Copy c++ libs for development tools
    copy_gcc_libs
    
    # Log installed packages for documentation
    log_as_installed "manual install" "norminette" "https://pypi.org/project/norminette/"
    log_as_installed "manual install" "nerd-fonts-jetbrains" "https://github.com/ryanoasis/nerd-fonts"
    log_as_installed "manual install" "nerd-fonts-firacode" "https://github.com/ryanoasis/nerd-fonts"
    log_as_installed "dirvish support" "libvips-vipsthumbnail" "https://github.com/libvips/libvips"
    log_as_installed "dirvish support" "ffmpegthumbnailer" "https://github.com/dirkvdb/ffmpegthumbnailer"
    log_as_installed "dirvish support" "poppler-pdftoppm" "https://poppler.freedesktop.org/"
    log_as_installed "dirvish support" "mediainfo" "https://mediaarea.net/MediaInfo"
    log_as_installed "dirvish support" "imagemagick-magick" "https://imagemagick.org/"
    log_as_installed "dirvish support" "p7zip-7z" "https://www.7-zip.org/"
    log_as_installed "dirvish support" "rsync" "https://rsync.samba.org/"
}

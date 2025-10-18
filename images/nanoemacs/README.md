## emacs/nanoemacs

A lightweight Docker image with Emacs and essential development tools for coding, optimized for nano Emacs configuration, 42 School projects, and **full Dirvish support**.

### Features

- **Modern Emacs** with native compilation support (libgccjit)
- **Development Tools**: GCC, Clang, CMake, GDB, Valgrind
- **Search Tools**: ripgrep, fd-find, fzf
- **42 School Support**: norminette, essential C development tools
- **Modern Fonts**: JetBrains Mono and Fira Code Nerd Fonts
- **Full Dirvish Support**: Complete file manager with all preview features
- **Minimal Size**: Built on Gentoo with Kubler for optimal image size

### Dirvish Preview Support

This image includes **complete support** for all Dirvish preview features:

#### Image Preview

- **vipsthumbnail** - Fast image thumbnails (JPEG, PNG, WebP, TIFF, SVG)
- **ImageMagick** - Advanced image processing and font preview

#### Video Preview

- **ffmpegthumbnailer** - Video thumbnail generation (MP4, MKV, WebM, etc.)

#### Document Preview

- **pdftoppm** - PDF document thumbnails
- **epub-thumbnailer** - EPUB document preview

#### Media Information

- **mediainfo** - Audio/video metadata display

#### Archive Support

- **7zip** - Archive contents preview (ZIP, 7Z, RAR, TAR, etc.)

#### File Management

- **rsync** - Advanced file synchronization (dirvish-rsync extension)
- **GNU ls** - Full compatibility with Dirvish listing features
- **fd** - Ultra-fast file search (core Dirvish dependency)

### Usage

Run this [nanoemacs][] image with:

```bash
# Basic usage
docker run -it --rm emacs/nanoemacs

# With volume mount for your projects
docker run -it --rm -v $(pwd):/workspace emacs/nanoemacs

# With user UID/GID mapping
docker run -it --rm -e UID=$(id -u) -e USER=$(whoami) emacs/nanoemacs

# For GUI applications (X11 forwarding on Linux)
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v $(pwd):/workspace \
  emacs/nanoemacs
```

### Dirvish Configuration Example

Once inside the container, you can configure Dirvish with all features:

```elisp
(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :config
  ;; Enable all preview features
  (setq dirvish-preview-dispatchers
        '(image gif video audio epub archive font pdf))
  
  ;; Full attribute set with icons and metadata
  (setq dirvish-attributes
        '(vc-state subtree-state nerd-icons collapse 
          git-msg file-time file-size))
  
  ;; Enable peek mode for minibuffer previews
  (dirvish-peek-mode)
  
  ;; Optional: side window follow mode
  (dirvish-side-follow-mode))
```

### Building

This image is built using [Kubler](https://github.com/edannenberg/kubler):

```bash
kubler build emacs/nanoemacs
```

### Dependency Matrix

| Feature | Tool | Status | Purpose |
|---------|------|--------|---------|
| Core Search | `fd` | ✅ | Fast file search, directory navigation |
| Image Preview | `vipsthumbnail` | ✅ | Image thumbnails and preview |
| Video Preview | `ffmpegthumbnailer` | ✅ | Video thumbnail generation |
| PDF Preview | `pdftoppm` | ✅ | PDF document thumbnails |
| Media Info | `mediainfo` | ✅ | Audio/video metadata |
| Font Preview | `magick/convert` | ✅ | Font file preview |
| Archive Preview | `7z/7za` | ✅ | Archive contents listing |
| File Sync | `rsync` | ✅ | Advanced file operations |
| EPUB Preview | `epub-thumbnailer` | ✅ | EPUB document preview |
| GNU Utils | `gls` (GNU ls) | ✅ | Compatible directory listing |

[Last Build][packages]

[nanoemacs]: https://github.com/carlosalberto-filho/nanoemacs
[packages]: PACKAGES.md

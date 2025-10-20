# NanoEmacs - Lightweight Docker Image

A minimal, optimized Docker image with Emacs and essential development tools, built with [Kubler](https://github.com/edannenberg/kubler) for maximum efficiency and minimal size.

## 🎯 Mission Statement

Provide a lightweight, modern Emacs development environment specifically optimized for:

- **42 School Projects** - Complete C/C++ development stack with norminette
- **Modern Development** - Fast search tools, native compilation, and modern fonts
- **Minimal Footprint** - Gentoo-based with only essential packages
- **Professional Workflow** - Git, debugging tools, and development utilities

## 📦 What's Included

### Core Editor

- **Emacs** with native compilation support (libgccjit)
- **Modern UI** features: GTK3, JSON, XML, ImageMagick, Cairo, SVG
- **Performance** optimizations: JIT compilation, threading, dynamic loading

### Development Tools

- **Compilers**: GCC (with JIT), Clang, ClangD
- **Build Systems**: CMake, Make, PKG-Config
- **Debugging**: GDB, Valgrind
- **Memory Analysis**: Built-in leak detection tools

### Modern CLI Tools

- **ripgrep** - Ultra-fast text search with PCRE2 support
- **fd-find** - Modern alternative to `find`
- **fzf** - Fuzzy finder for enhanced productivity

### 42 School Support

- **norminette** - Official 42 School norm checker
- **Complete C stack** - Everything needed for 42 projects
- **ispell** - Spell checking for documentation

### Fonts & UI

- **JetBrains Mono Nerd Font** - Modern coding font with icons
- **Fira Code Nerd Font** - Alternative font with ligatures
- **Fontconfig** - Proper font rendering and management

### Version Control & Utilities

- **Git** with curl and WebDAV support
- **Python 3** with SSL, SQLite, and development tools
- **Pandoc** - Document conversion and processing
- **Curl/Wget** - Network utilities

## 🚀 Quick Start

### Building the Image

```bash
# Clone and navigate to the project
cd /path/to/emacs-kubler-project

# Build the image (first build may take 15-30 minutes)
kubler build emacs/nanoemacs

# Build with tests
kubler build emacs/nanoemacs -t

# Interactive build for debugging
kubler build emacs/nanoemacs -i
```

## 🛠 Development Workflow

### 42 School Projects

```bash
# Navigate to your project
cd /workspace/your-42-project

# Check norm compliance
norminette *.c *.h

# Compile with debugging
gcc -Wall -Wextra -Werror -g your_program.c

# Debug with GDB
gdb ./a.out

# Memory check with Valgrind
valgrind --leak-check=full ./a.out
```

### Modern Development Tools

```bash
# Fast file search
fd "\.c$" | head -10

# Content search with context
rg "function_name" --context 3

# Interactive file/content search
fzf --preview 'cat {}'

# Git operations
git status
git log --oneline | head -10
```

## ⚙ Configuration

### Environment Variables

- `USER` - Username for container user (default: user)
- `UID` - User ID for mapping host permissions (default: 1000)
- `TERM` - Terminal type (default: xterm-256color)
- `TZ` - Timezone (default: America/Sao_Paulo)

### Volume Mounts

- `/workspace` - Recommended mount point for projects
- `/home/user/.config/emacs` - Emacs configuration directory
- `/home/user/.gnupg` - GPG configuration (auto-created)

## 🏗 Architecture & Build Process

This image uses Kubler's two-phase build process:

1. **Phase 1**: Gentoo package installation in build container
   - Installs packages with optimized USE flags
   - Creates minimal rootfs with only necessary files
   - Preserves build state for dependency chain

2. **Phase 2**: Docker image creation
   - Adds rootfs.tar to base image
   - Configures runtime environment
   - Sets up user permissions and paths

### Build Optimization Features

- **Binary Package Cache** - Subsequent builds are much faster
- **Dependency Management** - Automatic resolution of package dependencies
- **USE Flag Optimization** - Only needed features are compiled
- **Layer Efficiency** - Minimal layers for smaller images

## 📊 Image Comparison

| Feature | Debian-based | Kubler-based |
|---------|--------------|--------------|
| Base Size | ~1.2GB | ~400MB |
| Build Time (first) | 10 min | 25 min |
| Build Time (cached) | 8 min | 2 min |
| Package Control | Limited | Complete |
| Security Updates | Auto | Controlled |
| Customization | Medium | Extensive |

## 🔧 Customization

### Adding Packages

Edit `images/nanoemacs/build.sh` and add to `_packages`:

```bash
_packages="app-editors/emacs dev-your/package"
```

### Custom USE Flags

In the `configure_rootfs_build()` function:

```bash
update_use 'category/package' '+feature' '-unwanted'
```

### Runtime Configuration

Modify `Dockerfile.template` for startup customizations.

## 🧪 Testing

The image includes comprehensive testing:

```bash
# Run build tests
kubler build -C emacs/nanoemacs -i

# Manual health check
docker run --rm emacs/nanoemacs docker-healthcheck

# Interactive testing
docker run -it --rm emacs/nanoemacs bash
```

## 📋 Requirements

### Host System

- **Docker** or **Podman** with BuildKit support
- **Kubler** 0.9.12+ installed
- **Git** for repository management
- **Bash** 4.4+ (required by Kubler)

### Build Resources

- **CPU**: 4+ cores recommended for faster builds
- **RAM**: 4GB minimum, 8GB recommended
- **Disk**: 10GB free space for build cache
- **Network**: Stable connection for package downloads

## 🔑 Gentoo GPG Keys

Para builds confiáveis, é necessário importar as chaves GPG oficiais do Gentoo.  
Execute o comando abaixo **antes de rodar o Kubler** (recomendado pela [documentação oficial](https://www.gentoo.org/downloads/signatures/)):

```bash
wget -O - https://qa-reports.gentoo.org/output/service-keys.gpg | gpg --import
```

Se preferir **desabilitar a verificação GPG** (menos seguro, não recomendado para produção), descomente a linha abaixo no arquivo `kubler.conf`:

```bash
# Effectively always enables -s for the build command
KUBLER_DISABLE_GPG='true'
```

> **⚠️ Nota:** O uso das chaves GPG garante a autenticidade dos snapshots e pacotes baixados durante o build. Desabilitar a verificação GPG só é recomendado para desenvolvimento/testes.

## 🚨 Troubleshooting

### Common Issues

#### Build fails with "Operation not permitted"

```bash
# Add to build.conf:
BUILDER_CAPS_SYS_PTRACE='true'
```

#### Library not found errors

```bash
# Add to Dockerfile.template:
RUN ldconfig
```

#### Package not found

```bash
# Search interactively:
kubler build -i emacs/nanoemacs
# In container: eix package-name
```

### Interactive Debugging

```bash
# Start interactive build
kubler build -i emacs/nanoemacs

# In container:
emerge --search keyword
eix package-name
emerge -pv package-name
```

## 📚 Resources

- [Kubler Documentation](https://github.com/edannenberg/kubler)
- [Gentoo Package Database](https://packages.gentoo.org/)
- [Emacs Manual](https://www.gnu.org/software/emacs/manual/)
- [42 School Norminette](https://github.com/42School/norminette)

## 👥 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build: `kubler build emacs/nanoemacs -t`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Maintainer**: Carlos Alberto Filho <carlosalberto_filho@outlook.com>

Built with ❤️ using Kubler and Gentoo for maximum efficiency

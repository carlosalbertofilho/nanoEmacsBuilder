## emacs/nanoemacs

A lightweight Docker image with Emacs and essential development tools for coding, optimized for nano Emacs configuration and 42 School projects.

### Features

- **Modern Emacs** with native compilation support (libgccjit)
- **Development Tools**: GCC, Clang, CMake, GDB, Valgrind
- **Search Tools**: ripgrep, fd-find, fzf
- **42 School Support**: norminette, essential C development tools
- **Modern Fonts**: JetBrains Mono and Fira Code Nerd Fonts
- **Minimal Size**: Built on Gentoo with Kubler for optimal image size

### Usage

Run this [nanoemacs][] image with:

```bash
# Basic usage
docker run -it --rm emacs/nanoemacs

# With volume mount for your projects
docker run -it --rm -v $(pwd):/workspace emacs/nanoemacs

# With user UID/GID mapping
docker run -it --rm -e UID=$(id -u) -e USER=$(whoami) emacs/nanoemacs
```

### Building

This image is built using [Kubler](https://github.com/edannenberg/kubler):

```bash
kubler build emacs/nanoemacs
```

[Last Build][packages]

[nanoemacs]: https://github.com/carlosalberto-filho/nanoemacs
[packages]: PACKAGES.md

# 💤 NeoVim + LazyVim - Custom Environment

A supercharged NeoVim environment built on top of [LazyVim](https://www.lazyvim.org/), tailored for Data Science, Research, and DevOps workflows.

## 🚀 Key Features

### 🔬 Data Science & Research
A robust environment for interactive computing and scientific publishing:
- **Interactive Notebooks**: [Molten-nvim](https://github.com/benlubas/molten-nvim) provides a Jupyter kernel interface directly in Neovim for Python, Quarto, and more.
- **Quarto Support**: Full integration with [Quarto](https://quarto.org/) via `quarto-nvim` for scientific writing and publishing (`.qmd` support).
- **Inline Images**: [Image.nvim](https://github.com/3rd/image.nvim) enables rendering images directly in the buffer (Markdown, Quarto, Jupyter outputs). **Note:** Configured for the **Kitty** terminal backend.
- **REPL Integration**: [Vim-Slime](https://github.com/jpalardy/vim-slime) for sending code chunks to a terminal or REPL.

### 🤖 AI Integration
- **Microsoft Copilot Chat**: Deep integration for AI-assisted coding and explanations.

### 🐳 DevOps & Containers
- **DevContainers**: Native support for [DevContainers](https://containers.dev/) via `nvim-dev-container`.
  - Includes image caching.
  - Automatically mounts your local Neovim configuration into the container.

### 🛠️ Languages & Tools
Extensive support for:
- **Languages**: Python, Java (`nvim-jdtls`), Rust (`rustaceanvim`), Go, TypeScript, CMake, YAML, JSON, LaTeX, Dafny.
- **LeetCode**: [Leetcode.nvim](https://github.com/kawre/leetcode.nvim) integration for practicing algorithms directly in the editor.
- **Formatters & Linters**: Preconfigured Prettier and ESLint.

### 🎨 Visuals & Quality of Life
- **Dashboard**: Custom [Snacks.nvim](https://github.com/folke/snacks.nvim) dashboard featuring random ASCII art headers.
- **File Picker**: Enhanced picker layout with filename-first display.
- **Image Clipboard**: Paste images directly from the clipboard.

## ⌨️ Key Keymaps

### Data Science (Quarto/Molten)
| Key | Description |
|---|---|
| `<LocalLeader>mi` | Initialize Molten kernel |
| `<LocalLeader>rc` | Run current cell |
| `<LocalLeader>ra` | Run current cell and above |
| `<LocalLeader>rA` | Run all cells |
| `<LocalLeader>r` | Run visual selection |
| `<LocalLeader>mx` | Open output in browser |

*(Note: `<LocalLeader>` is typically `\`)*

## 📋 Requirements
- **Neovim** >= 0.9.0
- **Nerd Font** (for icons)
- **Kitty Terminal** (Highly recommended for image support)
- **ImageMagick** (Required for image rendering backend)

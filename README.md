# WezTerm Configuration Setup

This repository contains my personal WezTerm configuration with a Gruvbox Material theme, PowerShell integration, and various quality-of-life features.

## Prerequisites

### 1. Install Scoop Package Manager
Open PowerShell and run:
```powershell
# Set execution policy to allow scripts
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install Scoop
irm get.scoop.sh | iex
```

### 2. Install Required Software
```powershell
# Install PowerShell Core
scoop install pwsh

# Add the nerd-fonts bucket and install FiraCode
scoop bucket add nerd-fonts
scoop install FiraCode-NF

# Install Neovim (optional - needed for some features)
scoop install neovim
```

### 3. Install PSReadLine Module
Open PowerShell and run:
```powershell
Install-Module PSReadLine -Force
```

## Installation

1. Create the WezTerm configuration directory:
```powershell
# Create .config directory in your user folder
mkdir -p "$env:USERPROFILE\.config"

# Change to that directory
cd "$env:USERPROFILE\.config"
```

2. Clone this repository:
```powershell
git clone git@github.com:Benjamin-Argo/Wezterm.git wezterm
```

## Features

- Gruvbox Material color scheme
- FiraCode Nerd Font integration
- PowerShell Core configuration with custom prompt
- Vim/Neovim detection for advanced features
- Pane management shortcuts:
  - ALT + - : Split vertically
  - ALT + \ : Split horizontally
  - ALT + Arrow Keys: Navigate between panes
- Quick actions:
  - CTRL + SHIFT + W: Open config in Neovim
  - CTRL + ALT + D: Toggle window decorations
  - CTRL + ; : Toggle terminal
  - CTRL + T: Toggle focus

## Customization

The configuration file is located at `~/.config/wezterm/wezterm.lua`. Feel free to modify it to suit your needs.

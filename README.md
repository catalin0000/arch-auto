# CyberDeck

## Description

CyberDeck is a script designed for setting up a web pentesting environment. It installs a wide range of essential tools for network reconnaissance, vulnerability analysis, exploitation, and is specifically tailored to web security testing.

## Features

- **Compatibility:** Works with both Debian-based systems and Arch Linux.
- **Bug Bounty Toolset:** Installs a variety of tools covering different aspects of cybersecurity, including reconnaissance, scanning, exploitation, and more.
- **Automated Installation:** Streamlines the setup process, saving time and reducing manual effort.

## Prerequisites

- Linux-based system (Debian-based or Arch Linux)
- Stable Internet connection
- Sufficient user permissions (root or sudo access)

## Installation

1. Clone the repository and run script:
   ```bash
   git clone https://github.com/Martian1337/CyberDeck.git && cd CyberDeck && chmod +x install.sh && ./install.sh

**OR**

2. Run script directly via curl:
```bash
curl -sSL https://github.com/Martian1337/CyberDeck/install.sh | sudo bash
```

## Tool List

Here's a non-exhaustive list of the tools included in this installer:

- **Reconnaissance Tools:** `Amass`, `Masscan`, `Massdns`, `ReconFTW`
- **Scanning Tools:** `Nmap`, `RustScan`
- **Web Application Analysis:** `WhatWeb`, `Wappalyzer`
- **Content Discovery:** `Gobuster`, `Dirsearch`, `Feroxbuster`
- **Exploitation Tools:** `SQLmap`, `Commix`
- And more...

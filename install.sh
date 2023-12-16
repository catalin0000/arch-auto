#!/bin/bash

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Function to install packages using apt, pacman, or yay
install_package () {
    if command_exists apt; then
        sudo apt install -y "$@"
    elif command_exists pacman; then
        if command_exists yay; then
            yay -S --noconfirm "$@"
        else
            sudo pacman -S --noconfirm "$@"
        fi
    else
        echo "Error: Package manager not supported. Install packages manually."
        exit 1
    fi
}

# Install Python packages using pacman on Arch or pip on other systems
install_python_package () {
    local package_name=$1
    if command_exists pacman; then
        # Attempt to install using pacman. If not available, use pip3.
        if yay -Ss "python-$package_name" > /dev/null; then
            yay -S "python-$package_name" --noconfirm
        else
            sudo pip3 install "$package_name"
        fi
    else
        sudo pip3 install "$package_name"
    fi
}

# Install snapd using the appropriate method
if command_exists pacman; then
    # Install yay if not present
    if ! command_exists yay; then
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ..
        rm -rf yay
    fi

    # Install snapd using yay
    yay -S snapd --noconfirm
    sudo systemctl enable --now snapd.socket
    # Create a symbolic link if it doesn't exist
    sudo ln -s /var/lib/snapd/snap /snap
else
    install_package snapd
fi

# Install Golang using snap
sudo snap install go --classic

# Set environment variables for Go
export GOROOT=/snap/go/current
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Install other dependencies
install_package ruby npm nodejs jdk-openjdk wget

# Additional steps for Arch Linux
if command_exists pacman; then
    # Install Rust using rustup
    yay -S rustup --noconfirm
    rustup default stable
else
    # Install Rust for non-Arch systems
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Recon Tools Installation
install_package amass masscan
if command_exists pacman; then
    yay -S massdns libldns naabu --noconfirm
else
    install_package massdns libldns-dev naabu
fi

# Install GO ready tools: chaos-client and uncover
sudo go install github.com/projectdiscovery/chaos-client/cmd/chaos@latest
sudo cp /root/go/bin/chaos /usr/local/bin
sudo go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
sudo cp /root/go/bin/uncover /usr/local/bin


# Create a directory for recon tools
mkdir -p recon-tools
cd recon-tools

# Install Findomain
if command_exists pacman; then
    yay -S findomain --noconfirm
else
    curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
    unzip findomain-linux-i386.zip
    chmod +x findomain
    sudo mv findomain /usr/bin/findomain
    rm findomain-linux-i386.zip
fi

# Install domained
git clone https://github.com/cakinney/domained.git
cd domained
sudo python3 domained.py --install
install_python_package requirements
cd ..

# Install ReconFTW
git clone https://github.com/six2dez/reconftw
cd reconftw/
sudo ./install.sh
cd ..

# Install masscan and nmap
install_package git gcc make libpcap-dev masscan nmap

# Install RustScan
cargo install rustscan

# Screenshot tools installation
install_package eyewitness witnessme

# Install aquatone
sudo go install github.com/michenriksen/aquatone@latest
sudo cp /root/go/bin/aquatone /usr/local/bin

# Install gowitness
sudo go install github.com/sensepost/gowitness@latest
sudo cp /root/go/bin/gowitness /usr/local/bin

# Technology identification tools installation
sudo npm install -g wappalyzer retire

# Install webanalyze
sudo go install github.com/rverton/webanalyze/cmd/webanalyze@latest
sudo cp /root/go/bin/webanalyze /usr/local/bin

# Install httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo cp /root/go/bin/httpx /usr/local/bin

# Install WhatWeb
install_package whatweb

# Content discovery tools installation
install_package gobuster dirsearch dirb dirbuster

# Install recursebuster, gospider, hakrawler
sudo go install github.com/c-sto/recursebuster@latest
sudo cp /root/go/bin/resursebuster /usr/local/bin
sudo go install github.com/jaeles-project/gospider@latest
sudo cp /root/go/bin/gospider /usr/local/bin
sudo go install github.com/hakluke/hakrawler@latest
sudo cp /root/go/bin/hakrawler /usr/local/bin

# Install feroxbuster
cargo install feroxbuster

# Link analysis tools installation
install_package getallurls

# Install waybackurls
sudo go install github.com/tomnomnom/waybackurls@latest
sudo cp /root/go/bin/waybackurls /usr/local/bin

# Parameter analysis tool installation
install_package arjun

# Fuzzing tools installation
install_package wfuzz ffuf

# Install qsfuzz and vaf
sudo go install github.com/ameenmaali/qsfuzz@latest
sudo cp /root/go/bin/qfuzz /usr/local/bin
sudo go install github.com/daffainfo/vaf@latest
sudo cp /root/go/bin/vaf /usr/local/bin
cd ..

# Exploitation tools setup
# Create directory for exploitation tools
mkdir -p exploitation-tools
cd exploitation-tools

# CORS Misconfiguration tool installation
install_python_package corscanner

# CRLF Injection tools installation
install_python_package crlfsuite
sudo go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest
sudo cp /root/go/bin/crlfuzz /usr/local/bin

# CSRF Injection tool installation
install_python_package xsrfprobe

# Insecure Deserialization tool installation
git clone https://github.com/frohoff/ysoserial.git

# Server Side Request Forgery (SSRF) tool installation
git clone https://github.com/swisskyrepo/SSRFmap
cd SSRFmap/
install_python_package requirements
cd ..

# SQL Injection tool installation
install_package sqlmap
# Ghauri Installation
echo "Installing Ghauri..."
git clone https://github.com/r0oth3x49/ghauri.git
cd ghauri
# Ensure Python and pip are installed
install_package python
if command_exists pacman; then
    # Install pip using pacman if on Arch Linux
    install_package python-pip
else
    # Ensure pip is installed on Debian-based system
    install_python_package pip
fi
# Install Python requirements for Ghauri
while IFS= read -r requirement; do
    install_python_package "${requirement}"
done < requirements.txt
# Install Ghauri
python3 setup.py install
cd ..

# Install NoSQLMap
git clone https://github.com/codingo/NoSQLMap.git
cd NoSQLMap
sudo python setup.py install
cd ..

# XSS Injection tool installation
install_package xsser xsstrike

# Install HuntKit Docker
docker pull mcnamee/huntkit

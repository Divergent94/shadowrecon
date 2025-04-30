#!/bin/bash

# ShadowRecon Install Script

# ---- Banner ----
echo -e "\e[34m[+] Installing ShadowRecon...\e[0m"

# ---- Check for sudo ----
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31m[-] Please run this script as root or with sudo.\e[0m"
  exit 1
fi

# ---- Install required packages ----
echo -e "\e[34m[+] Installing required packages...\e[0m"
apt update && apt install -y git curl wget unzip

# ---- Install Go if not found ----
if ! command -v go &> /dev/null; then
  echo -e "\e[34m[+] Go not found. Installing...\e[0m"
  wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  source ~/.bashrc
  rm go1.22.2.linux-amd64.tar.gz
fi

# ---- Install Go-based tools ----
echo -e "\e[34m[+] Installing subfinder, assetfinder, and httpx...\e[0m"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# ---- Make shadowrecon.sh executable ----
chmod +x shadowrecon.sh

# ---- Optional: Create a symlink to /usr/local/bin ----
ln -sf "$(pwd)/shadowrecon.sh" /usr/local/bin/shadowrecon

# ---- Done ----
echo -e "\e[32m[✓] ShadowRecon installed successfully!"
echo -e "    You can now run it using: \e[1mshadowrecon -d example.com\e[0m"

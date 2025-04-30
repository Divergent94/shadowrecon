#!/bin/bash

# ShadowRecon - Subdomain Enumeration Module
# Author: K Akash Verma
# Version: 1.0

# ---- ASCII Banner ----
print_banner() {
cat << "EOF"

███████╗██╗  ██╗ █████╗ ██████╗  ██████╗ ██╗    ██╗██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗██╔═══██╗██║    ██║██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║
███████╗███████║███████║██║  ██║██║   ██║██║ █╗ ██║██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║
╚════██║██╔══██║██╔══██║██║  ██║██║   ██║██║███╗██║██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║
███████║██║  ██║██║  ██║██████╔╝╚██████╔╝╚███╔███╔╝██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝

EOF
}

# ---- Colors ----
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# ---- Usage Function ----
usage() {
  echo -e "${YELLOW}Usage: $0 -d domain.com [-s] [-p] [-t tools] [-e exclude_tools]${RESET}"
  echo "  -d DOMAIN         Target domain"
  echo "  -s                Silent mode (no stdout, log only)"
  echo "  -p                Probe for live subdomains (requires httpx)"
  echo "  -t TOOLS          Comma-separated list of tools to use"
  echo "  -e EXCLUDE        Comma-separated list of tools to exclude"
  echo "  -h                Show this help"
  exit 1
}

# ---- Defaults ----
DOMAIN=""
SILENT=false
PROBE=false
INCLUDE_TOOLS=()
EXCLUDE_TOOLS=()
TOOLS_ALL=("subfinder" "assetfinder")

# ---- Argument Parsing ----
while getopts ":d:spht:e:" opt; do
  case ${opt} in
    d) DOMAIN="$OPTARG" ;;
    s) SILENT=true ;;
    p) PROBE=true ;;
    t) IFS=',' read -ra INCLUDE_TOOLS <<< "$OPTARG" ;;
    e) IFS=',' read -ra EXCLUDE_TOOLS <<< "$OPTARG" ;;
    h) usage ;;
    \?) echo -e "${RED}Invalid option: -$OPTARG${RESET}" >&2; usage ;;
    :) echo -e "${RED}Option -$OPTARG requires an argument.${RESET}" >&2; usage ;;
  esac
done

# ---- Check Domain ----
if [[ -z "$DOMAIN" ]]; then
  echo -e "${RED}[-] Domain not provided${RESET}"
  usage
fi

# ---- Output Setup ----
OUTPUT_DIR="results/$DOMAIN/subdomains"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/all.txt"

# ---- Silent Mode Log ----
log() {
  $SILENT || echo -e "$1"
}

# ---- Tool Commands ----
run_subfinder() {
  log "${GREEN}[+] Running subfinder...${RESET}"
  subfinder -d "$DOMAIN" -silent -o "$OUTPUT_DIR/subfinder.txt"
}

run_assetfinder() {
  log "${GREEN}[+] Running assetfinder...${RESET}"
  assetfinder --subs-only "$DOMAIN" | tee "$OUTPUT_DIR/assetfinder.txt" >/dev/null
}

# ---- Run Selected Tools ----
run_selected_tools() {
  local tools=("${TOOLS_ALL[@]}")
  [[ ${#INCLUDE_TOOLS[@]} -gt 0 ]] && tools=("${INCLUDE_TOOLS[@]}")

  for exclude in "${EXCLUDE_TOOLS[@]}"; do
    tools=("${tools[@]/$exclude}")
  done

  declare -A TOOL_COMMANDS=(
    [subfinder]=run_subfinder
    [assetfinder]=run_assetfinder
  )

  for tool in "${tools[@]}"; do
    if [[ -n "${TOOL_COMMANDS[$tool]}" ]]; then
      (${TOOL_COMMANDS[$tool]}) &
    else
      log "${YELLOW}[!] Unknown or unsupported tool: $tool${RESET}"
    fi
  done
  wait
}

# ---- Combine Results ----
combine_results() {
  log "${GREEN}[+] Combining results...${RESET}"
  cat "$OUTPUT_DIR"/*.txt | sort -u > "$OUTPUT_FILE"
  log "${GREEN}[+] Total unique subdomains found: $(wc -l < "$OUTPUT_FILE")${RESET}"
}

# ---- Probe Live ----
probe_http() {
  log "${GREEN}[+] Probing for live subdomains with httpx...${RESET}"
  httpx -silent -l "$OUTPUT_FILE" -o "$OUTPUT_DIR/live.txt"
  log "${GREEN}[+] Live subdomains: $(wc -l < "$OUTPUT_DIR/live.txt")${RESET}"
}

# ---- Main Execution ----
print_banner
log "${GREEN}[*] Starting Subdomain Enumeration for: $DOMAIN${RESET}"
run_selected_tools
combine_results
$PROBE && probe_http
log "${GREEN}[✓] Subdomain enumeration complete. Results saved in ${OUTPUT_DIR}${RESET}"

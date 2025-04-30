## 🌑 ShadowRecon


███████╗██╗  ██╗ █████╗ ██████╗  ██████╗ ██╗    ██╗██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗
██╔════╝██║  ██║██╔══██╗██╔══██╗██╔═══██╗██║    ██║██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║
███████╗███████║███████║██║  ██║██║   ██║██║ █╗ ██║██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║
╚════██║██╔══██║██╔══██║██║  ██║██║   ██║██║███╗██║██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║
███████║██║  ██║██║  ██║██████╔╝╚██████╔╝╚███╔███╔╝██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝


### ⚡ Description

*ShadowRecon* is a modular, open-source bug bounty reconnaissance and scanning toolkit designed to automate and accelerate the process of discovering security issues in web applications. Starting with subdomain enumeration, it aims to grow into a full-spectrum scanning framework with vulnerability discovery, reporting, and automation for unique attack surfaces.

This project is not a one-time release — it's a long-term learning initiative and automation platform. It will continue to evolve as I apply real-world experience from vulnerabilities that have provided significant rewards. Developers, testers, researchers, and bug bounty hunters can all leverage ShadowRecon to secure and assess their assets.

---

### ✨ Features

- ✅ Subdomain enumeration (modular, silent mode, selective tool usage)
- ✅ Live subdomain probing using httpx
- ✅ Parallel execution for speed
- ✅ Tool inclusion/exclusion via CLI
- 🚧 More modules coming soon:
  - Vulnerability scanning
  - OWASP Top 10 automation
  - Screenshots & fuzzing
  - Unique exploit automations
  - Reporting & alerting

---

### 🛠 Installation

Clone the repository and run the installer script:

bash
git clone https://github.com/yourusername/ShadowRecon.git
cd ShadowRecon
chmod +x install.sh
./install.sh


Ensure the following tools are installed (the script installs most of them if not present):

- subfinder
- assetfinder
- httpx

---

### 🧪 Usage

bash
./shadowrecon.sh -d example.com


*Options:*
- -d Target domain (required)
- -s Silent mode (suppress output)
- -p Probe live subdomains using httpx
- -t Comma-separated list of tools to use (subfinder,assetfinder)
- -e Comma-separated list of tools to exclude
- -h Show help

*Example:*
bash
./shadowrecon.sh -d example.com -s -p -t subfinder,assetfinder


---

### 📁 Output

All results are saved in results/<domain>/subdomains with:
- all.txt – combined subdomains
- live.txt – live probed subdomains (if -p used)

---

### 📈 Roadmap

This project will keep expanding. Here's what's coming next:
- 🚀 Vulnerability scanning modules (XSS, SSRF, IDOR, etc.)
- 🧠 OWASP Top 10 test automation
- 💸 Real-world vulnerability scripts based on my paid reports
- 📸 Visual recon & screenshots
- 📊 Integration with reporting platforms (like Slack, Discord, etc.)

> I’m building this not only for myself but for the community. Whether you're a researcher or dev team, ShadowRecon will help you uncover, understand, and fix security issues effectively.

---

### 🤝 Contributions

Pull requests are welcome! If you have tools, ideas, or modules that align with ShadowRecon’s vision, feel free to contribute.

---

### 📜 License

MIT License

# 🛡️ ReconX — Penetration Testing & Log Analysis Dashboard

**ReconX** is a command-line security toolkit designed to automate essential penetration testing tasks and system log analysis. Inspired by the interface and workflow of Metasploit, it provides a centralized dashboard for running integrated Python and Bash scripts for local and remote vulnerability assessment.

---

## 🚀 Features

- ✅ ASCII-art interface inspired by `msfconsole`
- ✅ Interactive command-line menu for tool selection
- ✅ Python-based system log anomaly detection
- ✅ Local system vulnerability scanning (Bash)
- ✅ Remote server vulnerability assessment (Bash)
- ✅ Clean output formatting for readability
- ✅ Modular architecture for easy extension

---

## 🛠️ Tools Integrated

| Module                         | Language | Description                                      |
|-------------------------------|----------|--------------------------------------------------|
| 🔍 Log Analysis               | Python   | Scans system logs for anomalies and unusual activity |
| 🧪 Local Vulnerability Scan   | Bash     | Checks system config for common vulnerabilities |
| 🌐 Remote Vulnerability Scan  | Bash     | Scans external IPs or domains for weaknesses    |

---

## 📸 Interface Preview

> Screenshots of the dashboard interface and results are available in the documentation.

---

## 📄 Documentation

Full development process, testing, and implementation details are available in:  
📎 [`docs/ReconX Documentation.pdf`](./docs/ReconX Documentation.pdf)

---

## 🧪 Usage

### 🧰 Prerequisites

Ensure Python 3, Bash, and basic Unix utilities are installed.  
Install required Python packages:

```bash
pip install -r requirements.txt


▶️ Run ReconX
bash
Copy
Edit
chmod +x reconx.sh
./reconx.sh
Choose a module from the dashboard menu to run scans or analysis.

📁 Project Structure
graphql
Copy
Edit
ReconX/
├── reconx.sh                   # Main CLI dashboard script
├── log_analysis.py             # Python log analyzer
├── local_scan.sh               # Local vulnerability scanner
├── remote_scan.sh              # Remote vulnerability scanner
├── requirements.txt
├── README.md
├── docs/
│   └── ReconX_Documentation.pdf
└── screenshots/
    └── demo1.png




🔧 Future Enhancements
📊 Graphical report generation (HTML or charts)

🔗 Integration with threat intelligence APIs

🧩 Plugin support for custom tools

📁 Log archival and comparison over time

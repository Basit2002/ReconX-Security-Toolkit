#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"


#Create directory for scan results
mkdir -p scan_results
NMAP_OUTPUT="scan_results/nmap_result.oN"
MASSCAN_OUTPUT="scan_results/mass_result.lst"
VULN_NSE_OUTPUT="scan_results/vuln_nse_result.txt"
VULN_SEARCHSPLOIT_OUTPUT="scan_results/vuln_searchsploit_result.txt"


#Function for checking IP
validate_ip() {
    local ip="$1"
    if [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo -e "${RED}[-] Invalid IP address. Please enter a valid IPv4 address.${NOCOLOR}"
        exit 1
    fi
}



read -p "Enter the Ip address: " ip
echo ""
validate_ip "$ip"


# Function for nmap scanning
scan() {
	nmap -p- -sV -Pn "$ip" -oN "$NMAP_OUTPUT" & # TCP scan
	nmap_pid=$!
	sudo masscan -p U:1-6535 "$ip" --rate=10000 -oL "$MASSCAN_OUTPUT" & # UDP scan
	masscan_pid=$!
		
	wait "$nmap_pid" "$masscan_pid"
	echo -e "\n${GREEN}[+][+]NETWORK SCAN COMPLETE[+][+]${NOCOLOR}"
}
					


# Function for vulnerability analysis

vuln_analysis() {
	echo -e "\n${RED}[+][+]VULNERABILITY ANALYSIS WITH NSE STARTING[+][+]${NOCOLOR}"
	for i in $(grep open "$NMAP_OUTPUT" | awk -F"/" '{print $1}'); do
		nmap -p "$i" -sV -T5 "$ip" --script=vuln >> "$VULN_NSE_OUTPUT"
	done

	echo -e "\n${GREEN}[+][+]VULNERABILITY ANALYSIS WITH NSE COMPLETE[+][+]${NOCOLOR}"	
	echo -e "\n${RED}[+][+]VULNERABILITY ANALYSIS WITH SEARCHSPLOIT STARTING[+][+]${NOCOLOR}"
						
	nmap -p- -sV -Pn -T5 "$ip" -oX scan_results/nmap_result.xml
	searchsploit --nmap scan_results/nmap_result.xml > "$VULN_SEARCHSPLOIT_OUTPUT"
	echo -e "\n${GREEN}[+][+]VULNERABILITY ANALYSIS WITH SEARCHSPLOIT COMPLETE[+][+]${NOCOLOR}"		
}
# Main execution
scan "$ip"
vuln_analysis "$ip"

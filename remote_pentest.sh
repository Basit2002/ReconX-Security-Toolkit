#DECLARING KERNEL
#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

#FUNCTION FOR CHECKING EXISTENCE OF NEEDED APPLICATIONS AND INSTALLATION OF NEEDED APPLICATIONS IF NOT EXISTING
function installation()
{
	if command -v geoiplookup &> /dev/null
	then
	echo -e "\n[#] geoip-bin is already installed."

	else
	echo -e "\n[#] Installing geoip-bin."
	sudo apt-get install geoip-bin -y &> /dev/null
	echo -e "\n[#] geoip-bin done installing."
	fi

	if command -v sshpass &> /dev/null
	then
	echo -e "\n[#] sshpass is already installed."

	else
	echo -e "\n[#] Installing sshpass."
	sudo apt-get install sshpass -y &> /dev/null
	echo -e "\n[#] sshpass done installing."
	fi
	
	if command -v perl &> /dev/null
	then
	echo -e "\n[#] perl is already installed."

	else
	echo -e "\n[#] Installing perl."
	sudo apt-get install perl -y &> /dev/null
	echo -e "\n[#] perl done installing."
	fi
	
	if command -v cpanm &> /dev/null
	then
	echo -e "\n[#] cpanminus is already installed."

	else
	echo -e "\n[#] Installing cpanminus."
	sudo apt-get install cpanminus -y &> /dev/null
	echo -e "\n[#] cpanminus done installing."
	fi
	
	if [ -d "nipe" ] 
	then
	echo -e "\n[#] Nipe is already installed."
	cd $(find -type d -name 'nipe')

	else
	echo -e "\n[#] Installing Nipe."
	sudo git clone https://github.com/htrgouvea/nipe &> /dev/null && cd nipe
	cpanm --installdeps . -y &> /dev/null
	sudo cpanm --installdeps . &> /dev/null
	sudo perl nipe.pl install &> /dev/null
	echo -e "\n[#] Nipe done installing."
	fi

}

#FUNCTION FOR SPOOFING IP ADDRESS BY ENABLING NIPE APPLICATION THEN DISPLAYING DETAILS OF SPOOFED PUBLIC IP ADDRESS
function anonymous()
{
	echo
	country=$(geoiplookup $(curl -s ifconfig.me) 2>/dev/null)
	sudo perl nipe.pl restart
    if [ -z "$(sudo perl nipe.pl status | grep true -i)" ]; then
	sudo perl nipe.pl restart
	fi
	
	 if [ -z "$(geoiplookup $(sudo perl nipe.pl status | grep "Ip" -i | awk -F':' '{print $NF}') | grep "$country" )" ]; then
	echo -e "\n[*][*]YOU ARE ANONYMOUS!"
	else
	echo -e "\n[*][*]YOU ARE NOT ANONYMOUS! EXITING..."
	exit
	fi
	
	echo -e "\n[*] Your spoofed IP address is: $(sudo perl nipe.pl status | grep "Ip" -i | awk -F':' '{print $NF}'), Spoofed country: $(geoiplookup $(sudo perl nipe.pl status | grep "Ip" -i | awk -F':' '{print $NF}') | awk -F',' '{print $NF}')"
	
}


#Function for checking IP
validate_ip() {
    local ip="$1"
    if [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo -e "${RED}[-] Invalid IP address. Please enter a valid IPv4 address.${NOCOLOR}"
        exit 1
    fi
}


# Function for nmap scanning
scan() {
        nmap -p- -sV -Pn "$ip" & # TCP scan
        nmap_pid=$!
        sudo masscan -p U:1-6535 "$ip" --rate=10000 & # UDP scan
        masscan_pid=$!
                
        wait "$nmap_pid" "$masscan_pid"
        echo -e "\n${GREEN}[+][+]NETWORK SCAN COMPLETE[+][+]${NOCOLOR}"
}
# Function for vulnerability analysis

vuln_analysis() {
        echo -e "\n${RED}[+][+]VULNERABILITY ANALYSIS WITH NSE STARTING[+][+]${NOCOLOR}"
        for i in $(nmap -p- -sV -Pn "$ip" | grep open | awk -F"/" '{print $1}'); do
                nmap -p "$i" -sV -T5 "$ip" --script=vuln >> "$VULN_NSE_OUTPUT"
        done

        echo -e "\n${GREEN}[+][+]VULNERABILITY ANALYSIS WITH NSE COMPLETE[+][+]${NOCOLOR}"      
        echo -e "\n${RED}[+][+]VULNERABILITY ANALYSIS WITH SEARCHSPLOIT STARTING[+][+]${NOCOLOR}"
                                                
        nmap -p- -sV -Pn -T5 "$ip" -oX nmap_result.xml
        searchsploit --nmap scan_results/nmap_result.xml > "$VULN_SEARCHSPLOIT_OUTPUT"
        echo -e "\n${GREEN}[+][+]VULNERABILITY ANALYSIS WITH SEARCHSPLOIT COMPLETE[+][+]${NOCOLOR}"             
}



#FUNCTION FOR CALLING PREVIOSLY CREATED FUNCTIONS
function main()
{

	#Getting IP details from user
	read -p "Enter the Ip address: " ip
	echo ""
	validate_ip "$ip"

	installation
        anonymous   
	scan "$ip"
	vuln_analysis "$ip"

}

#CALLING MAIN FUNCTION
main

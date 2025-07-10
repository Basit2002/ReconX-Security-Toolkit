#!/bin/bash

# Define script paths
remote_vuln_scan="./remote_scan.sh"
vuln_scan="./local_scan.sh"
log_analysis="./log_analysis.py"

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
RESET="\e[0m"

# ASCII Banner
banner() {
    echo -e "${RED}"
    echo " ██████╗ ███████╗ ██████╗ ██████╗  ██████╗ ██╗  ██╗"
    echo " ██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔═══██╗██║ ██╔╝"
    echo " ██║  ██║█████╗  ██║   ██║██████╔╝██║   ██║█████╔╝ "
    echo " ██║  ██║██╔══╝  ██║   ██║██╔═══╝ ██║   ██║██╔═██╗ "
    echo " ██████╔╝███████╗╚██████╔╝██║     ╚██████╔╝██║  ██╗"
    echo " ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${RESET}"
}

# Menu function
show_menu() {
    clear
    banner
    echo -e "${BLUE}==========================================="
    echo -e "      ${MAGENTA}Welcome to ReconX Pentest Suite     ${BLUE}"
    echo -e "===========================================${RESET}"
    echo -e "  Host: ${YELLOW}$(hostname)${RESET}  |  Time: ${CYAN}$(date +%T)${RESET}"
    echo -e "-------------------------------------------"
    echo -e "${CYAN}1.${GREEN} Run Vulnerability Scan"
    echo -e "${CYAN}2.${GREEN} Run Remote Vulnerabilty Scan{TORR:DARK WEB}"
    echo -e "${CYAN}3.${GREEN} Run Log Analysis"
    echo -e "${CYAN}4.${RED} Exit"
    echo -e "${BLUE}-------------------------------------------${RESET}"
    echo -ne "${YELLOW}Select an option: ${RESET}"
}

# Infinite loop for menu
while true; do
    show_menu
    read -r choice

    case $choice in
        1)
            echo -e "${GREEN}Executing Vulnerability Scan Script...${RESET}"
            bash "$vuln_scan"
            ;;
        2)
            echo -e "${GREEN}Executing RemotecVulnerability Scan Script...${RESET}"
            bash "$remote_vuln_scan"
            ;;
        3)
            echo -e "${GREEN}Executing Log Analysis Script...${RESET}"
            python3 "$log_analysis"
            ;;
        4)
            echo -e "${RED}Exiting ReconX...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Try again.${RESET}"
            ;;
    esac

    echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
    read -r
done

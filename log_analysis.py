import os
import termcolor
import json
import csv
from collections import defaultdict

# Log file path
file_path = '/var/log/auth.log'

def check_log_file():
    """Checks if auth.log exists, installs rsyslog if missing."""
    if os.path.exists(file_path):
        print(termcolor.colored('LOG FILE FOUND!\nPROCEED', color='green'))
    else:
        print(termcolor.colored('LOG FILE NOT FOUND!\nINSTALLING...', color='red'))
        os.system("sudo apt-get update && sudo apt-get install rsyslog -y")
        os.system('clear')
        print(termcolor.colored('LOG FILE INSTALLED!\nPROCEED', color='green'))

def extract_command():
    """Extracts specific command usage from auth.log."""
    command = input("ENTER COMMAND TO MONITOR: ").strip()
    if not command:
        print("Invalid input.")
        return
    
    with open(file_path, 'r') as f:
        content = f.readlines()
    
    for line in content:
        if 'COMMAND' in line and command in line:
            log_list = line.split(';')
            print(termcolor.colored(f"{log_list[0]}; {log_list[-2]}; {log_list[-1]}", color='green'))



def extract_user():
    """Monitors user management and sudo authentication."""
    with open(file_path, 'r') as f:
        content = f.readlines()

    categories = {
        'NEW USERS': ['useradd'],
        'DELETED USERS': ['delete'],
        'PASSWORD CHANGES': ['password changed'],
        'SU COMMAND USAGE': ['/su'],
        'SUDO COMMAND USAGE': ['COMMAND', 'sudo']
    }

    for category, keywords in categories.items():
        print(termcolor.colored(f'\nDETAILS OF {category}', color='blue'))
        for line in content:
            if all(keyword in line for keyword in keywords):
                print(termcolor.colored(line.strip(), color='green'))





#def extract_user():
 #   """Monitors user management and sudo authentication."""
  #  with open(file_path, 'r') as f:
   #     content = f.readlines()
    
    #for category, keyword in {
     #   'NEW USERS': 'useradd',
      #  'DELETED USERS': 'delete',
       # 'PASSWORD CHANGES': 'password changed',
        #'SU COMMAND USAGE': '/su',
        #'SUDO COMMAND USAGE': '('COMMAND', 'sudo')'
    #}.items():
     #   print(termcolor.colored(f'\nDETAILS OF {category}', color='blue'))
      #  for line in content:
       #     if keyword in line:
        #        print(termcolor.colored(line.strip(), color='green'))

def detect_ssh_logins():
    """Detects successful and failed SSH login attempts."""
    failed_logins = []
    successful_logins = []
    
    with open(file_path, 'r') as f:
        for line in f:
            if 'Failed password' in line:
                failed_logins.append(line.strip())
            elif 'Accepted password' in line:
                successful_logins.append(line.strip())
    
    print(termcolor.colored("\nFAILED SSH LOGINS:", 'red'))
    for entry in failed_logins:
        print(termcolor.colored(entry, 'red'))
    
    print(termcolor.colored("\nSUCCESSFUL SSH LOGINS:", 'green'))
    for entry in successful_logins:
        print(termcolor.colored(entry, 'green'))

def detect_brute_force():
    """Detects multiple failed logins from the same IP."""
    ip_attempts = defaultdict(int)
    
    with open(file_path, 'r') as f:
        for line in f:
            if 'Failed password' in line:
                parts = line.split()
                ip = parts[-4]  # Extracts IP from failed login logs
                ip_attempts[ip] += 1
    
    print(termcolor.colored("\nPOTENTIAL BRUTE FORCE ATTACKS:", 'red'))
    for ip, count in ip_attempts.items():
        if count > 3:
            print(termcolor.colored(f"{ip} - {count} failed attempts", 'red'))

def export_logs():
    """Exports extracted log data to JSON and CSV files."""
    log_data = {
        "failed_ssh_logins": [],
        "successful_ssh_logins": [],
        "brute_force_ips": {}
    }
    
    with open(file_path, 'r') as f:
        for line in f:
            if 'Failed password' in line:
                log_data["failed_ssh_logins"].append(line.strip())
            elif 'Accepted password' in line:
                log_data["successful_ssh_logins"].append(line.strip())
            elif 'Failed password' in line:
                ip = line.split()[-4]
                log_data["brute_force_ips"][ip] = log_data["brute_force_ips"].get(ip, 0) + 1
    
    with open("log_analysis.json", "w") as json_file:
        json.dump(log_data, json_file, indent=4)
    
    with open("log_analysis.csv", "w", newline='') as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(["Category", "Log Entry"])
        for category, entries in log_data.items():
            if isinstance(entries, list):
                for entry in entries:
                    writer.writerow([category, entry])
            elif isinstance(entries, dict):
                for ip, count in entries.items():
                    writer.writerow([category, f"{ip} - {count} failed attempts"])
    
    print(termcolor.colored("Logs exported successfully to log_analysis.json and log_analysis.csv", 'green'))

def main():
    check_log_file()
    while True:
        print('\n1. Extract command usage')
        print('2. Monitor user authentication changes')
        print('3. Detect SSH logins')
        print('4. Detect brute force attacks')
        print('5. Export logs')
        choice = input('ENTER CHOICE (1-5): ')
        
        if choice == "1":
            extract_command()
        elif choice == "2":
            extract_user()
        elif choice == "3":
            detect_ssh_logins()
        elif choice == "4":
            detect_brute_force()
        elif choice == "5":
            export_logs()
        else:
            print(termcolor.colored("Invalid choice!", 'red'))
        
        if input("Continue? (y/n): ").lower() != "y":
            break
        os.system('clear')

if __name__ == "__main__":
    main()

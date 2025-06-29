#!/bin/bash  # This line tells the system to use Bash shell to run this script

# --- STEP 1: Detect the correct authentication log file ---
if [ -f /var/log/secure ]; then
  LOG_AUTH="/var/log/secure"  # This file exists on RedHat/CentOS systems
elif [ -f /var/log/auth.log ]; then
  LOG_AUTH="/var/log/auth.log"  # This file exists on Debian/Ubuntu systems
else
  echo " Error: No authentication log file found!"
  exit 1  # Exit the script if neither log file is found
fi

# --- STEP 2: Start interactive menu loop ---
while true; do
  # Display the menu
  echo "====================================="
  echo "         Linux Log Analyzer        "
  echo "====================================="
  echo "1. Check SSH login logs"
  echo "2. Check sudo command usage"
  echo "3. Check system reboot/shutdown logs"
  echo "4. Check failed login attempts"
  echo "5. Show last login history (with IPs)"
  echo "6. Show currently logged-in users"
  echo "7. Show system reboot history"
  echo "8. Check audit logs (reboot/shutdown commands)"
  echo "9. Show recent system errors (journalctl)"
  echo "10. Show all SSH logins using journalctl"
  echo "11. Exit"
  echo "====================================="
  read -p "Enter your choice [1-11]: " choice  # Prompt user to enter a number

  # --- STEP 3: Handle user's choice ---
  #note :- -Ei meaning E for Extended regular expression used to search two words at a time by using | like sudo | authentication. i=case insensitive 
  case $choice in
    1)
      echo " SSH Login Attempts:"
      grep -Ei "sshd.*(Accepted|session opened)" "$LOG_AUTH"
      ;;
    2)
      echo " Sudo Command Usage:"
      grep -Ei "sudo|authentication" "$LOG_AUTH"
      ;;
    3)
      echo " Reboot and Shutdown Logs:"
      grep -Ei "reboot|shutdown" "$LOG_AUTH"
      ;;
    4)
      echo " Failed Login Attempts:"
      grep -Ei "Failed password|authentication failure|Invalid user" "$LOG_AUTH"
      ;;
    5)
      echo " Last Login History:"
      last -ai  #a=show hostname, i=ip address 
      ;;
    6)
      echo " Currently Logged-in Users:"
      who
      ;;
    7)
      echo " System Reboot History:"
      last reboot
      ;;
    8)
      echo " Auditd Logs for Reboot/Shutdown Commands:"
      echo " Reboot Commands:"
      sudo ausearch -x reboot #ausearch is a command used to check audit information , -x for explanation
      echo " Shutdown Commands:"
      sudo ausearch -x shutdown
      ;;
    9)
      echo "Recent System Errors (journalctl):"
      journalctl -p 3 -xb | tail -n 30 #p for priority and 3 number show only error logs 
      ;;
    10)
      echo " SSH Logins from journalctl:"
      journalctl _COMM=sshd | grep "Accepted" #_COMM this parameter used in journalctl for check specific command 
      ;;
    11)
      echo " Exiting. Bye!"
      break
      ;;
    *)
      echo " Invalid choice! Please enter a number between 1 to 11."
      ;;
  esac

  echo ""
  read -p " Press Enter to return to menu..."
  clear
done

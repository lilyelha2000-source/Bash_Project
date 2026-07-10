#!/bin/bash

source functions.sh

# Root Check
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
fi

mkdir -p logs
mkdir -p reports

while true
do

clear

echo "===================================="
echo " SYSTEM RESOURCE DASHBOARD "
echo "===================================="

echo "1. Show Full Dashboard"
echo "2. Auto Refresh"
echo "3. Generate Report"
echo "4. CPU Monitor"
echo "5. RAM Monitor"
echo "6. Disk Monitor"
echo "7. Network Monitor"
echo "8. Service Checker"
echo "9. Setup Cron Job"
echo "10. View Logs"
echo "11. Exit"

read -p "Choose: " choice

case $choice in

1)
    check_cpu
    echo

    check_ram
    echo

    check_disk
    echo

    check_network
    echo

    check_service ssh
    ;;

2)
    while true
    do
        clear

        check_cpu
        echo

        check_ram
        echo

        check_disk

        sleep 5
    done
    ;;

3)
    generate_report
    ;;

4)
    check_cpu
    ;;

5)
    check_ram
    ;;

6)
    check_disk
    ;;

7)
    check_network
    ;;

8)
    read -p "Enter service name: " srv
    check_service "$srv"
    ;;

9)
    (crontab -l 2>/dev/null; echo "*/5 * * * * /bin/bash $(pwd)/dashboard.sh") | crontab -

    echo "Cron Job Added."
    ;;

10)
    cat logs/system_dashboard.log
    ;;

11)
    exit
    ;;

*)
    echo "Invalid Choice"
    ;;

esac

echo
read -p "Press Enter to continue..."

done
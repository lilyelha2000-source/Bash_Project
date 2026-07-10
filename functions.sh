#!/bin/bash

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"

LOG_FILE="./logs/system_dashboard.log"

# =========================
# Progress Bar
# =========================

progress_bar() {
    local percent=$1
    local bars=$((percent / 2))

    printf "["

    for ((i=0; i<50; i++)); do
        if [ $i -lt $bars ]; then
            printf "#"
        else
            printf "-"
        fi
    done

    printf "] %d%%\n" "$percent"
}

# =========================
# Logging
# =========================

log_event() {
    local message=$1

    echo "$(date '+%Y-%m-%d %H:%M:%S') : $message" >> "$LOG_FILE"
}

# =========================
# CPU Monitor
# =========================

check_cpu() {

    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')

    echo -e "${BLUE}CPU Usage:${RESET}"

    progress_bar "$cpu"

    if [ "$cpu" -ge 80 ]; then
        echo -e "${RED}CRITICAL CPU USAGE${RESET}"
        log_event "CRITICAL: CPU usage is $cpu%"
    elif [ "$cpu" -ge 60 ]; then
        echo -e "${YELLOW}WARNING CPU USAGE${RESET}"
        log_event "WARNING: CPU usage is $cpu%"
    else
        echo -e "${GREEN}CPU NORMAL${RESET}"
    fi
}

# =========================
# RAM Monitor
# =========================

check_ram() {

    ram=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

    echo -e "${BLUE}RAM Usage:${RESET}"

    progress_bar "$ram"

    if [ "$ram" -ge 80 ]; then
        echo -e "${RED}CRITICAL RAM USAGE${RESET}"
        log_event "CRITICAL: RAM usage is $ram%"
    elif [ "$ram" -ge 60 ]; then
        echo -e "${YELLOW}WARNING RAM USAGE${RESET}"
        log_event "WARNING: RAM usage is $ram%"
    else
        echo -e "${GREEN}RAM NORMAL${RESET}"
    fi
}

# =========================
# Disk Monitor
# =========================

check_disk() {

    disk=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

    echo -e "${BLUE}Disk Usage:${RESET}"

    progress_bar "$disk"

    if [ "$disk" -ge 80 ]; then
        echo -e "${RED}CRITICAL DISK USAGE${RESET}"
        log_event "CRITICAL: Disk usage is $disk%"
    elif [ "$disk" -ge 60 ]; then
        echo -e "${YELLOW}WARNING DISK USAGE${RESET}"
        log_event "WARNING: Disk usage is $disk%"
    else
        echo -e "${GREEN}DISK NORMAL${RESET}"
    fi
}

# =========================
# Network Monitor
# =========================

check_network() {

    echo -e "${BLUE}Network Info:${RESET}"

    ip addr show | grep "inet " | awk '{print $2}'
}

# =========================
# Service Status
# =========================

check_service() {

    service_name=$1

    systemctl is-active --quiet "$service_name"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$service_name is running${RESET}"
    else
        echo -e "${RED}$service_name is NOT running${RESET}"
        log_event "CRITICAL: $service_name stopped"
    fi
}

# =========================
# Report Generation
# =========================

generate_report() {

    report="./reports/summary_report.txt"

    echo "===== SYSTEM REPORT =====" > "$report"

    echo "Date: $(date)" >> "$report"

    echo "" >> "$report"

    echo "CPU Usage:" >> "$report"
    top -bn1 | grep "Cpu(s)" >> "$report"

    echo "" >> "$report"

    echo "RAM Usage:" >> "$report"
    free -h >> "$report"

    echo "" >> "$report"

    echo "Disk Usage:" >> "$report"
    df -h >> "$report"

    echo "" >> "$report"

    echo "System Uptime:" >> "$report"
    uptime >> "$report"

    echo "Report Generated Successfully."
}
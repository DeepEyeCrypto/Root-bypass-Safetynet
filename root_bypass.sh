#!/data/data/com.termux/files/usr/bin/bash

# Color definitions
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

# Error handling and logging
set -euo pipefail
trap "echo -e '${RED}Script interrupted! Cleaning up...${NC}'; exit 130" INT
LOG_FILE="/sdcard/root_toolkit.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Initial setup
termux-setup-storage
pkg update -y && pkg upgrade -y
pkg install -y curl wget nmap tsu adb openssh python

# Runtime checks
runtime_checks() {
    if ! ping -c 1 google.com &> /dev/null; then
        echo -e "${RED}No internet connection!${NC}"
    fi
    
    if ! su -c true; then
        echo -e "${RED}Root access missing!${NC}"
        exit 1
    fi

    if [[ -z "${RED}" || -z "${NC}" ]]; then
        echo -e "\033[1;31mFATAL: Color variables not set!\033[0m"
        exit 1
    fi
}

# Main menu
main_menu() {
    clear
    echo -e "${GREEN}Advanced Root Toolkit v3.0${NC}"
    echo -e "${YELLOW}1.  Root Access Check${NC}"
    echo -e "${YELLOW}2.  Install Essentials${NC}"
    echo -e "${YELLOW}3.  ADB Manager${NC}"
    echo -e "${YELLOW}4.  Network Tools${NC}"
    echo -e "${YELLOW}5.  System Info${NC}"
    echo -e "${YELLOW}6.  Backup/Restore${NC}"
    echo -e "${YELLOW}7.  Root Bypass Tools${NC}"
    echo -e "${YELLOW}8.  Advanced Anti-Detection${NC}"
    echo -e "${YELLOW}9.  Security Hardening${NC}"
    echo -e "${YELLOW}10. Self Maintenance${NC}"
    echo -e "${YELLOW}11. Emergency Rollback${NC}"
    echo -e "${YELLOW}12. Exit${NC}"
    read -p "Choose an option: " choice

    case $choice in
        1) check_root ;;
        2) install_packages ;;
        3) adb_menu ;;
        4) network_tools ;;
        5) system_info ;;
        6) backup_restore_menu ;;
        7) bypass_root_detection ;;
        8) advanced_anti_detection ;;
        9) security_hardening ;;
        10) self_maintenance ;;
        11) emergency_rollback ;;
        12) exit 0 ;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; main_menu ;;
    esac
}

# Core functions
check_root() {
    clear
    su -c id | grep -q "uid=0" && echo -e "${GREEN}Root OK!${NC}" || echo -e "${RED}No root!${NC}"
    read -p "Press enter to continue..."
    main_menu
}

install_packages() {
    clear
    pkg update -y && pkg upgrade -y
    pkg install -y tsu nmap adb openssh wget curl python
    echo -e "${GREEN}Packages installed!${NC}"
    sleep 1
    main_menu
}

# ADB Menu
adb_menu() {
    clear
    echo -e "${GREEN}ADB Manager${NC}"
    echo -e "${YELLOW}1. Start ADB${NC}"
    echo -e "${YELLOW}2. Stop ADB${NC}"
    echo -e "${YELLOW}3. List Devices${NC}"
    echo -e "${YELLOW}4. Return${NC}"
    read -p "Choose: " adb_choice

    case $adb_choice in
        1) adb start-server; echo -e "${GREEN}ADB Started${NC}"; sleep 1 ;;
        2) adb kill-server; echo -e "${RED}ADB Stopped${NC}"; sleep 1 ;;
        3) adb devices ;;
        4) main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    adb_menu
}

# Network Tools
network_tools() {
    clear
    echo -e "${GREEN}Network Tools${NC}"
    echo -e "${YELLOW}1. Ping Test${NC}"
    echo -e "${YELLOW}2. Network Scan${NC}"
    echo -e "${YELLOW}3. Port Scan${NC}"
    echo -e "${YELLOW}4. Return${NC}"
    read -p "Choose: " net_choice

    case $net_choice in
        1) read -p "Enter target: " t; ping -c 5 $t ;;
        2) read -p "Network (CIDR): " n; nmap -sn $n ;;
        3) read -p "Target IP: " ip; nmap -p 1-1000 $ip ;;
        4) main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    network_tools
}

# System Info
system_info() {
    clear
    echo -e "${BLUE}System Info${NC}"
    echo -e "Model: ${YELLOW}$(getprop ro.product.model)${NC}"
    echo -e "Android: ${YELLOW}$(getprop ro.build.version.release)${NC}"
    echo -e "Kernel: ${YELLOW}$(uname -r)${NC}"
    echo -e "Storage: ${YELLOW}$(df -h /data | awk 'NR==2{print $4}') Free${NC}"
    read -p "Press enter to continue..."
    main_menu
}

# Backup/Restore
backup_restore_menu() {
    clear
    echo -e "${GREEN}Backup Manager${NC}"
    echo -e "${YELLOW}1. Create Backup${NC}"
    echo -e "${YELLOW}2. Restore Backup${NC}"
    echo -e "${YELLOW}3. Return${NC}"
    read -p "Choose: " br_choice

    case $br_choice in
        1) 
            mkdir -p ~/backup
            tar -czvf ~/backup/backup_$(date +%Y%m%d).tar.gz /data /sdcard
            echo -e "${GREEN}Backup created!${NC}"
            ;;
        2)
            ls ~/backup
            read -p "Enter filename: " f
            tar -xzvf ~/backup/$f -C /
            echo -e "${GREEN}Restored!${NC}"
            ;;
        3) main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    backup_restore_menu
}

# Root Bypass Tools
bypass_root_detection() {
    clear
    echo -e "${GREEN}Root Bypass Toolkit${NC}"
    echo -e "${YELLOW}1. Magisk Modules${NC}"
    echo -e "${YELLOW}2. Configure DenyList${NC}"
    echo -e "${YELLOW}3. Clear App Data${NC}"
    echo -e "${YELLOW}4. SafetyNet Check${NC}"
    echo -e "${YELLOW}5. Hide Magisk${NC}"
    echo -e "${YELLOW}6. Disable Dev Options${NC}"
    echo -e "${YELLOW}7. Disable USB Debug${NC}"
    echo -e "${YELLOW}8. Secure Root${NC}"
    echo -e "${YELLOW}9. Return${NC}"
    read -p "Choose: " root_choice

    case $root_choice in
        1) install_magisk_modules ;;
        2) configure_denylist ;;
        3) clear_app_data ;;
        4) safetynet_check ;;
        5) hide_magisk_app ;;
        6) disable_developer_options ;;
        7) disable_usb_debugging ;;
        8) secure_root_binaries ;;
        9) main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    bypass_root_detection
}

# Advanced Anti-Detection
advanced_anti_detection() {
    clear
    echo -e "${GREEN}Advanced Protection${NC}"
    echo -e "${YELLOW}1. Bootloader Spoof${NC}"
    echo -e "${YELLOW}2. Runtime Protection${NC}"
    echo -e "${YELLOW}3. Root Scanner${NC}"
    echo -e "${YELLOW}4. Fingerprint Spoof${NC}"
    echo -e "${YELLOW}5. Return${NC}"
    read -p "Choose: " adv_choice

    case $adv_choice in
        1) bootloader_obfuscation ;;
        2) runtime_protection ;;
        3) root_artifact_scanner ;;
        4) device_fingerprint_spoofing ;;
        5) main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    advanced_anti_detection
}

# Security Hardening
security_hardening() {
    clear
    echo -e "${GREEN}Security Hardening${NC}"
    echo -e "${YELLOW}1. Kernel Lockdown${NC}"
    echo -e "${YELLOW}2. SELinux Policies${NC}"
    echo -e "${YELLOW}3. Secure Memory${NC}"
    echo -e "${YELLOW}4. Return${NC}"
    read -p "Choose: " sec_choice

    case $sec_choice in
        1) 
            sysctl -w kernel.kptr_restrict=2
            sysctl -w kernel.perf_event_paranoid=3
            echo -e "${GREEN}Kernel locked!${NC}"
            ;;
        2)
            find /data/adb -name "*.rule" -exec cat {} \; | secilc -o /sys/fs/selinux/policy
            echo -e "${GREEN}Policies updated!${NC}"
            ;;
        3)
            su -c "echo 3 > /proc/sys/vm/drop_caches"
            su -c "fstrim -v /data"
            echo -e "${GREEN}Memory wiped!${NC}"
            ;;
        4) main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    security_hardening
}

# Self Maintenance
self_maintenance() {
    clear
    echo -e "${GREEN}Self Maintenance${NC}"
    echo -e "${YELLOW}1. Update Script${NC}"
    echo -e "${YELLOW}2. Repair Permissions${NC}"
    echo -e "${YELLOW}3. Clean Cache${NC}"
    echo -e "${YELLOW}4. Return${NC}"
    read -p "Choose: " maint_choice

    case $maint_choice in
        1)
            wget -q https://example.com/toolkit.sh -O $0
            chmod +x $0
            echo -e "${GREEN}Updated! Relaunching...${NC}"
            exec $0
            ;;
        2)
            find /data/adb -type d -exec chmod 0700 {} \;
            find /data/adb -type f -exec chmod 0600 {} \;
            echo -e "${GREEN}Permissions fixed!${NC}"
            ;;
        3)
            rm -rf /data/adb/modules/*/cache
            rm -f /cache/magisk.log
            echo -e "${GREEN}Cache cleaned!${NC}"
            ;;
        4) main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    self_maintenance
}

# Emergency Rollback
emergency_rollback() {
    clear
    echo -e "${RED}EMERGENCY ROLLBACK${NC}"
    read -p "Type 'ROLLBACK' to confirm: " confirm
    if [ "$confirm" == "ROLLBACK" ]; then
        su -c "magisk --remove-modules"
        su -c "rm -rf /data/adb/modules/*"
        echo -e "${GREEN}System restored! Reboot needed${NC}"
    else
        echo -e "${YELLOW}Cancelled${NC}"
    fi
    read -p "Press enter to continue..."
    main_menu
}

# Start script
runtime_checks
main_menu

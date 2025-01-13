#!/bin/bash

# Color definitions for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Banner
clear
echo -e "${BLUE}${BOLD}"
echo "##############################################################"
echo "#                                                            #"
echo "#                Root Detection Bypass Script                #"
echo "#                                                            #"
echo "##############################################################"
echo -e "${NC}"

# Log file
LOG_FILE="/sdcard/root_bypass_log.txt"
echo "Starting Root Bypass Script" > $LOG_FILE
exec 2>>$LOG_FILE

# Ensure root permissions
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] This script must be run as root. Exiting.${NC}"
  exit 1
fi

# Function to set up Termux storage
setup_storage() {
  echo -e "${BLUE}[*] Setting up Termux storage access...${NC}"
  termux-setup-storage
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}[SUCCESS] Termux storage access granted.${NC}"
  else
    echo -e "${RED}[ERROR] Failed to set up Termux storage.${NC}"
  fi
}

# Function to update Termux and install dependencies
install_dependencies() {
  echo -e "${BLUE}[*] Updating Termux and installing dependencies...${NC}"
  pkg update && pkg upgrade -y
  pkg install git wget curl zip unzip -y
  echo -e "${GREEN}[SUCCESS] Dependencies installed.${NC}"
}

# Function to check for Magisk installation
check_magisk() {
  if ! command -v magisk &> /dev/null; then
    echo -e "${YELLOW}[*] Magisk not detected. Downloading...${NC}"
    curl -LO https://github.com/topjohnwu/Magisk/releases/download/v26.3/Magisk-v26.3.apk
    mv Magisk-v26.3.apk /sdcard/Magisk.apk
    echo -e "${YELLOW}[INFO] Please manually install Magisk from /sdcard/Magisk.apk and reboot your device.${NC}"
  else
    echo -e "${GREEN}[SUCCESS] Magisk is already installed.${NC}"
  fi
}

# Function to install Magisk modules
install_magisk_modules() {
  echo -e "${BLUE}[*] Installing Magisk modules...${NC}"

  # Universal SafetyNet Fix
  if ! magisk --list | grep -q "SafetyNetFix"; then
    echo -e "${BLUE}[*] Installing Universal SafetyNet Fix...${NC}"
    git clone https://github.com/kdrag0n/safetynet-fix.git
    zip -r SafetyNetFix.zip safetynet-fix
    magisk --install-module SafetyNetFix.zip
    rm -rf safetynet-fix SafetyNetFix.zip
  else
    echo -e "${YELLOW}[INFO] Universal SafetyNet Fix is already installed.${NC}"
  fi

  # MagiskHide Props Config
  if ! magisk --list | grep -q "MagiskHidePropsConf"; then
    echo -e "${BLUE}[*] Installing MagiskHide Props Config...${NC}"
    git clone https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf.git
    zip -r MagiskHidePropsConf.zip MagiskHidePropsConf
    magisk --install-module MagiskHidePropsConf.zip
    rm -rf MagiskHidePropsConf MagiskHidePropsConf.zip
  else
    echo -e "${YELLOW}[INFO] MagiskHide Props Config is already installed.${NC}"
  fi

  # Shamiko Module
  if ! magisk --list | grep -q "Shamiko"; then
    echo -e "${BLUE}[*] Installing Shamiko module...${NC}"
    git clone https://github.com/LSPosed/LSPosed.github.io.git
    cp LSPosed.github.io/modules/Shamiko.zip .
    magisk --install-module Shamiko.zip
    rm -rf LSPosed.github.io Shamiko.zip
  else
    echo -e "${YELLOW}[INFO] Shamiko is already installed.${NC}"
  fi

  # LSPosed Framework
  if ! magisk --list | grep -q "LSPosed"; then
    echo -e "${BLUE}[*] Installing LSPosed framework...${NC}"
    git clone https://github.com/LSPosed/LSPosed.git
    zip -r LSPosed.zip LSPosed
    magisk --install-module LSPosed.zip
    rm -rf LSPosed LSPosed.zip
  else
    echo -e "${YELLOW}[INFO] LSPosed is already installed.${NC}"
  fi

  echo -e "${GREEN}[SUCCESS] Magisk modules installed.${NC}"
}

# Function to configure MagiskHide DenyList
configure_denylist() {
  echo -e "${BLUE}[*] Configuring MagiskHide DenyList...${NC}"
  echo "Searching for banking apps..."
  detected_apps=$(pm list packages | grep -i bank)
  echo "Detected apps:"
  echo "$detected_apps"
  echo -e "${YELLOW}[INFO] Add package names manually below or from the detected list.${NC}"
  read -p "Enter package name(s) of the app(s) to hide root from (space-separated): " packages
  for package in $packages; do
    magisk --denylist add $package
    echo -e "${GREEN}[SUCCESS] Added $package to DenyList.${NC}"
  done
}

# Auto install and fix all tasks
auto_install_fix() {
  echo -e "${BLUE}[*] Running Auto Install and Fix All...${NC}"
  setup_storage
  install_dependencies
  check_magisk
  install_magisk_modules
  configure_denylist
  echo -e "${GREEN}[SUCCESS] All tasks completed successfully.${NC}"
}

# Menu system
while true; do
  echo ""
  echo "=== Root Detection Bypass Menu ==="
  echo "1. Set up Termux storage"
  echo "2. Install dependencies"
  echo "3. Check for Magisk installation"
  echo "4. Install Magisk modules"
  echo "5. Configure MagiskHide DenyList"
  echo "6. Exit"
  echo "7. Auto Install and Fix All"
  echo "=================================="
  read -p "Choose an option: " choice

  case $choice in
    1) setup_storage ;;
    2) install_dependencies ;;
    3) check_magisk ;;
    4) install_magisk_modules ;;
    5) configure_denylist ;;
    6) echo -e "${BLUE}Exiting...${NC}"; exit ;;
    7) auto_install_fix ;;
    *) echo -e "${RED}[ERROR] Invalid option. Please try again.${NC}" ;;
  esac
done

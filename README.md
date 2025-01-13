# Root Detection Bypass Script

A comprehensive Bash script designed to bypass root detection for banking and secure apps on Android devices. The script automates setting up Magisk modules, configuring root hiding, spoofing device properties, and other techniques to ensure apps function seamlessly on rooted devices.

---

## Features

- **Magisk Module Automation**:
  - Installs essential modules: 
    - [Universal SafetyNet Fix](https://github.com/kdrag0n/safetynet-fix)
    - [MagiskHide Props Config](https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf)
    - [Shamiko](https://github.com/LSPosed/LSPosed.github.io)
    - [LSPosed Framework](https://github.com/LSPosed/LSPosed)
- **DenyList Configuration**:
  - Automatically detects apps (e.g., banking apps) to add to Magisk’s DenyList.
- **Device Property Spoofing**:
  - Prepares for `props` configuration to spoof device fingerprints.
- **Root Obfuscation**:
  - Hides traces of root binaries (e.g., `/system/xbin/su`).
- **Dependency Installation**:
  - Updates Termux and installs required tools like `git`, `wget`, `curl`, `zip`, and `unzip`.
- **Interactive Menu**:
  - Allows users to selectively perform tasks with a user-friendly interface.

---

## Prerequisites

1. **Rooted Device**:
   - Ensure your device is rooted with [Magisk](https://github.com/topjohnwu/Magisk).
2. **Termux**:
   - Install Termux from [F-Droid](https://f-droid.org/).
3. **Basic Knowledge**:
   - Familiarity with running scripts on Android using Termux.

---

## Installation and Usage

### Clone the Repository

```bash
pkg update && pkg upgrade -y
pkg install wget -y
wget https://github.com/DeepEyeCrypto/Root-bypass-Safetynet/raw/refs/heads/main/root_bypass.sh
chmod +x root_bypass.sh
```

##############################################################
#                Root Detection Bypass Script                #
##############################################################

=== Root Detection Bypass Menu ===
1. Set up Termux storage
2. Install dependencies
3. Check for Magisk installation
4. Install Magisk modules
5. Configure MagiskHide DenyList
6. Exit
7. Auto Install and Fix all 
==================================
Choose an option:

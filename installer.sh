#!/bin/bash

# Check if script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root!"
  exit 1
fi

# Menu
echo "Select an installer:"
echo "1. Pterodactyl Installer"
echo "2. Pelican Installer (beta)"
echo "3. Paymenter Installer"

read -p "Enter your choice (1-3): " choice

case $choice in
  1)
    echo "Running Pterodactyl Installer..."
    bash <(curl -s https://pterodactyl-installer.se)
    ;;
  
  2)
    echo "Running Pelican Installer..."
    bash <(curl -Ss https://raw.githubusercontent.com/Zinidia/Pelinstaller/Production/install.sh || wget -O - https://raw.githubusercontent.com/Zinidia/Pelinstaller/Production/install.sh) auto
    ;;

  3)
    echo "Running Paymenter Installer..."
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      OS=$ID
    else
      echo "Unable to detect OS."
      exit 1
    fi

    if [[ "$OS" == "debian" ]]; then
      echo "Detected Debian."
      apt -y install software-properties-common curl ca-certificates gnupg2 sudo lsb-release
      echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
      curl -fsSL https://packages.sury.org/php/apt.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg
      apt install curl
      apt update -y
      curl -O https://raw.githubusercontent.com/SantiagolxxGG/paymenterinstaller/main/installer.sh
      bash installer.sh

    elif [[ "$OS" == "ubuntu" ]]; then
      echo "Detected Ubuntu."
      apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
      LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
      apt install curl
      curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
      curl -O https://raw.githubusercontent.com/SantiagolxxGG/paymenterinstaller/main/installer.sh
      bash installer.sh

    else
      echo "Unsupported OS: $OS"
      exit 1
    fi
    ;;

  *)
    echo "Invalid option selected."
    exit 1
    ;;
esac

#!/bin/bash
#set -x
#
#VARIABLES DE INFO
info="\033[0;36m[:]\033[m"
msg="\033[1;32m[+]\033[m"
err="\033[1;31m[:]\033[m"
#
#FUNCIONES
#
FuncCrowdstrike(){
#LlAMADA AL REPOSITORIO
sudo git clone https://github.com/Enhra/LinuxOnboarding.git

#INSTALACION DEL ANTIVIRUS
unzip LinuxOnboarding/'Crowdstrike for Linux.zip'
sudo dpkg -i 'Crowdstrike for Linux'/falcon-sensor_6.29.0-12606_amd64.deb
sudo rm -r LinuxOnboarding
sudo rm -r 'Crowdstrike for Linux'

#INSTALACION DE LA LICENCIA
sudo /opt/CrowdStrike/falconctl -s --cid=9AFD91A4139D4651969540068C664FBF-7C

#INSTALACION OPENSSL
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb
systemctl start falcon-sensor
systemctl enable falcon-sensor
sudo apt-get update
}

#INSTALACION LANDSCAPE
FuncLandscape(){
sudo apt update
sudo apt install ubuntu-advantage-tools
sudo ua attach C143Fk3339bBpsDTkNFgbgAPcvQjxe
sudo apt-get install landscape-client -y
sudo landscape-config --computer-title "PTT$1" --account-name 'scalefast-sl' -y
}

#INSTALACION COMPANYPORTAL
FuncCompanyPortal(){
sudo apt install curl gpg -y
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" > /etc/apt/sources.list.d/microsoft-ubuntu-jammy-prod.list'
sudo rm microsoft.gpg
sudo apt update
sudo apt install intune-portal -y
#reboot
}

#ESTRUCTURA
sudo useradd -U -d "/home/$1" -m -p $(openssl passwd -1 "Scalefast-LinuxPTT$2") -s "/bin/bash" "$1"
FuncCrowdstrike
FuncLandscape "$2"
FuncCompanyPortal

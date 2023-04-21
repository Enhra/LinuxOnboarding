#!/bin/bash
#set -x

#INFO VARIABLES
info="\033[0;36m[:]\033[m"
msg="\033[1;32m[+]\033[m"
err="\033[1;31m[:]\033[m"

#FUNCTIONS

FuncCrowdstrike(){
#CALL TO THE REPOSITORY
#
echo -e "${info} CLONNING THE REPOSITORY"
sudo git clone https://github.com/Enhra/LinuxOnboarding.git
echo -e "${msg} REPOSITORY READY"
#

#CROWDSTRIKE INSTALLATION
#
echo -e "${info} INSTALLING CROWDSTRIKE"
unzip LinuxOnboarding/'Crowdstrike for Linux.zip'
dpkg -i 'Crowdstrike for Linux'/falcon-sensor_6.29.0-12606_amd64.deb
echo -e "${msg} CROWDSTRIKE READY"
#
echo -e "${info} DELETING RESIDUAL FILES"
rm -r 'Crowdstrike for Linux'
echo -e "${msg} RESIDUAL FILES DELETED"
#

#LICENSE INSTALLATION
#
echo -e "${info} INSTALLING CROWDSTRIKE LICENSE"
sudo /opt/CrowdStrike/falconctl -s --cid=9AFD91A4139D4651969540068C664FBF-7C
echo -e "${msg} LICENSE READY"
#

#OPENSSL INSTALLATION
#
echo -e "${info} INSTALLING OPENSSL"
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb
systemctl start falcon-sensor
systemctl enable falcon-sensor
sudo apt-get update
echo -e "${msg} OPENSSL READY"
#
}

#LANDSCAPE INSTALLATION
FuncLandscape(){
#
echo -e "${info} INSTALLING UBUNTU ADVANCED TOOLS"
sudo apt-get install ubuntu-advantage-tools
echo -e "${msg} UBUNTU ADVANCED TOOLS READY"
#
echo -e "${info} INSTALLING LANDSCAPE"
sudo ua attach C143Fk3339bBpsDTkNFgbgAPcvQjxe
sudo apt-get install landscape-client -y
echo -e "${msg} LANDSCAPE READY"
#
}

# MICROSOFT INTUNE, EDGE AND TEAMS INSTALLATION
FuncMicrosoftIntune(){
#
echo -e "${info} INSTALLING PREVIOUS PACKAGES"
apt install -y wget apt-transport-https software-properties-common
echo -e "${msg} PACKAGES READY"
#
echo -e "${info} INSTALLING MICROSOFT PUBLIC KEY"
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
dpkg -i packages-microsoft-prod.deb
echo -e "${msg} MICOSOFT PUBLIC KEY READY"
sudo apt-get update
rm packages-microsoft-prod.deb
#
echo -e "${info} INSTALLING MICROSOFT INTUNE"
sudo apt-get install intune-portal -y
echo -e "${msg} MICROSOFT INTUNE READY"
#
echo -e "${info} INSTALLING MICROSOFT EDGE"
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
apt-get install -y microsoft-edge-stable
echo -e "${msg} MICROSOFT EDGE READY"
#
echo -e "${info} INSTALLING MICROSOFT TEAMS"
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main"
apt-get install -y teams
echo -e "${msg} MICROSOFT TEAMS READY"
#
}

#MICROSOFT DEFENDER INSTALLATION
FuncDefender(){
echo -e "${info} INSTALLING PREVIOUS UTILITIES"
apt-get install curl
apt-get install libplist-utils
curl -o microsoft.list https://packages.microsoft.com/config/ubuntu/22.04/prod.list
mv ./microsoft.list /etc/apt/sources.list.d/microsoft-prod.list
apt-get install gpg
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
apt-get install apt-transport-https
apt-get update
echo -e "${msg} PREVIOUS UTILITIES READY"
#
echo -e "${info} INSTALLING MICROSOFT DEFENDER"
apt install -y mdatp
echo -e "${msg} MICROSOFT DEFENDER INSTALLED"
#
echo -e "${info} CLIENT MICROSOFT DEFENDER SETUP"
unzip LinuxOnboarding/'MicrosoftDefenderATPOnboardingLinuxServer.zip'
python3 MicrosoftDefenderATPOnboardingLinuxServer.py
mdatp config real-time-protection --value enabled
echo -e "${info} CLIENT MICROSOFT DEFENDER SETUP READY"
}


#ESTRUCTURA
if [ "$EUID" -ne 0 ] then 
echo -e "{$err} PLEASE RUN THIS SCRIPT AS ROOT" 
exit 1 
fi
echo -e "${info}CREATING USER"
useradd -U -d "/home/$1" -m -p $(openssl passwd -1 "Scalefast-LinuxPTT$2") -s "/bin/bash" "$1"
usermod -aG sudo "$1"
echo -e "${info}USER READY"
#
echo -e "${info}INSTALLING GIT"
sudo apt-get install git -y
echo -e "${info}GIT READY"
#
FuncCrowdstrike
#
FuncLandscape
#
FuncMicrosoftIntune
#
FuncDefender
#
echo -e "${info} ENROLL THE MACHINE TO SCALEFAST'S LANDSCAPE BY USING THE COMMAND: 'landscape-config --computer-title=PTT### account-name=scalefast-sl --script-users=root'"
echo -e "${info} ENROLL THE MACHINE TO SCALEFAST'S LANDSCAPE BY USING THE COMMAND: 'landscape-config --computer-title=PTT### account-name=scalefast-sl --script-users=root'"
echo -e "${info} ENROLL THE MACHINE TO SCALEFAST'S LANDSCAPE BY USING THE COMMAND: 'landscape-config --computer-title=PTT### account-name=scalefast-sl --script-users=root'"
echo -e "${info} ENROLL THE MACHINE TO SCALEFAST'S LANDSCAPE BY USING THE COMMAND: 'landscape-config --computer-title=PTT### account-name=scalefast-sl --script-users=root'"
echo -e "${info} ENROLL THE MACHINE TO SCALEFAST'S LANDSCAPE BY USING THE COMMAND: 'landscape-config --computer-title=PTT### account-name=scalefast-sl --script-users=root'"
#
rm -r LinuxOnboarding


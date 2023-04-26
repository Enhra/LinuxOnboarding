#!/bin/bash
#set -x

#FUNCTIONS

FuncCrowdstrike(){
#
#CROWDSTRIKE INSTALLATION
unzip /onboarding/CrowdstrikeforLinux.zip -d /onboarding/
dpkg -i /onboarding/CrowdstrikeforLinux/falcon-sensor_6.29.0-12606_amd64.deb
#
#LICENSE INSTALLATION
sudo /opt/CrowdStrike/falconctl -s --cid=9AFD91A4139D4651969540068C664FBF-7C
#
#OPENSSL INSTALLATION
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb
systemctl start falcon-sensor
systemctl enable falcon-sensor
sudo apt-get update
#
}


#LANDSCAPE INSTALLATION
FuncLandscape(){
#
#INSTALLING UBUNTU ADVANCED TOOLS"
sudo apt-get install ubuntu-advantage-tools
#
#INSTALLING LANDSCAPE"
sudo ua attach C143Fk3339bBpsDTkNFgbgAPcvQjxe
sudo apt-get install landscape-client -y
#
}


# MICROSOFT INTUNE, EDGE AND TEAMS INSTALLATION
FuncMicrosoftIntune(){
#
#INSTALLING PREVIOUS PACKAGES
apt install -y wget apt-transport-https software-properties-common
#
#INSTALLING MICROSOFT PUBLIC KEY"
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
dpkg -i packages-microsoft-prod.deb
sudo apt-get update
rm packages-microsoft-prod.deb
#
#INSTALLING MICROSOFT INTUNE
sudo apt-get install intune-portal -y
#
#INSTALLING MICROSOFT EDGE
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
apt-get install -y microsoft-edge-stable
#
#INSTALLING MICROSOFT TEAMS
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main"
apt-get install -y teams
#
}
 

#MICROSOFT DEFENDER INSTALLATION
FuncDefender(){
#
#INSTALLING PREVIOUS UTILITIES"
apt-get install curl
apt-get install libplist-utils
curl -o microsoft.list https://packages.microsoft.com/config/ubuntu/22.04/prod.list
mv ./microsoft.list /etc/apt/sources.list.d/microsoft-prod.list
apt-get install gpg
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
apt-get install apt-transport-https
apt-get update
#
#INSTALLING MICROSOFT DEFENDER"
apt install -y mdatp
#
#CLIENT MICROSOFT DEFENDER SETUP
unzip /onboarding/WindowsDefenderATPOnboardingPackage.zip  -d /onboarding/
python3 /onboarding/MicrosoftDefenderATPOnboardingLinuxServer.py
mdatp config real-time-protection --value enabled
}


#STRUCTURE
useradd -U -d "/home/$1" -m -p $(openssl passwd -1 "Scalefast-LinuxPTT$2") -s "/bin/bash" "$1"
gpasswd -a "$1" sudo
passwd -e "$1"
#
FuncCrowdstrike
#
FuncLandscape
#
FuncMicrosoftIntune
#
FuncDefender
rm -r /onboarding

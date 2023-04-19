#!/bin/bash
#set -x

#VARIABLES DE INFO
info="\033[0;36m[:]\033[m"
msg="\033[1;32m[+]\033[m"
err="\033[1;31m[:]\033[m"

#FUNCIONES

FuncCrowdstrike(){
#LlAMADA AL REPOSITORIO
#
echo -e "${info} Clonando el repositorio"
#
sudo git clone https://github.com/Enhra/LinuxOnboarding.git
#
echo -e "${msg} Repositorio listo"
#

#INSTALACION DEL ANTIVIRUS
#
echo -e "${info} Instalando Crowdstrike"
#
unzip LinuxOnboarding/'Crowdstrike for Linux.zip'
sudo dpkg -i 'Crowdstrike for Linux'/falcon-sensor_6.29.0-12606_amd64.deb
#
echo -e "${msg} Crowdstrike instalado"
#
echo -e "${info} Eliminando repositorio residual"
#
sudo rm -r LinuxOnboarding
sudo rm -r 'Crowdstrike for Linux'
#
echo -e "${msg} Repositorio borrado"
#

#INSTALACION DE LA LICENCIA
#
echo -e "${info} Aplicando licencia de Crowdstrike"
#
sudo /opt/CrowdStrike/falconctl -s --cid=9AFD91A4139D4651969540068C664FBF-7C
#
echo -e "${msg} Licencia aplicada"
#

#INSTALACION OPENSSL
#
echo -e "${info} Instalando OpenSSL"
#
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb
systemctl start falcon-sensor
systemctl enable falcon-sensor
sudo apt-get update
#
echo -e "${msg} OpenSSL instalado"
#
}

#INSTALACION LANDSCAPE
FuncLandscape(){
#
echo -e "${info} Instalando ubuntu advanced tools"
#
sudo apt-get install ubuntu-advantage-tools
#
echo -e "${msg} Ubuntu advanced tools instalado"
#
echo -e "${info} Instalando Landscape"
#
sudo ua attach C143Fk3339bBpsDTkNFgbgAPcvQjxe
sudo apt-get install landscape-client -y
#
echo -e "${msg} Landscape instalado"
#
echo -e "${info} Uniendo el equipo al Landscape de Scalefast"
#
landscape-config --computer-title="PTT$1" --account-name="scalefast-sl" --script-users="root" --silent
#
echo -e "${msg} El equipo ha sido unido al Landscape de Scalefast"
#
}

#INSTALACION MICROSOFT INTUNE
FuncMicrosoftIntune(){
#
echo -e "${info} Instalando a clave publica de microsoft"
#
sudo apt-get install curl gpg -y
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" > /etc/apt/sources.list.d/microsoft-ubuntu-jammy-prod.list'
sudo rm microsoft.gpg
#
echo -e "${msg} Clave publica de Microsoft instalada"
#
sudo apt-get update
#
echo -e "${info} Instalando Microsoft Intune"
#
sudo apt-get install intune-portal -y
#
echo -e "${msg} Microsoft Intune instalado"
#
}

#ESTRUCTURA
echo -e "${info}Añadiendo usuario"
sudo useradd -U -d "/home/$1" -m -p $(openssl passwd -1 "Scalefast-LinuxPTT$2") -s "/bin/bash" "$1"
echo -e "${info}Usuario añadido"
echo -e "${info}Instalando Git"
sudo apt-get install git -y
echo -e "${info}Git instalado"
FuncCrowdstrike
FuncLandscape $2

#sudo rm config.txt
FuncMicrosoftIntune

for i in $(seq 10 -1 0);
do
echo -e "${info}El equipo se reiniciara en $i segundos"
sleep 1
        if [[ $i = 0 ]]
        then reboot;
        fi
done

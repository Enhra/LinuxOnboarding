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
sudo git clone https://github.com/Enhra/LinuxOnboarding.git
echo -e "${msg} Repositorio listo"
#

#INSTALACION DEL ANTIVIRUS
#
echo -e "${info} Instalando Crowdstrike"
unzip LinuxOnboarding/'Crowdstrike for Linux.zip'
dpkg -i 'Crowdstrike for Linux'/falcon-sensor_6.29.0-12606_amd64.deb
echo -e "${msg} Crowdstrike instalado"
#
echo -e "${info} Eliminando archivos residuales"
rm -r 'Crowdstrike for Linux'
echo -e "${msg} Archivos residuales borrado"
#

#INSTALACION DE LA LICENCIA
#
echo -e "${info} Aplicando licencia de Crowdstrike"
sudo /opt/CrowdStrike/falconctl -s --cid=9AFD91A4139D4651969540068C664FBF-7C
echo -e "${msg} Licencia aplicada"
#

#INSTALACION OPENSSL
#
echo -e "${info} Instalando OpenSSL"
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb
systemctl start falcon-sensor
systemctl enable falcon-sensor
sudo apt-get update
echo -e "${msg} OpenSSL instalado"
#
}

#INSTALACION LANDSCAPE
FuncLandscape(){
#
echo -e "${info} Instalando ubuntu advanced tools"
sudo apt-get install ubuntu-advantage-tools
echo -e "${msg} Ubuntu advanced tools instalado"
#
echo -e "${info} Instalando Landscape"
sudo ua attach C143Fk3339bBpsDTkNFgbgAPcvQjxe
sudo apt-get install landscape-client -y
echo -e "${msg} Landscape instalado"
#
}

#INSTALACION MICROSOFT INTUNE, EDGE Y TEAMS
FuncMicrosoftIntune(){
#
echo -e "${info} Instalando paquetes requeridos"
apt install -y wget apt-transport-https software-properties-common
echo -e "${msg} Paquetes requeridos instalados"
#
echo -e "${info} Instalando la clave publica de microsoft"
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
dpkg -i packages-microsoft-prod.deb
echo -e "${msg} Clave publica de Microsoft instalada"
sudo apt-get update
rm packages-microsoft-prod.deb
#
echo -e "${info} Instalando Microsoft Intune"
sudo apt-get install intune-portal -y
echo -e "${msg} Microsoft Intune instalado"
#
echo -e "${info} Instalando Microsoft Edge"
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
apt-get install -y microsoft-edge-stable
echo -e "${msg} Microsoft Edge instalado"
#
echo -e "${info} Instalando Microsoft teams"
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main"
apt-get install -y teams
echo -e "${msg} Microsoft teams instalado"
#
}

#INSTALACION DE MICROSOFT DEFENDER
FuncDefender(){
echo -e "${info} Instalando utilidades necesarias"
apt-get install curl
apt-get install libplist-utils
curl -o microsoft.list https://packages.microsoft.com/config/ubuntu/22.04/prod.list
mv ./microsoft.list /etc/apt/sources.list.d/microsoft-prod.list
apt-get install gpg
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
apt-get install apt-transport-https
sudo apt-get update
#
echo -e "${info} Instalando Microsoft Defender"
apt install -y mdatp
echo -e "${msg} Microsoft Defender instalado"
#
echo -e "${info} Estableciendo la configuracion de cliente de Defender"
unzip LinuxOnboarding/'MicrosoftDefenderATPOnboardingLinuxServer.zip'
python3 MicrosoftDefenderATPOnboardingLinuxServer.py
mdatp config real-time-protection --value enabled
echo -e "${info} Configuracion de cliente de Defender establecida"
}


#ESTRUCTURA
echo -e "${info}Añadiendo usuario"
sudo useradd -U -d "/home/$1" -m -p $(openssl passwd -1 "Scalefast-LinuxPTT$2") -s "/bin/bash" "$1"
echo -e "${info}Usuario añadido"
#
echo -e "${info}Instalando Git"
sudo apt-get install git -y
echo -e "${info}Git instalado"
#
FuncCrowdstrike
#
FuncLandscape
#
#echo -e "${info} Uniendo el equipo al Landscape de Scalefast"
#landscape-config --computer-title="PTT$2" --account-name="scalefast-sl" --script-users="root" --silent
#echo -e "${msg} El equipo ha sido unido al Landscape de Scalefast"
#
FuncMicrosoftIntune
rm -r LinuxOnboarding

for i in $(seq 10 -1 0);
do
echo -e "${info}El equipo se reiniciara en $i segundos"
sleep 1
        if [[ $i = 0 ]]
        then reboot;
        fi
done

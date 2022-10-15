#!/bin/bash

rm -rf $0

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

create_a_group() {
    read -p "(Please input a group name:):" namegroup
    [ -z "$namegroup" ] && namegroup="AikoCute"
    az group create --name $namegroup --location southcentralus
    echo -e "Create group $namegroup successfully!"
    show_menu
}

create_vps(){
    read -p "(Please input a VPS name:):" vpsname
    [ -z "$vpsname" ] && vpsname="aiko"
    echo -e "${green}You have inputed VPS name:${plain} $vpsname"

    read -p "(Please enter the previously created Group name):" namegroup
    [ -z "$namegroup" ] && namegroup="AikoCute"
    echo -e "${green}You have inputed Group name:${plain} $namegroup"

    echo -e "[1] HongKong ( East Asia )"
    echo -e "[2] Japan ( Japan East )"
    echo -e "[3] Korea ( Korea South )"
    echo -e "[4] Singapore (Southeast Asia)"
    read -p "(please select the area you want to create): " set_area
    if [[ "$set_area" == "1" ]]; then
        area="eastasia"
    elif [[ "$set_area" == "2" ]]; then
        area="japaneast"
    elif [[ "$set_area" == "3" ]]; then
        area="koreacentral"
    elif [[ "$set_area" == "4" ]]; then
        area="southeastasia"
    else
        echo -e "${red}Error:${plain} Please input a number [1-4]"
        exit 1
    fi
    echo -e "${green}You have selected the area:${plain} $area"


    echo -e "[1] Ubuntu 20.04 LTS ( Gen 2 )"
    echo -e "[2] CentOS 7.9 ( Gen 2 )"
    read -p "(Please select a image you want Create  :):" set_image
    if [[ "$set_image" == "1" ]]; then
        image="microsoft-dsvm:ubuntu-hpc:2004:20.04.2021051401"
    elif [[ "$set_image" == "2" ]]; then
        image="OpenLogic:CentOS-HPC:7_9-gen2:7.9.2021052401"
    else
        echo -e "${red}Error:${plain} Please input a number [1-2]"
        exit 1
    fi
    echo -e "${green}You have selected the image:${plain} $image"

    echo -e "[1] Standard_B1s ( 1 vCPU, 1GB memory )"
    echo -e "[2] Standard_B2s ( 2 vCPU, 4GB memory )"
    echo -e "[3] Standard_B4ms (4 vCPU, 16GB memory )"
    echo -e "[4] Standard_D2s_v3 ( 2 vCPU, 8GB memory )"
    echo -e "[5] Standard_B1ls ( 1 vCPU, 0,5GB memory )"
    read -p " Choose the VPS Size to create :" set_size
    if [[ "$set_size" == "1" ]]; then
        size="Standard_B1s"
    elif [[ "$set_size" == "2" ]]; then
        size="Standard_B2s"
    elif [[ "$set_size" == "3" ]]; then
        size="Standard_B4ms"
    elif [[ "$set_size" == "4" ]]; then
        size="Standard_D2s_v3"
    elif [[ "$set_size" == "5" ]]; then
        size="Standard_B1ls"
    else
        echo -e "${red}Error:${plain} Please input a number [1-5]"
        exit 1
    fi
    echo -e "${green}You have selected the size:${plain} $size"

    read -p "Please enter VPS username :" username
    [ -z "$username" ] && username="aiko"
    echo -e "${green}You have inputed VPS username:${plain} $username"

    read -p "Please enter VPS password :" password
    [ -z "$password" ] && password="Aikocute2001"
    echo -e "${green}You have inputed VPS password:${plain} $password"

    az vm create -n $vpsname -l $area -g $namegroup --image $image --size $size --admin-password $password --admin-username $username --public-ip-sku Standard
    echo -e "Create VPS $vpsname successfully!"

    echo -e "Do you Want Unlock port VPS? (80,443) [y/n]"
    read -p "(Default: y):" unlock_port
    if [ -z "$unlock_port" ]; then
        unlock_port="y"
    fi
    if [[ "$unlock_port" == "y" ]]; then
        az vm open-port --port 80 --resource-group $namegroup --name $vpsname --priority 123
        az vm open-port --port 443 --resource-group $namegroup --name $vpsname --priority 124
        echo -e "Unlock port successfully!"
    fi
    show_menu
}

create_vps_windows(){
#Win2016Datacenter, Win2012R2Datacenter, Win2012Datacenter, Win2016Datacenter, Win2019Datacenter
    read -p "(Please input a VPS name:):" vpsname_1
    [ -z "$vpsname_1" ] && vpsname_1="aiko"
    echo -e "${green}You have inputed VPS name:${plain} $vpsname_1"

    read -p "(Please enter the previously created Group name):" namegroup_1
    [ -z "$namegroup_1" ] && namegroup_1="AikoCute"
    echo -e "${green}You have inputed Group name:${plain} $namegroup_1"

    echo -e "[1] HongKong ( East Asia )"
    echo -e "[2] Japan ( Japan East )"
    echo -e "[3] Korea ( Korea South )"
    echo -e "[4] Singapore (Southeast Asia)"
    read -p "(please select the area you want to create): " set_area_1
    if [[ "$set_area_1" == "1" ]]; then
        area="eastasia"
    elif [[ "$set_area_1" == "2" ]]; then
        area="japaneast"
    elif [[ "$set_area_1" == "3" ]]; then
        area="koreacentral"
    elif [[ "$set_area_1" == "4" ]]; then
        area="southeastasia"
    else
        echo -e "${red}Error:${plain} Please input a number [1-4]"
        exit 1
    fi
    echo -e "${green}You have selected the area:${plain} $area"

    echo -e "[1] Windows Server 2016 Datacenter"
    echo -e "[2] Windows Server 2012 R2 Datacenter"
    echo -e "[3] Windows Server 2012 Datacenter"
    echo -e "[4] Windows Server 2016 Datacenter"
    echo -e "[5] Windows Server 2019 Datacenter"
    read -p "(Please select a image you want Create  :):" set_image_1
    if [[ "$set_image_1" == "1" ]]; then
        image="win2016datacenter"
    elif [[ "$set_image_1" == "2" ]]; then
        image="win2012r2datacenter"
    elif [[ "$set_image_1" == "3" ]]; then
        image="win2012datacenter"
    elif [[ "$set_image_1" == "4" ]]; then
        image="win2016datacenter"
    elif [[ "$set_image_1" == "5" ]]; then
        image="win2019datacenter"
    else
        echo -e "${red}Error:${plain} Please input a number [1-4]"
        exit 1
    fi
    echo -e "${green}You have selected the image:${plain} $image"

    echo -e "[1] Standard_B1s ( 1 vCPU, 1GB memory )"
    echo -e "[2] Standard_B2s ( 2 vCPU, 4GB memory )"
    echo -e "[3] Standard_B4ms (4 vCPU, 16GB memory )"
    echo -e "[4] Standard_D2s_v3 ( 2 vCPU, 8GB memory )"
    echo -e "[5] Standard_B1ls ( 1 vCPU, 0,5GB memory )"
    read -p " Choose the VPS Size to create :" set_size_1
    if [[ "$set_size_1" == "1" ]]; then
        size="Standard_B1s"
    elif [[ "$set_size_1" == "2" ]]; then
        size="Standard_B2s"
    elif [[ "$set_size_1" == "3" ]]; then
        size="Standard_B4ms"
    elif [[ "$set_size_1" == "4" ]]; then
        size="Standard_D2s_v3"
    elif [[ "$set_size_1" == "5" ]]; then
        size="Standard_B1ls"
    else
        echo -e "${red}Error:${plain} Please input a number [1-5]"
        exit 1
    fi
    echo -e "${green}You have selected the size:${plain} $size"

    read -p "Please enter VPS username :" username_1
    [ -z "$username_1" ] && username_1="aiko"
    echo -e "${green}You have inputed VPS username:${plain} $username_1"

    read -p "Please enter VPS password :" password_1
    [ -z "$password_1" ] && password_1="Aikocute2001"
    echo -e "${green}You have inputed VPS password:${plain} $password_1"

az vm create -n $vpsname_1 -l $area -g $namegroup_1 --image $image --size $size --generate-ssh-keys --assign-identity --admin-username $username_1 --admin-password $password_1 --public-ip-sku Standard
}

openport(){
    read -p "Pls input the Name you want to open port :" name_3
    [ -z "$name_3" ] && name_3="aiko"

    read -p "Pls input the Group name you want to open port :" namegroup_2
    [ -z "$namegroup_2" ] && namegroup_2="AikoCute"

    read -p "Pls input the port you want to open :" port_4
    [ -z "$port_4" ] && port_4="22"

    #create random number for priority
    priority=$(shuf -i 100-999 -n 1)
    az vm open-port --resource-group $namegroup_2 --name $name_3 --port $port_4 --priority $priority

}

show_menu() {
    echo -e "
  ${green} Tool to create VPS on Azure via Bash，${plain}${red}No need to use Root privileges${plain}
--- https://github.com/AikoCute-Offical/Az-Trial ---
  ${green}0.${plain} Exit script
————————————————
  ${green}1.${plain} Create a group
  ${green}2.${plain} Create VPS on an existing Group
  ${green}3.${plain} Create VPS Windows
  ${green}4.${plain} Quick OpenPort VPS
————————————————
 "
    echo && read -p "Please enter an option [0-4]: " num

    case "${num}" in
        0) exit 0
        ;;
        1) create_a_group
        ;;
        2) create_vps
        ;;
        3) create_vps_windows
        ;;
        4) openport
        ;;
        *) echo -e "${red}Please enter the correct number [0-4]${plain}"
        ;;
    esac
}

show_menu
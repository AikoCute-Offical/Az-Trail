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
    show_menu
}

create_vps(){
    read -p "(Please input a VPS name:):" vpsname
    [ -z "$vpsname" ] && vpsname="aiko"

    read -p "(Please enter the previously created Group name):" namegroup
    [ -z "$namegroup" ] && namegroup="AikoCute"

    echo -e "[1] HongKong ( East Asia )"
    echo -e "[2] Japan ( Japan East )"
    echo -e "[3] Korea ( Korea South )"
    read -p "(please select the area you want to create)" area
    if [[ area == "1" ]]; then
        area = "eastasia"
    elif [[ area == "2" ]]; then
        area = "japaneast"
    elif [[ area == "3" ]]; then
        area = "koreacentral"
    else
        echo -e "${red}Error:${plain} Please input a number [1-3]"
        exit 1
    fi


    echo -e "[1] Ubuntu 20.04 LTS ( Gen 2 )"
    echo -e "[2] CentOS 7.9 ( Gen 2 )"
    read -p "(Please select a image you want Create  :):" image
    if [[ image == "1" ]]; then
        image = "ubuntu-hpc:ubuntu-20.04:2004:20.04.2021051401"
    elif [[ image == "2" ]]; then
        image = "OpenLogic:CentOS-HPC:7_9-gen2:7.9.2021052401"
    else
        echo -e "${red}Error:${plain} Please input a number [1-2]"
        exit 1
    fi


    echo -e "[1] Standard_B1s ( 1 vCPU, 1GB memory )"
    echo -e "[2] Standard_B2s ( 2 vCPU, 4GB memory )"
    echo -e "[3] Standard_B4ms (4 vCPU, 16GB memory )"
    echo -e "[4] Standard_D2s_v3 ( 2 vCPU, 8GB memory )"
    echo -e "[5] Standard_B1ls ( 1 vCPU, 0,5GB memory )"
    read -p " Choose the VPS Size to create :" size
    if [[ size == "1" ]]; then
        size = "Standard_B1s"
    elif [[ size == "2" ]]; then
        size = "Standard_B2s"
    elif [[ size == "3" ]]; then
        size = "Standard_B4ms"
    elif [[ size == "4" ]]; then
        size = "Standard_D2s_v3"
    elif [[ size == "5" ]]; then
        size = "Standard_B1ls"
    else
        echo -e "${red}Error:${plain} Please input a number [1-5]"
        exit 1
    fi

    read -p "Please enter VPS username :" username
    [ -z "$username" ] && username="aiko"

    read -p "Please enter VPS password :" password
    [ -z "$password" ] && password="Aikocute2001"

    az vm create -n $vpsname -l $area -g $namegroup --image $image --size $size --admin-password $password --admin-username $username --public-ip-sku Standard
}

show_menu() {
    echo -e "
  ${green} Tool to create VPS on Azure via Bash，${plain}${red}No need to use Root privileges${plain}
--- https://github.com/AikoCute-Offical/Az-Trial ---
  ${green}0.${plain} Exit script
————————————————
  ${green}1.${plain} Create a group
  ${green}2.${plain} Create VPS on an existing Group
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
        *) echo -e "${red}Please enter the correct number [0-2]${plain}"
        ;;
    esac
}

show_menu
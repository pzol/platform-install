#!/bin/bash
# 
# 
#
# Below is whitelist configuration
ipwlarr=(194.213.22.* 192.168.194.* 10.117.104.*)
#
#

while [ 1 ] 
do
clear
echo "Script for managing IP restrictions"
echo "Menu:"
echo "1) - add IP address to blacklist"
echo "2) - remove IP from blacklist"
echo "3) - list blacklist"
echo "4) - exit"
echo "please select your weapon:"
read choice
case "$choice" in
"1")
#IP add
echo -n "Enter IP address to add to blacklist [ENTER]: "
read var_name

for i in "${ipwlarr[@]}"
do
if [[ $var_name == $i ]]; then
var_name=""
break
fi
done


if [[ $var_name == "" ]]; then
 echo "IP CANNOT be NULL, or you entered whitelist IP"
 read -p "Press any key..." -n1 -s
else
 echo "IP address you eneterd is: $var_name"
 sudo iptables -I INPUT -s $var_name -j DROP
 sudo iptables-save > /etc/iptables.rules
 echo ""
 echo ""
 echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
 echo ""
 echo -e "Done. You have just added IP address \E[0;31m$var_name\E[m to blacklist"
 echo ""
 echo ""
 read -p "Press any key..." -n1 -s
fi
;;
"2")
#IP delete
echo "You are about to remove IP address from blacklist."
echo "Enter IP address you want to remove and press [ENTER]: "
read var_name
echo "IP address to remove is: $var_name"
if sudo iptables -n -L INPUT|grep $var_name; then
    echo -e "Are you sure you want to delete  \E[0;31m$var_name\E[m [yes/no]?"
    read confirm
    if [ $confirm = yes ]; then
     sudo iptables -D INPUT -s $var_name -j DROP
     echo "You have sucesfully deleted IP $var_name "
     sudo iptables-save > /etc/iptables.rules
    else
     echo "Please give my script a try...!"
    fi
    sudo iptables -D INPUT -s $var_name -j DROP
    echo "You have sucesfully deleted IP $var_name "
else
 echo "There is no such IP address in blacklist!"
 read -p "Press any key..." -n1 -s
fi
;;
"3")
sudo iptables -n -L INPUT
echo ""
read -p "Press any key..." -n1 -s
;;
"4")
break
;;
*)
echo "Make your choise once more"
echo ""
read -p "Press any key..." -n1 -s
esac
done

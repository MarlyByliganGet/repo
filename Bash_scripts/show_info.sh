#!/bin/bash
#initialization variables
show_IP=$(/usr/sbin/ip a | grep inet | grep 10. | cut -d " " -f 6 | cut -b 1-11)
show_HOSTNAME=$(echo $HOSTNAME)
show_OS_release=$(cat /etc/redhat-release)
#RAM and SWAP variable
show_RAM=$(free -h | grep -B 1 Mem)
show_total_SWAP=$(free -h | grep  "Swap\| total")
#CPU variable
show_info_CPU=$(lscpu | grep "CPU(s)\|Model name"| sort -b | grep -m2 "CPU(s)\|Model name")
show_load_CPU=$(cat /proc/loadavg | awk '{print "load CPU for period - 1 minute: "$1; print "load CPU for period - 5 minute: " $2 ; print "load CPU for period - 15 minute: " $3 }')
#Service variable
show_Service_systemd_with_app=$( ls -la /etc/systemd/system | grep app- |awk '{print $9 }')
show_java_app_is_running=$(ps -aux | grep java | awk -F":" '{print $1$2 }')
#Count load memory for systemd unit apps variable
count_memory_Service_systemd_with_app=$(systemctl status app-* | grep " - \|Active:\|Memory:" | grep Memory: | grep G |  awk '{s += $2} END {print "GB: "s}' && systemctl status app-* | grep " - \|Active:\|Memory:" | grep Memory: | grep M| awk '{M += $2} END {print "MB: "M}' )
#Wich size dirrectories on /store/app/*
show_size_dirs_on_app=$(du --max-depth=2 -h /store/app)
show_size_dirs_on_store=$(du --max-depth=2 -h /store)
show_size_space_from_root_dirs=$(df -h)
        echo ""
            echo "-------------------------------------REPORT FROM-------------------------------------------"
        echo -e "Host IP is:  \n ${show_IP}"
        echo -e "HostName is:  \n $show_HOSTNAME"
        echo -e "Wich type OS is:  \n $show_OS_release"
        echo ""
            echo "-----------------------------------Раздел по HDD-----------------------------------------"
        echo ""
        echo -e "Занимаемый размер в /store/app :" "\n $show_size_dirs_on_app"
        echo ""
        echo -e "Занимаемый размер /:" "\n $show_size_space_from_root_dirs"
        echo ""
        echo -e "Занимаемый размер в /store:" "\n $show_size_dirs_on_store"
            echo "-----------------------------------Раздел по RAM-----------------------------------------"
        echo ""
        echo -e "Сколько ресурса Ram на сервере -$show_IP  : \n $show_RAM"
        echo ""
        echo -e "Сколько ресурса SWAP на сервере -  $show_IP  : \n  $show_total_SWAP"
        echo ""
            echo "-----------------------------------Раздел по CPU-----------------------------------------"
        echo ""
        echo -e "Информация CPU на сервере $show_IP: \n $show_info_CPU"
        echo ""
        echo -e "Нагрузка CPU на сервере $show_IP: \n $show_load_CPU"
        echo ""
            echo "-----------------------------------Раздел по APPs-----------------------------------------"
        echo ""
        echo -e "Все Systemd units на сервере - $show_IP: \n \n $show_Service_systemd_with_app"
        echo ""
        echo -e "Сколько потребляют RAM Systemd units на сервере -  $show_IP: \n $count_memory_Service_systemd_with_app"
        echo ""
        echo -e "Запущенные java приложения на сервере -  $show_IP: \n $show_java_app_is_running"

#chmod +x show_info.sh && ./show_info.sh | mail -s "Report form " my@email.com
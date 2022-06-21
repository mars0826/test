#!/bin/bash
##此腳本用來搭建新架構環境與測試環境，在opt目錄新建deploy目錄，然後將
##指令碼目錄的所有檔案上傳到deploy目錄，執行install.sh執行。
##author:allen 
##edit by RayLin

##########################################函式#################################
. ./setuplib.sh
#. ./setuplib_docker.sh


##########################################指令碼正文#################################
while true; do
    echo -e "\033[36m \t\t\t+---------------------------------------+\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t|      請選擇要部屬的服務器類型         |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t+---------------------------------------+\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (1) Ubuntu20.04初始化                 |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (2) 部署emqx                          |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (3) 部署mqtt                          |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (4) 部署Docker+Rabbitmq               |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (5) 部署nginx                         |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (6) 待定                              |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (7) 待定                              |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (8) 待定                              |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (9) 待定                              |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| (0) 退出                              |\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t+---------------------------------------+\t\t\t \033[0m"
    echo -e "\033[36m \t\t\t| \033[5m\c"
    echo -e "\033[31m部屬完畢後，請刪除腳本!               \033[0m\c"
    echo -e "\033[36m|\t\t\t \033[0m" 
    echo -e "\033[36m \t\t\t+---------------------------------------+\t\t\t \033[0m"
    read -p "請選擇要部屬的機器類型:" choice

    case $choice in  
        0)
             exit
        ;;  
        1) #系統初始化+新增ubuntu user+安裝node_export監控
	   echo "系統初始化"
	   System_INI
	   echo "新增ubuntu user"
	   Add_Ubuntu_User
	   echo "安裝 zsh環境"
	   Install_Zsh_Offline
	   echo "裝node_export for prometheus"
	   Install_Exporter_Offline
	   echo "reboot os 讓設定生效"
	   reboot
	   exit
        ;;
        2)  #部署emqx
	    Install_Emqx	    
	    Install_Pushgateway
	    exit

        ;;
        3) #部署mqtt
	   Install_Python3_6
           Install_Supervisor 
	   exit

        ;;
        4) #部署Rabbitmq
            Install_Docker
            Install_Rabbitmq
	    exit
        ;;
        5) #部署nginx
           Install_Nginx
	   exit

        ;;
        6) #部署
	   exit
        ;;
        7)##
        
        ;;
        8)##
        
        ;;
        9)
        
        ;;
    esac
done

# MQTT-IM 部署腳本

透過shell script自動化部署 mqtt-im相關環境  
1.emqx  
2.mqtt  
3.rabbitmq+docker  
4.nginx  


##目錄結構說明

├── conf <--配置檔案  
│   ├── emqx  
│   │   ├── emqx_auth_mysql.conf  
│   │   ├── emqx.conf  
│   │   └── emqx_exhook.conf  
│   ├── ssh <-- 系統登入帳號:ubunut ssh免登key  
│   │   └── authorized_keys   
│   └── supervisor  
│       ├── beta_exhook.conf  
│       ├── beta_mqtt-client.conf  
│       ├── beta_mqtt-im.conf  
│       ├── prod_mqtt-im-mqtt1.conf  
│       └── prod_mqtt-im-mqtt2.conf  
├── src <--離線安裝包  
│   ├── code <--mqtt代碼  
│   │   ├── beta.py  
│   │   ├── celery_beta.py  
│   │   └── mqtt-im.zip  
│   ├── emqx  
│   │   └── emqx-ubuntu20.04-4.3.15-amd64.deb  
│   ├── prometheus  
│   │   ├── node_exporter-1.0.1.linux-amd64.tar.gz    
│   │   └── pushgateway-0.4.0.linux-amd64.tar.gz  
│   └── zsh  
│       ├── ohmyzsh_install.sh  
│       ├── oh-my-zsh.tgz  
│       ├── ohmyzsh.zip  
│       └── zsh-autosuggestions.zip  
├── install.sh  <--安裝選單腳本  
├── setuplib.sh <--函式腳本  
└── virtualenv_mqtt-im.sh <--提供給setuplib.sh調用  

## 使用方法
運行環境:ubuntu 20.04 TLS  
運行身分:root  
         root需有sudo權限若沒請參考下面指令添加  
         echo "root   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers  
運行方式:sh /opt/setp/install.sh  
選擇要運行的項目  

注意:  
1.authorized_keys 請記得要替換!  
2.部署任一服務前,都必須先運行 " (1) Ubuntu20.04初始化 "  
3.src/code/mqtt-im.zip 代碼庫: git@git.apple.net:apple/server/mqtt-im.git  






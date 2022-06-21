# MQTT-IM 部署腳本

透過shell script自動化部署 mqtt-im相關環境
1.emqx
2.mqtt
3.rabbitmq+docker
4.nginx



用一两段话介绍这个项目以及它能做些什么。

![](https://github.com/mars0826/test/blob/master/mqtt-im-setup/mqtt-setup.png)

## Getting Started 使用指南
![](https://github.com/mars0826/test/blob/master/mqtt-im-setup/mqtt-setup.png)
setup 目錄結構說明
.
├── conf <--放配置相關設定檔案
│   ├── emqx
│   │   ├── emqx_auth_mysql.conf
│   │   ├── emqx.conf
│   │   └── emqx_exhook.conf
│   ├── ssh
│   │   └── authorized_keys <-- for ubunut ssh 免登 key 
│   └── supervisor
│       ├── beta_exhook.conf
│       ├── beta_mqtt-client.conf
│       ├── beta_mqtt-im.conf
│       ├── prod_mqtt-im-mqtt1.conf
│       └── prod_mqtt-im-mqtt2.conf
├── src <--離線安裝包
│   ├── code
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
├── README
├── setuplib.sh <--函式腳本
└── virtualenv_mqtt-im.sh

 注意:authorized_keys 請記得要替換!!!

项目使用条件、如何安装部署、怎样运行使用以及使用演示

### Prerequisites 项目使用条件
作業系統:Ubuntu 20.04 TLS
運行身分:root
腳本部署路徑:/opt/ 

部署任一服務請先執行系統初始化部署

### Installation 安装

examples:部署emqx



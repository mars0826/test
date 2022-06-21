# MQTT-IM 部署腳本

透過shell script自動化部署 mqtt-im相關環境  
1.emqx  
2.mqtt  
3.rabbitmq+docker  
4.nginx  


##目錄結構說明

![](https://github.com/mars0826/test/blob/master/mqtt-im-setup/mqtt-setup.png)

### 使用方法
運行環境:ubuntu 20.04 TLS  
運行身分:root  
         root需有sudo權限若沒請參考下面指令添加  
         echo "root   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers  
運行方式:sh /opt/setp/install.sh  
選擇要運行的項目  

注意:1.authorized_keys 請記得要替換!!!  
     2.部署任一服務都必須先運行系統初始化+重開機後在進行部署服務  


#### Installation 安装範例  

examples:部署rabbitmq+docker  



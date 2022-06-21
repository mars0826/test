#!/bin/bash

conf_path="/opt/setup/conf"
src_path="/opt/setup/src"

System_INI(){
        echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
	read -p "請輸入hostsname: " hname
	#echo "$hname"
	sudo hostnamectl set-hostname $hname
	#修正系統時區
	sudo timedatectl set-timezone Asia/Shanghai
        echo "\n確認時區及時間是否正確"
	timedatectl|grep "Time zone"
	date
	echo "\n"
	sudo apt-get update -y
	echo "安裝常用套件"
	sudo apt-get install lrzsz unzip vim net-tools wget curl -y
	echo "更新套件到最新"
	sudo apt-get upgrade -y
        #禁止ssh密碼登入只允許key
        sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
        sudo echo "UseDNS no"  >> /etc/ssh/sshd_config
	#加大連線數
	echo "root soft nofile 1048576" >> /etc/security/limits.conf
	echo "root hard nofile 1048576" >> /etc/security/limits.conf
	echo "* soft nofile 1048576"  >> /etc/security/limits.conf
	echo "* hard nofile 1048576"  >> /etc/security/limits.conf
	ulimit -HSn 1048576
	#修改内核
	echo "vm.swappiness=0" >> /etc/sysctl.conf
	echo "net.core.somaxconn=1024" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_max_tw_buckets=5000" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_max_syn_backlog=1024" >> /etc/sysctl.conf
	echo "net.nf_conntrack_max=1000000" >> /etc/sysctl.conf
	echo "net.netfilter.nf_conntrack_max=1000000" >> /etc/sysctl.conf
	echo "fs.file-max = 6553560" >>  /etc/sysctl.conf
	sysctl -p
	sudo systemctl disable ufw
	sudo ufw disable
}


Add_Ubuntu_User(){
	sudo useradd --create-home ubuntu -s /bin/bash
	adduser ubuntu sudo
	echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
	su ubuntu -c 'mkdir -p /home/ubuntu/.ssh/'
	cp ${conf_path}/ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
        chmod 700 /home/ubuntu/.ssh
        chmod 600 /home/ubuntu/.ssh/authorized_keys
        su ubuntu -c 'touch /home/ubuntu/.sudo_as_admin_successful'
}


Install_Zsh_Offline(){
	sudo apt-get install git-core zsh -y
	# 离线安装
	tar xvf ${src_path}/zsh/oh-my-zsh.tgz -C /home/ubuntu/
        chown ubuntu:ubuntu -R /home/ubuntu/.oh-my-zsh
	su  ubuntu -c '/home/ubuntu/.oh-my-zsh/tools/install.sh'
	sed -i "s#plugins=(git)#plugins=(git zsh-autosuggestions)#g" /home/ubuntu/.zshrc
	sed -i '$aPROMPT="$fg[cyan]%}$USER@%{$fg[blue]%}%m ${PROMPT}"' /home/ubuntu/.zshrc
}


Install_Docker(){
sudo systemctl disable ufw
sudo ufw disable
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt update -y
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo systemctl enable docker
}


Install_Rabbitmq(){

docker pull rabbitmq:3.9
docker run --name rabbitmq-3.9 -d -p 5672:5672 -p 15672:15672 -v /root/data/rabbitmq:/var/lib/rabbitmq rabbitmq:3.9

echo "进入容器："
echo "docker exec -it rabbitmq-3.9 /bin/bash"
echo "添加虚拟主机"
echo "rabbitmqctl add_vhost /apple"
echo "创建账号密码："
echo "rabbitmqctl add_user deploy deploy1234"
echo "设置用户角色"
echo "rabbitmqctl set_user_tags deploy administrator"
echo "配置權限"
echo "rabbitmqctl set_permissions -p /apple deploy '.*' '.*' '.*'"

}



Install_Python3_6() {
	sudo apt-get install software-properties-common -y
	sudo add-apt-repository ppa:deadsnakes/ppa -y
	sudo apt-get install python3.6-dev libmysqlclient-dev -y
	sudo apt-get install python3.6  python3.6-distutils -y
	sudo apt install python3-pip -y
	sudo pip3 install virtualenvwrapper 
	sudo apt-get install mysql-client -y
	#創立virtualenv_mqtt-im	
        su ubuntu -c "zsh /opt/setup/virtualenv_mqtt-im.sh"
}

Install_Supervisor(){
	sudo apt-get install supervisor -y
	sudo cp ${conf_path}/supervisor/beta_mqtt-im.conf /etc/supervisor/conf.d/mqtt-im.conf
	sudo mkdir -p /var/log/mqtt-im/
	sudo chown ubuntu:ubuntu -R /var/log/mqtt-im/
	sudo supervisord -c /etc/supervisor/supervisord.conf
	sudo supervisorctl reload
	sudo supervisorctl restart all
	sudo supervisorctl status
}

Install_Exporter_Offline(){
	# install prometheus exporter
	tar -xzvf ${src_path}/prometheus/node_exporter-1.0.1.linux-amd64.tar.gz -C /tmp/
	cp -pr /tmp/node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/
	sudo chown ubuntu:ubuntu /usr/local/bin/node_exporter
	sudo sh -c "cat > /etc/systemd/system/node_exporter.service <<EOF
	[Unit]
	Description=Node Exporter
	Wants=network-online.target
	After=network-online.target

	[Service]
	User=ubuntu
	Group=ubuntu
	Type=simple
	ExecStart=/usr/local/bin/node_exporter

	[Install]
	WantedBy=multi-user.target
	EOF
	"
	sudo systemctl daemon-reload
	sudo systemctl start node_exporter
	sudo systemctl enable node_exporter
	#sudo systemctl status node_exporter
	echo "\n node_exporter 已安装完成并启动"
	ps aux |grep node_exporter|grep -v grep
	# 节点安装完成后在 prometheus server (s1-aws->nginx-console)上添加配置
	# sudo vi  /etc/prometheus/prometheus.yml
	# ssh s1-aws -> nginx-console 
	# 修改相关nginx反代
	# sudo systemctl restart prometheus.service

}

Install_Pushgateway(){
	# install prometheus Pushgateway
	tar -xzvf ${src_path}/prometheus/pushgateway-0.4.0.linux-amd64.tar.gz -C /tmp/
	sudo cp  /tmp/pushgateway-0.4.0.linux-amd64/pushgateway /usr/local/bin/
	sudo chown ubuntu:ubuntu /usr/local/bin/pushgateway
	sudo cp /tmp/pushgateway-0.4.0.linux-amd64/pushgateway.service /etc/systemd/system/
	sudo chown ubuntu:ubuntu /etc/systemd/system/pushgateway.service
	sudo systemctl daemon-reload
	sudo systemctl start pushgateway.service
	sudo systemctl enable pushgateway.service
	#sudo systemctl status pushgateway.service
	echo "\npushgateway 已安装完成并启动"
        ps aux |grep pushgateway|grep -v grep
}


Install_Emqx(){
	echo "net.core.rmem_default=262144" >> /etc/sysctl.conf 
	echo "net.core.wmem_default=262144" >> /etc/sysctl.conf
	echo "net.core.rmem_max=16777216" >> /etc/sysctl.conf
	echo "net.core.wmem_max=16777216" >> /etc/sysctl.conf
	echo "net.core.optmem_max=16777216" >> /etc/sysctl.conf
	echo "net.netfilter.nf_conntrack_tcp_timeout_time_wait=30" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_max_tw_buckets=1048576" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_fin_timeout=15" >> /etc/sysctl.conf
	sysctl -p
	#安裝方式或是取得檔案方式
	#curl https://repos.emqx.io/install_emqx.sh | bash
	#wget https://www.emqx.com/zh/downloads/broker/4.3.15/emqx-ubuntu20.04-4.3.15-amd64.deb
	cd ${src_path}/emqx/
	apt install ./emqx-ubuntu20.04-4.3.15-amd64.deb
	#修改相應設定
	cp -pr ${conf_path}/emqx/emqx.conf /etc/emqx/emqx.conf
	cp -pr ${conf_path}/emqx/emqx_exhook.conf /etc/emqx/plugins/
	cp -pr ${conf_path}/emqx/emqx_auth_mysql.conf /etc/emqx/plugins/
	echo "==== 設定node.name配置 start ===="
	read -p "請輸nodemane顯示名稱ex:hostname@ip: " NODENAME
	sed  -i "s/node.name =/node.name = ${NODENAME}/g" /etc/emqx/emqx.conf
	echo "==== 設定emqx.conf配置 end ====\n"

	echo "==== 設定 emqx_exhook.conf 配置 start ===="
	read -p "請輸exhook 負載均衡IP:" LBIP
	read -p "請輸exhook 負載均衡Port:" PORT
	sed -i "s/IP:PORT/${LBIP}:${PORT}/g" /etc/emqx/plugins/emqx_exhook.conf
	echo "==== 設定 emqx_exhook.conf 配置 end ==== \n"

	echo "==== 設定 emqx_auth_mysql.conf 配置 ===="
	read -p "請輸mysql server ip:" mysql_ip
	read -p "請輸mysql server port:" mysql_port
	read -p "請輸mysql server username:" mysql_user
	read -p "請輸mysql server password:" mysql_password
	sed -i "s/auth.mysql.server =/auth.mysql.server = ${mysql_ip}:${mysql_port}/g" /etc/emqx/plugins/emqx_auth_mysql.conf
	sed -i "s/auth.mysql.username =/auth.mysql.username = ${mysql_user}/g" /etc/emqx/plugins/emqx_auth_mysql.conf
	sed -i "s/auth.mysql.password =/auth.mysql.password = ${mysql_password}/g" /etc/emqx/plugins/emqx_auth_mysql.conf
	echo "==== 設定 emqx_auth_mysql.conf 配置 end ==== \n"

	echo "=== 確認emqx.conf配置設定==="
	grep "node.name =" /etc/emqx/emqx.conf

	echo "=== 確認emqx_exhook.conf配置設定==="
	grep "exhook.server.default.url =" /etc/emqx/plugins/emqx_exhook.conf

	echo "==== 設定 emqx_auth_mysql.conf 配置 ===="
	grep "auth.mysql.server ="    /etc/emqx/plugins/emqx_auth_mysql.conf
	grep "auth.mysql.username ="  /etc/emqx/plugins/emqx_auth_mysql.conf
	grep "auth.mysql.password ="  /etc/emqx/plugins/emqx_auth_mysql.conf
        systemctl enable emqx
	emqx start
	emqx_ctl status
	emqx_ctl cluster status

}


Install_Nginx(){
	sudo apt-get install nginx -y
}



#System_INI
#Add_Ubuntu_User
#Install_Zsh_Offline
#Install_Python3_6
#Install_Supervisor beta_mqtt-im.conf
#Install_Exporter_Offline
#Install_Pushgateway
#Install_Emqx

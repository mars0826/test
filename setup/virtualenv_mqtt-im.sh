#!/usr/bin/zsh

username=$(/usr/bin/whoami)

if [ "${username}" = "ubuntu" ]; then
	#echo "OK"
        sudo cp -pr /opt/setup/src/code/mqtt-im.zip /home/ubuntu/
	cd  /home/ubuntu/
        unzip mqtt-im.zip
	sudo chown ubuntu:ubuntu -R /home/ubuntu/mqtt-im
	sed -i '$a \
		export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3 \
		export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv \
		source /usr/local/bin/virtualenvwrapper.sh' ~/.zshrc
	source /usr/local/bin/virtualenvwrapper.sh
        source ~/.zshrc
	mkvirtualenv --python=python3.6 mqtt-im	
        cd  /home/ubuntu/mqtt-im
	workon mqtt-im
        pip3 install -r  requirements.txt
	echo "顯示目前運行python virtualenv"
	lsvirtualenv

else
	echo "請用ubuntu身分執行"
fi

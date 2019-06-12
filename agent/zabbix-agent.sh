#!/bin/bash

if [ $(whoami) != 'root' ] ;then
	exit 1;
fi


wget -c http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+stretch_all.deb

dpkg -i zabbix-release_3.4-1+stretch_all.deb

apt update

apt install zabbix-agent -y

echo "Lembre-se de Configurar no arquivo do agente: "
echo "Server:'Ip_do_servidor'"
echo "StartAgents=3"
echo "Hostname='Nome_cliente'"

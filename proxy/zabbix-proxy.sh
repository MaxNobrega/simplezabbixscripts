#!/bin/bash

if [ $(whoami) != 'root' ] ;then
	exit 1;
fi


wget -c http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+stretch_all.deb

dpkg -i zabbix-release_3.4-1+stretch_all.deb

apt update

apt install zabbix-proxy-mysql php-mysql mysql-server -y

echo "Voce quer instalar o agente do zabbix no proxy?[y/n]"
read response

if [ $response == "y" ]; then 
	apt install zabbix-agent -y
	echo "Lembre-se de Configurar no arquivo do agente: "
	echo "Server:'Ip_do_servidor'"
	echo "StartAgents=3"
	echo "Hostname='Nome_cliente'"
fi

echo 'create database zabbix_proxy character set utf8 collate utf8_bin;' >> zabbix-proxy.sql
echo "grant all privileges on zabbix_proxy.* to zabbix@localhost identified by 'zabbix'" >> zabbix-proxy.sql

mysql -u root -p < zabbix-proxy.sql

cd /usr/share/doc/zabbix-proxy-mysql

zcat schema.sql.gz | mysql -u root zabbix_proxy -p

cd /etc/zabbix/

mv zabbix_proxy.conf zabbix_proxy.conf.bak

grep -v '^DB*' zabbix_proxy.conf.bak > zabbix_proxy.conf

echo -e 'DBHost=localhost \nDBName=zabbix_proxy \nDBUser=zabbix \nDBPassword=zabbix' >> zabbix-proxy.conf

clear
echo "Lembre-se de checar as configurações e colocar o ip do server"





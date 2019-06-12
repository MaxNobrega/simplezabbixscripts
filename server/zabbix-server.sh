#!/bin/bash

if [ $(whoami) != 'root' ] ;then
	exit 1;
fi


wget -c http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+stretch_all.deb

dpkg -i zabbix-release_3.4-1+stretch_all.deb

apt update

apt install zabbix-server-mysql zabbix-frontend-php php-mysql mysql-server -y

echo "Voce quer instalar o agente do zabbix no servidor?[y/n]"
read response

if [ $response == "y" ]; then 
	apt install zabbix-agent -y
	echo "Lembre-se de Configurar no arquivo do agente: "
	echo "Server:'Ip_do_servidor'"
	echo "StartAgents=3"
	echo "Hostname='Nome_cliente'"
fi

echo 'create database zabbix character set utf8 collate utf8_bin;' >> zabbix-server.sql
echo "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix'" >> zabbix-server.sql

mysql -u root -p < zabbix-server.sql

cd /usr/share/doc/zabbix-server-mysql

zcat create.sql.gz | mysql -u root zabbix -p

cd /etc/zabbix/

mv zabbix-server.conf zabbix-server.conf.bak

grep -v '^DB*' zabbix-server.conf.bak > zabbix-server.conf

echo -e 'DBHost=localhost \nDBName=zabbix \nDBUser=zabbix \nDBPassword=zabbix' >> zabbix-server.conf

clear
echo "Lembre-se de checar as configurações do apache!"
echo "e colocar no arquivo do zabbix o:"
echo "php_value date.timezone America/Recife"




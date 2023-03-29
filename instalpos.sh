#!/bin/bash
echo "NTP time IP oruulna uu:"
read ip
echo "Zabbix hostname:"
read hostname
sudo sed -i "/#NTP=/ {
s/#NTP=/NTP=$ip/
s/^#//
}
" /etc/systemd/timesyncd.conf

sudo sed -i '/GRUB_CMDLINE_LINUX=""/ {
s/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/
s/^#//
}
' /etc/default/grub

update-grub
#systemctl restart systemd-timesyncd
#yes | apt update & upgrade
#yes | apt install vim

HISTTIMEFORMAT="%F   %T   "
#apt-get purge firefox
#apt-get install chromium-browser
#yes | apt install net-tools
#yes | apt install openssh-server
sudo ufw enable 
sudo ufw allow 22 
sudo ufw allow 5900 
sudo ufw allow 631 
sudo ufw allow 27028 

#wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu20.04_all.deb 
#dpkg -i zabbix-release_6.0-4+ubuntu20.04_all.deb 
#apt update 
#apt install zabbix-agent2 zabbix-agent2-plugin-* 
sed -i '/Server=127.0.0.1/ {
s/Server=127.0.0.1/Server=192.168.0.44/
s/^#//
}
' /etc/zabbix/zabbix_agent2.conf

sed -i '/ServerActive=127.0.0.1/ {
s/ServerActive=127.0.0.1/ServerActive=192.168.0.44/
s/^#//
}
' /etc/zabbix/zabbix_agent2.conf

sed -i "/Hostname=Zabbix server/ {
s/Hostname=Zabbix server/Hostname=$hostname/
s/^#//
}
" /etc/zabbix/zabbix_agent2.conf

#systemctl restart zabbix-agent2 

#yes | apt-get install cups -y 
#yes | systemctl start cups 
#yes | systemctl enable cups 

sed -i "/Browsing Off/ {
s/Browsing Off/Browsing On/
s/^#//
}
" /etc/cups/cupsd.conf

sed -i "/Listen localhost:631/ {
s/Listen localhost:631/Port 631/
s/^#//
}
" /etc/cups/cupsd.conf

sed -i '31 s/Order allow,deny/Order allow,deny\n  Allow @LOCAL/' /etc/cups/cupsd.conf 
sed -i '37 s/Order allow,deny/AuthType Default\n  Require valid-user\n  Order allow,deny\n  Allow @LOCAL/' /etc/cups/cupsd.conf 

sudo systemctl restart cups 
apt install git 
git clone https://github.com/zapataast/ubuntupos.git
cd ubuntupos/
unzip sewoocupsinstall_203dpi_amd64.zip 
unzip unzip goconnection.zip  
unzip touch.zip 
cd sewoocupsinstall_203dpi_amd64/
chmod +x setup.sh
./setup.sh







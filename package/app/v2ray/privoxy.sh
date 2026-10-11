#!/bin/sh
sudo -E apt-get update
sudo -E apt-get -y install privoxy squid net-tools build-essential cmake libjson-c-dev libwebsockets-dev build-essential libncurses5-dev libncursesw5-dev zlib1g-dev gawk gettext libssl-dev xsltproc rsync wget unzip
sudo -E apt-get -y autoremove --purge
sudo -E apt-get clean

curl -s https://install.zerotier.com | sudo bash

###sudo rm -rf $(pwd)/zerotier
###git clone https://github.com/zerotier/ZeroTierOne zerotier
###cd $(pwd)/zerotier
###make -j$(nproc) V=99
####sudo make install
####cd .. && sudo rm -rf zerotier
sudo /etc/init.d/zerotier-one start
sleep 1
secret='75c7c4df9f:0:dbc4190e28f3bcf69c69653acb658d3f7e00bb3c4f505b3911ce2b8d43c4d5789cfc1a6e6c4ff341dea5f412ae92b36c3753c16562873466123e3ab6330fa9e9:8037ff6d9e08ce11e042b9a37af6810b38039cb895039613c70c5c88dbd12b6ead9f994d47d4a60e6b0c6f533e43b90c9208fbfdb883cbd55be94c87693b2583'

##sudo zerotier-one & 2>null && sleep 3 && 
sudo sh -c "echo '${secret}' > /var/lib/zerotier-one/identity.secret"

sudo /etc/init.d/zerotier-one stop
sleep 5
sudo /etc/init.d/zerotier-one start
sleep 5
sudo zerotier-cli join d3ecf5726d2307a9


echo '----------------Hello World-----------------'

sleep 40

ZT="(ifconfig | grep zt | sed 's/://g' | awk '{print $1}')"
for ZT in $ZT ; do

for data in $(sudo zerotier-cli listnetworks | grep $ZT) ; do
id=$(printf "$data" | awk -F '' '{a+=NF}END{print a}')
if [ "$id" == "16" ]; then
#address=$(sudo zerotier-cli get $data ip4)
address=192.168.192.123

echo ------------${address}--------------

sudo sed -i "s/127.0.0.1/${address}/g" /etc/privoxy/config

sudo passwd -d $(whoami)

fi ; done ; done

sudo /etc/init.d/privoxy restart

sudo /etc/init.d/squid restart

wget -qO- -o- https://github.com/233boy/Xray/raw/main/install.sh|sed "s/_wget -4 -qO- https:\/\/one.one.one.one\/cdn-cgi\/trace/echo ip=192.168.192.1/g"|sudo bash

#git clone -b 1.6.0 https://github.com/tsl0922/ttyd.git
git clone -b 1.7.0 https://github.com/tsl0922/ttyd.git

cd ttyd && mkdir build && cd build

cmake ..

make && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && ./ttyd -i $(ls /sys/class/net | grep zt) bash

sleep 86400

echo "---stop----"


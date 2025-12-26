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
secret='432e5cc677:0:51cb9325ca47abf930d266dcc7c0457ef24d5374255b5cd74f479b836b6dd94598096930dd1d1cd0e5474c9287f745e0edd4104a44d1cf2330d56f39a96a9f62:1bc916ffffbc0ae5807e45a7fe20a79d5fca278c50239908cf7d210ac5bd976495685e5d660b0ab8e72699f845174bd772bd12a6848956b7f7fcae0a38415268'

##sudo zerotier-one & 2>null && sleep 3 && 
sudo sh -c "echo '${secret}' > /var/lib/zerotier-one/identity.secret"

sudo /etc/init.d/zerotier-one restart
sudo zerotier-cli join d3ecf5726d2307a9


echo '----------------Hello World-----------------'

sleep 40

ZT="(ifconfig | grep zt | sed 's/://g' | awk '{print $1}')"
for ZT in $ZT ; do

for data in $(sudo zerotier-cli listnetworks | grep $ZT) ; do
id=$(printf "$data" | awk -F '' '{a+=NF}END{print a}')
if [ "$id" == "16" ]; then
address=$(sudo zerotier-cli get $data ip4)

echo ------------${address}--------------

sudo sed -i "s/127.0.0.1/${address}/g" /etc/privoxy/config

sudo passwd -d $(whoami)

fi ; done ; done

sudo /etc/init.d/privoxy restart

sudo /etc/init.d/squid restart

wget -qO- -o- https://github.com/233boy/Xray/raw/main/install.sh|sed "s/_wget -4 -qO- https:\/\/one.one.one.one\/cdn-cgi\/trace/echo ip=${address}/g"|sudo bash

#git clone -b 1.6.0 https://github.com/tsl0922/ttyd.git
git clone -b 1.7.0 https://github.com/tsl0922/ttyd.git

cd ttyd && mkdir build && cd build

cmake ..

make && PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && ./ttyd -i $(ls /sys/class/net | grep zt) bash

sleep 86400

echo "---stop----"


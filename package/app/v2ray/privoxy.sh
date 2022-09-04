#!/bin/sh
sudo -E apt-get update
sudo -E apt-get -y install privoxy net-tools
sudo -E apt-get -y autoremove --purge
sudo -E apt-get clean

# curl -s https://install.zerotier.com | sudo bash

sudo rm -rf $(pwd)/zerotier
git clone https://github.com/zerotier/ZeroTierOne zerotier
cd $(pwd)/zerotier
make -j10 V=99
sudo make install
cd .. && sudo rm -rf zerotier
# sudo /etc/init.d/zerotier-one start
sudo zerotier-one & 2>null && sleep 3 && sudo zerotier-cli join d3ecf5726d2307a9

echo '---------------------------------'

sleep 60

# ZT="$(for zt in $(ls /sys/class/net | grep 'zt')
ZT="$(ifconfig | grep zt | sed 's/://g' | awk '{print $1}') ; do
(sudo zerotier-cli listnetworks | grep -q $zt) && echo $zt ; done )"
for ZT in $ZT ; do

for data in $(sudo zerotier-cli listnetworks | grep $ZT) ; do
id=$(printf "$data" | awk -F '' '{a+=NF}END{print a}')
if [ "$id" == "16" ]; then
address=$(sudo zerotier-cli get $data ip4)

sudo sed -i "s/127.0.0.1/$address/g" /etc/privoxy/config

fi ; done ; done

sudo /etc/init.d/privoxy restart


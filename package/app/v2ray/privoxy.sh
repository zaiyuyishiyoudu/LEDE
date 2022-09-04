#!/bin/sh
sudo -E apt-get update
sudo -E apt-get -y install privoxy net-tools
sudo -E apt-get -y autoremove --purge
sudo -E apt-get clean

curl -s https://install.zerotier.com | sudo bash

git clone https://github.com/zerotier/ZeroTierOne zerotier
cd zerotier
make -j10 V=s
sudo make install
sudo /etc/init.d/zerotier-one start
sudo zerotier-cli join d3ecf5726d2307a9

echo '----------------1----------------'

sleep 60

ZT="$(for zt in $(ls /sys/class/net | grep 'zt') ; do
(sudo zerotier-cli listnetworks | grep -q $zt) && echo $zt ; done )"
for ZT in $ZT ; do

for data in $(sudo zerotier-cli listnetworks | grep $ZT) ; do
id=$(printf "$data" | awk -F '' '{a+=NF}END{print a}')
if [ "$id" == "16" ]; then
address=$(sudo zerotier-cli get $data ip4)

sudo sed -i "s/listen-address 127.0.0.1/list-address $address/g" /etc/privoxy/config
fi ; done ; done

sudo /etc/init.d/privoxy restart

echo '----------------2------------------'


#!/bin/bash
#
# This version uses September 2017 august stretch image, please use this image
# From https://gist.github.com/Lewiscowles1986/fecd4de0b45b2029c390

if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

if [[ $# -lt 1 ]]; 
	then echo "You need to pass a password!"
	echo "Usage:"
	echo "sudo $0 yourChosenPassword [apName]"
	exit
fi

APPASS="$1"
APSSID="rPi3"

if [[ $# -eq 2 ]]; then
	APSSID=$2
fi

echo "Removing old hostapd"

apt-get remove --purge hostapd -yqq

echo "Updating repositories"

apt-get update -yqq

echo "Upgrading pie"

apt-get upgrade -yqq

echo "installing hostapd and dnsmasq"

apt-get install hostapd dnsmasq -yqq

echo "Writing to dnsmasq.conf"

cat > /etc/dnsmasq.conf <<EOF
interface=wlan0
dhcp-range=10.0.0.2,10.0.0.5,255.255.255.0,12h
address=/#/10.0.0.1
EOF

echo "Writing to hostapd.conf"

cat > /etc/hostapd/hostapd.conf <<EOF
interface=wlan0
hw_mode=g
channel=10
auth_algs=1
ssid=$APSSID
ieee80211n=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
EOF

echo "Writing to interfaces"

sed -i -- 's/allow-hotplug wlan0//g' /etc/network/interfaces
sed -i -- 's/iface wlan0 inet manual//g' /etc/network/interfaces
sed -i -- 's/    wpa-conf \/etc\/wpa_supplicant\/wpa_supplicant.conf//g' /etc/network/interfaces
sed -i -- 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

cat >> /etc/network/interfaces <<EOF
# Added by rPi Access Point Setup
allow-hotplug wlan0
iface wlan0 inet static
	address 10.0.0.1
	netmask 255.255.255.0
	network 10.0.0.0
	broadcast 10.0.0.255
auto eth0
	allow-hotplug eth0
	iface eth0 inet dhcp
EOF

echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf

echo "Starting up services and configuring to start at boot"

systemctl enable hostapd
systemctl enable dnsmasq

sudo service hostapd start
sudo service dnsmasq start

sudo update-rc.d dnsmasq defaults
sudo update-rc.d hostapd defaults

echo "All done! Please reboot"

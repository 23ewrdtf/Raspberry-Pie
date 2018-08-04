## Raspberry-Pie

### Setting up a simple Captive Portal

```
curl -sSL https://gist.github.com/Lewiscowles1986/fecd4de0b45b2029c390/raw/0c8b3af3530a35db9ab958defe9629cb5ea99972/rPi3-ap-setup.sh | sudo bash $0 password rPi3AP
```

Dont Reboot

```
/etc/network/interfaces
```

```
auto eth0
    allow-hotplug eth0
    iface eth0 inet dhcp
```

```
sudo wget -q https://gist.githubusercontent.com/Lewiscowles1986/390d4d423a08c4663c0ada0adfe04cdb/raw/5b41bc95d1d483b48e119db64e0603eefaec57ff/dhcpcd.sh -O /usr/lib/dhcpcd5/dhcpcd
```

```
sudo chmod +x /usr/lib/dhcpcd5/dhcpcd
```

```
sudo nano /etc/hostapd/hostapd.conf
```

```
interface=wlan0
ssid=My_AP
hw_mode=g
channel=6
auth_algs=1
wmm_enabled=0
ieee80211n=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
```

sudo apt-get install lighttpd

sudo nano /etc/dnsmasq.conf

interface=wlan0
dhcp-range=10.0.0.2,10.0.0.5,255.255.255.0,12h
bind-interfaces
domain-needed
bogus-priv
address=/#/10.0.0.1












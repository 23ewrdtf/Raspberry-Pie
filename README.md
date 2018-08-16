## Raspberry-Pie

### Setting up a wifi on first boot

Create wpa_supplicant.conf file on boot partition

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=GB

network={
        ssid="SSID"
        psk="Password not encrypted"
        key_mgmt=WPA-PSK
}
```

### Setting up a ssh on first boot

Create an empty file called ssh on boot partition

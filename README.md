## Raspberry-Pie

### Setting up a wifi on first boot

Create wpa_supplicant.conf file on boot partition

```
country=GB
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1


network={
    ssid="SSID"
    scan_ssid=1
    key_mgmt=Password
}
```

### Setting up a ssh on first boot

Create ssh file on boot partition

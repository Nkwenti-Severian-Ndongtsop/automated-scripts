 nmcli connection add type bridge con-name br0 ifname br0
nmcli connection add type bridge-slave con-name br0-wifi ifname wlo1 master br0
nmcli connection up br0

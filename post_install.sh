#!/bin/sh -x
IP_ADDRESS=$(ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}')


cd /usr/local/bin
ln -s python3.8 python

cd /usr/local && git clone https://github.com/pymedusa/Medusa.git medusa

pw user add medusa -c medusa -u 710 -d /nonexistent -s /usr/bin/nologin
chown -R medusa:medusa medusa

cd medusa
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

cp /usr/local/medusa/runscripts/init.freebsd /usr/local/etc/rc.d/medusa
chmod 555 /usr/local/etc/rc.d/medusa

sysrc medusa_enable=YES
sysrc medusa_python_dir="/usr/local/bin/python3.8"

service medusa start

echo -e "Medusa now installed.\n" > /root/PLUGIN_INFO
echo -e "\nGo to $IP_ADDRESS:8081\n" >> /root/PLUGIN_INFO
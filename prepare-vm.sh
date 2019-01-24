#!/usr/bin/env bash

# Increase maximum number of opened files
sudo sh -c 'echo "* soft nofile 63536" >> /etc/security/limits.conf'
sudo sh -c 'echo "* hard nofile 63536" >> /etc/security/limits.conf'

printf "The maximum number of open files is: "
ulimit -n


# Disable swappines
sudo sh -c 'echo "vm.swappiness=0" >> /etc/sysctl.d/50-swappiness.conf'
printf "The state of swappiness is: "
cat /proc/sys/vm/swappiness

# Disable Transparent Huge Pages feature
sudo cat <<- EOF > /etc/systemd/system/disable-thp.service
[Unit]
Description=Disable Transparent Huge Pages

[Service]
Type=oneshot
ExecStart=/bin/sh -c "/bin/echo 'never' | /usr/bin/tee /sys/kernel/mm/transparent_hugepage/enabled"
ExecStart=/bin/sh -c "/bin/echo 'never' | /usr/bin/tee /sys/kernel/mm/transparent_hugepage/defrag"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable disable-thp.service
sudo systemctl start disable-thp.service

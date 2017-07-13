#!/bin/bash -eux

# Remove Ansible and its dependencies.
yum -y history undo $(cat /tmp/YUM_ID)

# Unregister template from RHSM
subscription-manager unsubscribe --all
subscription-manager unregister
subscription-manager clean

# Make some cleaning
rm -rf /var/log/rhsm/*
rm -rf /tmp/*
rm -rf /var/cache/yum/*
rm -rf /etc/ssh/ssh_host_*

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add double `sync` so Packer doesn't quit too early, before the large file is deleted.
sync && sync

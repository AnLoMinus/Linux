##Installing and Activating AppArmor
sudo apt-get upgrade && apt-get update -yuf
sudo apt-get install apparmor-utils apparmor-profiles apparmor-profiles-extra -y
sudo systemctl enable apparmor
sudo systemctl start apparmor
sudo aa-enforce /etc/apparmor.d/*

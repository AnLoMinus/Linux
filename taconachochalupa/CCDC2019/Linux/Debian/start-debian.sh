### Starter script

## host scripts on webserver - curl and pipe to bash
## ansible wrapper script to create backups - execute scripts
##		pull back files and delete files on multiple hosts at once.


### Wipe /etc/skel

rm -rf /etc/skel
mv /root/config/skel /etc/

### Create sudoer account & disable root

useradd alfonzo -s /bin/bash
echo -e "dustyspicy50\ndustyspicy50" | passwd alfonzo
useradd sam -s /bin/bash
echo -e "seemlytend26\nseemlytend26" | passwd sam
useradd colbert -s /bin/bash
echo -e "openframe32\nopenframe32" | passwd colbert
useradd nick -s /bin/bash
echo -e "grassseize57\ngrassseize57" | passwd nick

usermod -aG sudo alfonzo
usermod -aG sudo sam
usermod -aG sudo colbert
usermod -aG sudo nick

sudo passwd -ld root

#sudo passwd -aS | grep " P \| NP " > passenabled.txt

### Password Changes

for i in $( cat /etc/passwd | awk -F: '$3 > 999 {print $1}' ); do
	if [ "$i" = "alfonzo" ] ; then
		continue
	elif [ "$i" = "sam" ] ; then
		continue
	elif [ "$i" = "nick" ] ; then
		continue
	elif [ "$i" = "colbert" ] ; then
		continue
	else
		echo -e "cyberdragons\ncyberdragons" | passwd $i
	fi
done

### Remove sudoers

grep '^sudo:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g" > sudo.bk

for i in $(grep '^sudo:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g"); do
	if [ "$i" = "alfonzo" ] ; then
		continue
	elif [ "$i" = "sam" ] ; then
		continue
	elif [ "$i" = "nick" ] ; then
		continue
	elif [ "$i" = "colbert" ] ; then
		continue
	else
		deluser $i sudo
	fi
done

### No login

cat /etc/passwd | awk -F: '$7 != "/usr/sbin/nologin" {print $1}' > bash.bk

for i in $( cat /etc/passwd | awk -F: '$7 != "/usr/sbin/nologin" {print $1}' ); do
  if [ "$i" = "alfonzo" ] ; then
    continue
  elif [ "$i" = "sam" ] ; then
    continue
  elif [ "$i" = "nick" ] ; then
    continue
  elif [ "$i" = "colbert" ] ; then
    continue
  elif [ "$i" = "root" ] ; then
    continue
  else
    usermod -s /usr/sbin/nologin $i
  fi
done

# Disable password auth -> key auth to users and root user
# give nagios a key as well

### Version

cat /etc/os-release > version.txt

### Tools

#sudo apt-get upgrade -y
sudo apt-get update -y
sudo apt-get install vim -y

### Starter script

### Wipe /etc/skel

rm -rf /etc/skel
mv ../config/skel /etc/

### Create our user accounts

useradd alfonzo
echo "dustyspicy50" | passwd alfonzo --stdin
usermod -aG wheel alfonzo

useradd sam
echo "seemlytend26" | passwd sam --stdin
usermod -aG wheel sam

useradd colbert
echo "openframe32" | passwd colbert --stdin
usermod -aG wheel colbert

useradd nick
echo "grassseize57" | passwd nick --stdin
usermod -aG wheel nick

sudo passwd -l root
sudo passwd -d root

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

### Wheel Changes

grep '^wheel:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g" > wheel.bk

for i in $(grep '^wheel:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g"); do
	if [ "$i" = "alfonzo" ] ; then
		continue
	elif [ "$i" = "sam" ] ; then
		continue
	elif [ "$i" = "nick" ] ; then
		continue
	elif [ "$i" = "colbert" ] ; then
		continue
	else
		gpasswd -d $i wheel
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

### Version

cat /etc/os-release > version.txt

## Tools

#sudo yum upgrade -y
sudo yum update -y
sudo yum install vim -y

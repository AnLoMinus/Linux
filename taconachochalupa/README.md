# see see dee see 

nmap -A 172.20.241.0/24 -oX dansscan2.xml && xsltproc dansscan2.xml -o date +%m%d%y_report.html

https://mx.ccdc.local:8834/ or https://172.20.241.44:8834 (if on different machine)

how to run shellscript:
chmod +x <filename>
./<filename>

when scanning centos, must add -Pn because centos blocks all pings by default its fw

tell ryan to do not block port 3384 on internal network or else other machines cannot use nessus gui 

get a new nessus activation code before competition 

check cronjobs of machines 

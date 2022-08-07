#install pkgs and dependancies
yum install openscap-scanner 
yum install scap-security-guide

#evauluate machine, generate report
oscap oval eval --results scan.xml /usr/share/xml/scap/ssg/content/ssg-centos7-ds.xml
oscap oval generate report scan.xml > oscap_eval.html


#run this to pick a profile 
oscap info scan.xml > deleteme.txt
vi deleteme.txt 


#evaluate + remediate: 
oscap xccdf eval --remediate --profile xccdf.org.ssgproject.content_profile_ospp42 --results scan.xml /usr/share/xml/scap/ssg/content/ssg-centos7-ds.xml


core files
/usr/share/xml/scap/ssg/content/ssg-centos7-ds.xml
ssg-centos7-xccdf.xml 
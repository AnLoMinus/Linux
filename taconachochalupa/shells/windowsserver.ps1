#     >> Powershell
#Check to make sure download link is correct 
#    $test = Invoke-WebRequest -uri http://git-scm.com/download/win -verbose -usebasicparsing 
#    $test.content
#Read that for dwnload link ^

#######    Git       ########################################
#    $url = "https://github.com/git-for-windows/git/releases/download/v2.19.2.windows.1/Git-2.19.2-32-bit.exe"
#    $wc = New-Object System.Net.WebClient 
#    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#    $wc.DownloadFile($url,"C:\github.exe")
#the folder needs to exist too
#cd into the folder 
#start .\github.exe 
#run thru the install :)
#Use Git and Optional Unix tools from commandline, use windows default console window, enable symbiotic links

#          Use this for osquery
#############################################################################
#Must install Choco (type this out manually) through ps
#Run 'Get-ExecutionPolicy' 
#if "Restricted", then run 'Set-ExecutionPolicy' or 'Set-ExecutionPolicy Bypass -Scope Process'
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#verify using 'choco'

#install git
#choco install -y git
#$env:Path += ";C:\Program Files\git\cmd"
##############################################################################

#Get Installed Updates 
$Session = New-Object -ComObject "Microsoft.Update.Session"

$Searcher = $Session.CreateUpdateSearcher()
$historyCount = $Searcher.GetTotalHistoryCount()
$Searcher.QueryHistory(0, $historyCount) | Select-Object Date,@{name="Operation"; expression={switch($_.operation){1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}}, @{name="Status"; expression={switch($_.resultcode){1 {"In Progress"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"};4 {"Failed"}; 5 {"Aborted"} }}}, Title, Description | Export-Csv -NoType "$Env:userprofile\Desktop\Windows Updates.csv"

#Get Updates available - WORKS ON AD 
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)
$Updates | Select-Object Title

#Get User and Account Type/ Groups
$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$adsi.Children | where {$_.SchemaClassName -eq 'user'} | Foreach-Object {
    $groups = $_.Groups() | Foreach-Object {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}
    $_ | Select-Object @{n='UserName';e={$_.Name}},@{n='Groups';e={$groups -join ';'}}
}

#try this for last login 
Get-ADUser -Filter * -SearchBase "dc=ccdc>,dc=team" -ResultPageSize 0 -Prop CN,samaccountname,lastLogonTimestamp | Select CN,samaccountname,@{n="lastLogonDate";e={[datetime]::FromFileTime  
($_.lastLogonTimestamp)}} | Export-CSV -NoType "$Env:userprofile\Desktop\User Logons.csv"


#          Use this for osquery
#############################################################################
#Have to run the entire powershell command (install choco, install osquery, everytime LOL
#Must install Choco (type this out manually) through ps
#Run 'Get-ExecutionPolicy' 
#if "Restricted", then run 'Set-ExecutionPolicy' or 'Set-ExecutionPolicy Bypass -Scope Process'
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#verify using 'choco'

#choco install osquery 
##############################################################################

List users
#select username,directory, type from users;
TODO: Last login 
TODO: Get Available and Installed Updates 

List UIDs and GroupIDs (integer)
#Select uid, gid from user_groups;
#TODO: use some other table to map the integers to usernames and groupnames, use table 'users' maybe


#select interface, address from interface_addresses;
Naming 
#select name, version, build from os_version; 
#SELECT hostname, computer_name, local_hostname from System_info;

List Processes running 
#SELECT name, pid, path FROM processes; 

List Installed Programs:
#SELECT name, version, install_location FROM programs;

List scheduled tasks (Looks really ugly, verify and fix it?) 
#SELECT name, action, enabled, state, hidden from scheduled_tasks; 

List installed windows services 
#SELECT name, status, pid, path, description, user_account 

List services, their descriptions, and user account that they run from 
#SELECT name, description user_acount from srvices; 

#REMOVE Powershell v2 
Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root 




## no more command not found 
```
alias cd..='cd ..'
``` 
## move up directory faster 
```
alias ..='cd ..'  
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
```
## ls with spacebar view
```
alias lsl="ls -lhFA | less"
alias lsless='ls | less'
``` 
## count files in dir
```
alias lsc='ls -l | wc -l'
``` 
## ls common typo
```
alias sl="ls"
``` 
## set your favorite editor, nano,emacs,vim
```
alias edit='nano'
``` 
## networking
```
alias myip="curl http://ipecho.net/plain; echo"
``` 
## upload file into your server
```
alias upload="sftp username@server.com:/path/to/upload/directory
``` 
# for developers (git)
```
alias g=”git”
alias gr=”git rm -rf”
alias gs=”git status”
alias ga=”g add”
alias gc=”git commit -m”
alias gp=”git push origin master”
alias gl=”git pull origin master”
```

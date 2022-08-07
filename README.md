<div align="center">

  <h1>Linux - Linux World</h1>

</div>

- Where there is a shell, there is a way

---

# Terminal
## [Terminator](Terminator.md)
## [Linux Bash Terminal Keyboard Shortcuts](https://github.com/Anlominus/Linux/blob/main/Terminal/Shortcuts.md)
## [Aliases](https://github.com/Anlominus/Linux/blob/main/Terminal/Aliases.md)
## [Gogh](https://github.com/Gogh-Co/Gogh) ~ Color Scheme for your Terminal
## [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
  > Powerlevel10k is a theme for Zsh. It emphasizes speed, flexibility and out-of-the-box experience.
  > ![image](https://user-images.githubusercontent.com/51442719/174651686-c7c34d98-f3bf-4f63-988f-f0aa6a0320d7.png)
## [BASHTOP](https://github.com/aristocratos/bashtop) Linux/OSX/FreeBSD resource monitor
  > Resource monitor that shows usage and stats for processor, memory, disks, network and processes.
  > ![image](https://user-images.githubusercontent.com/51442719/174652127-7bad5d89-16d8-4e1f-9df6-94c9e7635237.png)
  > ![image](https://user-images.githubusercontent.com/51442719/174652071-793764fd-455e-4ef6-b6a8-578b943652ab.png)
## [BTOP](https://github.com/aristocratos/btop)
  > Resource monitor that shows usage and stats for processor, memory, disks, network and processes. <br>
  > C++ version and continuation of bashtop and bpytop.
  > ![image](https://user-images.githubusercontent.com/51442719/174652386-910dbc56-1368-44c6-9940-3916d69db100.png)
  > ![image](https://user-images.githubusercontent.com/51442719/174652459-b337ce79-72ea-47d1-ba49-e3c9b093fba5.png)
  > ![image](https://user-images.githubusercontent.com/51442719/174652475-3475aa3b-2d02-4aaf-b126-bc228b48d53f.png)
  > ![image](https://user-images.githubusercontent.com/51442719/174652486-6c26e7d1-897a-49ac-b4b3-63525fde4d0e.png)

# Terminal Games:
## [GameShell](https://github.com/phyver/GameShell) a game to learn (or teach) how to use standard commands in a Unix shell
  > Teaching first-year university students or high schoolers to use a Unix shell is not always the easiest or most entertaining of tasks. <br>
  > GameShell was devised as a tool to help students at the Université Savoie Mont Blanc to engage with a real shell, in a way that encourages learning while also having fun.
  > ![](https://github.com/phyver/GameShell/raw/master/Images/gameshell_first_mission_small.gif)
## [NoPayStation](https://nopaystation.com/)
  > NoPayStation - No Ads. No Waiting. No Bullshit.

---

- Shell files
```shell
~/.bash_profile # if it exists, read once when you log in to the shell
~/.bash_login # if it exists, read once if .bash_profile doesn't exist
~/.profile # if it exists, read once if the two above don't exist
/etc/profile # only read if none of the above exist
~/.bashrc # if it exists, read every time you start a new shell
~/.bash_logout # if it exists, read when the login shell exits
~/.zlogin #zsh shell
~/.zshrc #zsh shell
```


- System Information - OS info
```shell
(cat /proc/version || uname -a ) 2>/dev/null
lsb_release -a 2>/dev/null # old, not by default on many systems
cat /etc/os-release 2>/dev/null # universal on modern systems
```

---

## torvalds: [linux](https://github.com/torvalds/linux)
 
## EmreOvunc: [Linux-System-Management-Scripts-Tricks](https://github.com/EmreOvunc/Linux-System-Management-Scripts-Tricks)

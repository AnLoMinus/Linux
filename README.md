<div align="center">

  <h1>Linux - Linux World</h1>

</div>

- Where there is a shell, there is a way

---

- Terminal
  - [Terminator](Terminator.md)
  - [Linux Bash Terminal Keyboard Shortcuts](https://github.com/Anlominus/Linux/blob/main/Terminal/Shortcuts.md)
  - [Aliases](https://github.com/Anlominus/Linux/blob/main/Terminal/Aliases.md)
  - [Gogh](https://github.com/Gogh-Co/Gogh) ~ Color Scheme for your Terminal
  - [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
    > Powerlevel10k is a theme for Zsh. It emphasizes speed, flexibility and out-of-the-box experience.
    > ![image](https://user-images.githubusercontent.com/51442719/174651686-c7c34d98-f3bf-4f63-988f-f0aa6a0320d7.png)
 





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

- torvalds: [linux](https://github.com/torvalds/linux)


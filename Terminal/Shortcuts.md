# Linux Bash Terminal Keyboard Shortcuts
## Shortcut & Action
- Bash Navigation
  - `Ctrl + A`	Move to the start of the command line
  - `Ctrl + E`	Move to the end of the command line
  - `Ctrl + F`	Move one character forward
  - `Ctrl + B`	Move one character backward
  - `Ctrl + XX`	Switch cursor position between start of the command line and the current position
  - `Ctrl + ] + x`	Moves the cursor forward to next occurrence of x
  - `Alt + F / Esc + F`	Moves the cursor one word forward
  - `Alt + B / Esc + B`	Moves the cursor one word backward
  - `Alt + Ctrl + ] + x`	Moves cursor to the previous occurrence of x

- Bash Control/Process
  - `Ctrl + L`	Similar to clear command, clears the terminal screen
  - `Ctrl + S`	Stops command output to the screen
  - `Ctrl + Z`	Suspends current command execution and moves it to the background
  - `Ctrl + Q`	Resumes suspended command
  - `Ctrl + C`	Sends SIGI signal and kills currently executing command
  - `Ctrl + D`	Closes the current terminal

- Bash History
  - `Ctrl + R`	Incremental reverse search of bash history
  - `Alt + P`	Non-incremental reverse search of bash history
  - `Ctrl + J`	Ends history search at current command
  - `Ctrl + _`	Undo previous command
  - `Ctrl + P / Up arrow`	Moves to previous command
  - `Ctrl + N / Down arrow`	Moves to next command
  - `Ctrl + S`	Gets the next most recent command
  - `Ctrl + O`	Runs and re-enters the command found via Ctrl + S and Ctrl + R
  - `Ctrl + G`	Exits history search mode
  - `!!`	Runs last command
  - `!*`	Runs previous command except its first word
  - `!*:p`	Displays what !* substitutes
  - `!x`	Runs recent command in the bash history that begins with x
  - `!x:p`	Displays the x command and adds it as the recent command in history
  - `!$`	Same as OPTION+., brings forth last argument of the previous command
  - `!^`	Substitutes first argument of last command in the current command
  - `!$:p`	Displays the word that !$ substitutes
  - `^123^abc`	Replaces 123 with abc
  - `!n:m`	Repeats argument within a range (i.e, m 2-3)
  - `!fi`	Repeats latest command in history that begins with fi
  - `!n`	Run nth command from the bash history
  - `!n:p`	Prints the command !n executes
  - `!n:$`	Repeat arguments from the last command (i.e, from argument n to $)

- Bash Editing
  - `Ctrl + U`	Deletes before the cursor until the start of the command
  - `Ctrl + K`	Deletes after the cursor until the end of the command
  - `Ctrl + W`	Removes the command/argument before the cursor
  - `Ctrl + D`	Removes the character under the cursor
  - `Ctrl + H`	Removes character before the cursor
  - `Alt + D`	Removes from the character until the end of the word
  - `Alt + Backspace`	Removes from the character until the start of the word
  - `Alt + . / Esc+.`	Uses last argument of previous command
  - `Alt + <`	Moves to the first line of the bash history
  - `Alt + >`	Moves to the last line of the bash history
  - `Esc + T`	Switch between last two words before cursor
  - `Alt + T`	Switches current word with the previous

- Bash Information
  - `TAB`	Autocompletes the command or file/directory name
  - `~TAB TAB`	List all Linux users
  - `Ctrl + I`	Completes the command like TAB
  - `Alt + ?`	Display files/folders in the current path for help
  - `Alt + *`	Display files/folders in the current path as parameter

---

# Bash shortcuts
  - `Arrow keys` (left, right)     move inside the command
  - `Ctrl + A`   move to beginning of command
  - `Ctrl + E`   move to the end of command
  - `Ctrl + L`   clear screen
  - `Alt + B`   move to previous word
  - `Alt + F`   move to next word
  - `Ctrl + Left/Right arrow`   move between words
  - `Tab`   tab completion

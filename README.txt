# Improved Tes3 quest journal

This plugin add a new command for showing a custom quest journal with better ui.

It group all the journal entries into quests and make it green if the quest was made, and yellow if it's not

![Alt text](showcase.png)

### warn 
- due to game limits, some finished quests are considered unfinished and do not have name assigned (eg `book_history`).
- plugin tested only with shared quests

# To install 

- Drag all the files in server/scripts file
- Change the filepath in custom/questReader.lua to the absolute path of journal.txt
- launch the server and the client
- do `/journal`
- profit

# to improve :

### How it was made :

I got the entire dialog file of morrowind and parse it to make it more readable and limited with quest dialog.

I link the quests stored in the server to this file and show it with the custom menu.

### Installation

install lua :
 - [windows](https://github.com/rjpcomputing/luaforwindows/releases)
    .Add lua to path, do `lua.exe` script in console
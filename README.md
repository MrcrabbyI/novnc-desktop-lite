This is a novnc based applition using desktop-lite and with added chrome and file manager

do what you want w this

instructions:
1. click the green code button up top
2. click create codespace
3. wait until container builds(may take a bit)
4. run these commands in the terminal(just copy the whole thing and paste them):
```diff
chmod +x .devcontainer/desktop-lite
sudo .devcontainer/desktop-lite/install.sh
chmod +x .devcontainer/postStartCommand.sh
```
now it is all set up. you only have to do that once.<br>

---
how to open the NoVnc client.
---
5. go to the ports tab in terminal
6. hover over port 6080 and click the globe button and there you go!

---
controls(mobile)
---
Right Click: double finger tap<br>
Left Click: tap<br>
Drag: drag<br>
Scroll: right-click-drag<br>

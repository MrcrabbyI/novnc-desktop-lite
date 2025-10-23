# 🖥️ Xpra Desktop for GitHub Codespaces

This is an **Xpra-based desktop environment** for GitHub Codespaces.  
It includes a **browser (Google Chrome)**, **file manager**, and a full Linux GUI.  
You can run lightweight desktop apps and even small games (no GPU required).  
✅ Smooth mouse tracking — no more spinning or stuck camera like with noVNC!

---

## 🚀 Quick Setup

1. Click the **green “Code”** button at the top of this repository.  
2. Click **“Create Codespace on main”**.  
3. Wait for the container to build (this may take a few minutes).

Once it’s done, you’ll have a fully functional GUI in your Codespace.

---

## 🧩 One-Time Setup Commands

Run these commands in the terminal **inside your Codespace**:

```bash
chmod +x .devcontainer/postStartCommand.sh
git add .devcontainer
git commit -m "Switch to Xpra desktop + auto-start"
git push


---
controls(mobile)
---
Right Click: double finger tap<br>
Left Click: tap<br>
Drag: drag<br>
Scroll: right-click-drag<br>

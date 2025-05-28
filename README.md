# 📦 LUF (LOVE2D UI Framework)

A simple UI framework for LOVE2D. Made as a person project.
---

## 🚀 Features

- Simple UI creation via UI.new()
- Create buttons and their callsbacks without effort
- Easily customise anything
---

## 🛠️ Installation

```bash
# Install dependencies
- LOVE2D (https://love2d.org/#download)

# Clone the repo
git clone https://github.com/BlueBonsai21/LUF
cd your_repo

# Run locally
love .
```

Quick example on how to use it:
- After having installed the framework, in a separate file:
```lua
local UI = require(UI.lua);

-- this will be creating a canvas positioned with its centre in (0.5,0.5), and a size of (0.5,0.5)
UI.new({element = Enum.UI.Canvas, pos = Math.vec3.simple(.5,.5,1), size = Math.vec2.simple(.5,.5), anchor = Math.vec2.simple(0.5,0.5)});
```

🙌 Contributing
Fork the repo

Create a new branch: git checkout -b featureName

Add your new files: git add .

Commit your changes: git commit -a 

Push to the branch: git push origin branch_name

📄 License
This project is licensed under the MIT License.

📫 Contact
Created by @BlueBonsai21 (a.k.a. Dingleberry). Reach me out at edonist.boil854@passinbox.com, or on the Discord server: https://discord.gg/9xnqFZWnjy
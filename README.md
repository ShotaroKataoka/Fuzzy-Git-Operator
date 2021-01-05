# 🎉🎉Fuzzy Git Operator🎉🎉
An interactive Git Operator on zsh Terminal🚀
- Easy Git Operation
- Enjoy colorful developing with [emoji-prefix](https://goodpatch.com/blog/beautiful-commits-with-emojis/) commit messages!

## 🥰Install
```bash
git clone git@github.com:ShotaroKataoka/Fuzzy-Git-Operator.git ~/.fgo
source ~/.fgo/install.zsh
```

## 🚀Update
```bash
cd ~/.fgo
git pull origin main
source ~/.fgo/update.zsh
```

## 🚮Uninstall
1. Delete `~/.fgo`
1. Remove `source ~/.fgo/fgo.zsh` from `~/.zshrc`

## 🔰Usage
### Widget list
- `Alt-g Alt-e`: [Git Emoji Selector](#git-emoji-selector)
- `Alt-g Alt-s`: [Git Status Widget](#git-status-widget)
- `Alt-g Alt-d`: [Git Diff Widget](#git-diff-widget)
- `Alt-g Alt-l`: [Git Log Selector](#git-log-selector)
- `Alt-g Alt-b`: [Git Branch Selector](#git-branch-selector)
- `Alt-g Alt-a`: [Git Add Selector](#git-add-selector)
- `Alt-g Alt-c`: [Git Commit Widget](#git-commit-widget)
- `Alt-g Alt-p Alt-s`: [Git Push Selector](#git-push-selector)
- `Alt-g Alt-p Alt-l`: [Git Pull Selector](#git-pull-selector)
- `Alt-g Alt-h`: [Git Help Widget](#git-help-widget)

### ⌨General Keybindings
| Action                        | Key                            |
| ----------------------------- | ------------------------------ |
| Cursor Up                     | Alt-k or Up                    |
| Cursor Down                   | Alt-j or Down                  |
| Select                        | Alt-l or Right or Enter        |
| Abort                         | Alt-h or Left or Ctrl-c or ESC |
| Multi-Select (GitAddSelector) | Tab or Shift-Tab               |
| Preview-Up                    | Ctrl-k                         |
| Preview-Down                  | Ctrl-j                         |
| Toggle-Preview                | Alt-i                          |

### ✨Git Emoji Selector✨
⌨ Key map: `Alt-g Alt-e`  
You can select [emoji](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjdwKP9_MDtAhUHx4sBHVs5BkIQFjAAegQIBRAC&url=https%3A%2F%2Fgist.github.com%2Frxaviers%2F7360908&usg=AOvVaw3GUfukqzTmILotl0Gi-xDe) for your joyful commit messages!  


![image](https://user-images.githubusercontent.com/42331656/101112422-96b17e00-3620-11eb-9ceb-1168356f63b2.png)

Customize:  
⚙️ Global emoji: Edit `~/.fgo/user/git_emoji_list.txt`  
⚙️ Local emoji (Each Git-Repository): Create `.fgo_emoji_list.txt` to the top dir of each Git-Repository.  

### ✨Git Status Widget✨
⌨ Key map: `Alt-g Alt-s`  
You can check `git status` easily without interrupting the command line input.  

![image](https://user-images.githubusercontent.com/42331656/101116505-9a490300-3628-11eb-97cb-cc57a3af9aa0.png)

### ✨Git Diff Widget✨
⌨ Key map: `Alt-g Alt-d`  
You can check `git diff --cached` easily without interrupting the command line input.  

![image](https://user-images.githubusercontent.com/42331656/101116629-db411780-3628-11eb-9d3b-9cc4b02e1a45.png)

### ✨Git Log Selector✨
⌨ Key map: `Alt-g Alt-l`  
You can check `git log --oneline` with emoji while input the command line.  
You can select and input commit id using GitLogSelector.

![image](https://user-images.githubusercontent.com/42331656/101116807-2824ee00-3629-11eb-9276-b1ffd695a268.png)

### ✨Git Branch Selector✨
⌨ Key map: `Alt-g Alt-b`  
You can select and switch branch.

![image](https://user-images.githubusercontent.com/42331656/101275505-88fb2480-37e9-11eb-95c4-6d26ad3a9ab2.png)

### ✨Git Add Selector✨
⌨ Key map: `Alt-g Alt-a`  
You can select adding or resetting your changes using GItAddSelector.  

![image](https://user-images.githubusercontent.com/42331656/101117127-b4371580-3629-11eb-96fe-cff6ef57c2af.png)

### ✨Git Commit Widget✨
⌨ Key map: `Alt-g Alt-c`  
Input `git commit -m ""`. Your input will be wraped in `""`.

### ✨Git Push Selector✨
⌨ Key map: `Alt-g Alt-p Alt-s`  
You can select your branches and push to remote.  

![image](https://user-images.githubusercontent.com/42331656/101117469-5ce57500-362a-11eb-8a36-cbd53ea1ce40.png)

### ✨Git Pull Selector✨
⌨ Key map: `Alt-g Alt-p Alt-l`  
You can select your branches and pull from remote.  

![image](https://user-images.githubusercontent.com/42331656/101117533-82727e80-362a-11eb-9ce1-dd2c8ea2c1f0.png)

### ✨Git Help Widget✨
⌨ Key map: `Alt-g Alt-h`  
Show help.

## Contributers! 
- [ShotaroKataoka](https://github.com/ShotaroKataoka) (Maintainer!)
- [yamamoto-yuta](https://github.com/yamamoto-yuta) (Contributer!)


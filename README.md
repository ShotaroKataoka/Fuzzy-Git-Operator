# Fuzzy Git Operator
🎉🎉An interactive Git Operator on Terminal🎉🎉

## Install
```
git clone git@github.com:ShotaroKataoka/fzf-gitmoji-selector.git ~/.fgo
source ~/.fgo/install.zsh
```

## Usage
### Widget list
- `Alt-g Alt-e`: Git Emoji Selector
- `Alt-g Alt-s`: Git Status Widget
- `Alt-g Alt-d`: Git Diff Widget
- `Alt-g Alt-l`: Git Log Selector
- `Alt-g Alt-a`: Git Add Selector
- `Alt-g Alt-c`: Git Commit Widget
- `Alt-g Alt-p Alt-s`: Git Push Selector
- `Alt-g Alt-p Alt-l`: Git Pull Selector

### ✨Git Emoji Selector✨
⌨ Key map: `Alt-g Alt-e`  
You can select emoji for your joyful commit message!  

![image](https://user-images.githubusercontent.com/42331656/101112422-96b17e00-3620-11eb-9ceb-1168356f63b2.png)

Customize:  
⚙️ customize global emoji list: edit `~/.fgo/user/git_emoji_list.txt`  
⚙️ customize local emoji list each git-repository: create `.fgo_emoji_list.txt` to the top dir of the git-repository.  

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

### ✨Git Add Selector✨
⌨ Key map: `Alt-g Alt-`  
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

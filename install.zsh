if [ ! -f ~/.fgo/user/git_emoji_list.txt ];then
  cp ~/.fgo/data/git_emoji_list.txt ~/.fgo/user/
fi
if [ ! -f ~/.fgo/user/color_scheme.zsh ]; then
  cp ~/.fgo/data/color_scheme.zsh ~/.fgo/user/
fi
if [ ! -f ~/.fgo/user/fgo_keybindings.zsh ]; then
  cp ~/.fgo/data/fgo_keybindings.zsh ~/.fgo/user/
fi

if [ ! -n "$(cat ~/.zshrc | grep 'source ~/.fgo/fgo.zsh')" ]; then
  echo "# Fuzzy-Git-Operator" >> ~/.zshrc
  echo "source ~/.fgo/fgo.zsh" >> ~/.zshrc
fi
source ~/.fgo/fgo.zsh

# install fzf
if [ "$(which fzf)" = "fzf not found" ]; then
  echo "start install fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
else
  echo "fzf already installed"
fi

# install bat
if [ "$(which batcat)" = "batcat not found" ]; then
  echo "start install bat"
  sudo apt install bat
else
  echo "bat already installed"
fi


echo "Install complete."


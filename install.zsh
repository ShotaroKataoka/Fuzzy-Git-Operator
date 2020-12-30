cp ~/.fgo/data/git_emoji_list.txt ~/.fgo/user/
cp ~/.fgo/data/color_scheme.zsh ~/.fgo/user/
cp ~/.fgo/data/fgo_keybindings.zsh ~/.fgo/user/
echo "source ~/.fgo/fuzzy_git_operator.zsh" >> ~/.zshrc
echo "source ~/.fgo/fuzzy_github_operator.zsh" >> ~/.zshrc
echo "source ~/.fgo/user/fgo_keybindings.zsh" >> ~/.zshrc
source ~/.fgo/fuzzy_git_operator.zsh
source ~/.fgo/fuzzy_github_operator.zsh
source ~/.fgo/user/fgo_keybindings.zsh

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

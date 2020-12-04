cp ~/.fgo/data/git_emoji_list.txt ~/.fgo/user/
echo "source ~/.fgo/fuzzy_git_operator.zsh" >> ~/.zshrc
source ~/.fgo/fuzzy_git_operator.zsh

# install fzf
if [ "$(which fzf)" = "fzf not found" ]; then
  echo "fzf already installed"
else
  echo "start install fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# install bat
if [ "$(which batcat)" = "batcat not found" ]; then
  echo "bat already installed"
else
  echo "start install bat"
  apt install bat
fi


echo "Install complete."

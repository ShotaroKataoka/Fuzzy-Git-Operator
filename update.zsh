local _ANSI_COLOR_ERROR="\\033[31;1m"
local _ANSI_COLOR_SUCCESS="\\033[32m"
local _ANSI_COLOR_WARN="\\033[33;1m"
local _ANSI_COLOR_ACCENT="\\033[36;1m"
local _ANSI_COLOR_END="\\033[0m"

echo "- Start update$_ANSI_COLOR_ACCENT Fuzzy-Git-Operator$_ANSI_COLOR_END!"
if [ ! -f ~/.fgo/user/git_emoji_list.txt ]; then
  cp ~/.fgo/data/git_emoji_list.txt ~/.fgo/user/
  if [ $(echo $?) -eq 0 ]; then
    echo "  -$_ANSI_COLOR_SUCCESS Done:$_ANSI_COLOR_END 'cp ~/.fgo/data/git_emoji_list.txt ~/.fgo/user/'"
  else
    echo "  -$_ANSI_COLOR_ERROR Failed:$_ANSI_COLOR_END 'cp ~/.fgo/data/git_emoji_list.txt ~/.fgo/user/'"
  fi
else
  echo "  -$_ANSI_COLOR_SUCCESS Already exists$_ANSI_COLOR_END '~/.fgo/user/git_emoji_list.txt'"
fi

if [ ! -f ~/.fgo/user/color_scheme.zsh ]; then
  cp ~/.fgo/data/color_scheme.zsh ~/.fgo/user/
  if [ $(echo $?) -eq 0 ]; then
    echo "  -$_ANSI_COLOR_SUCCESS Done:$_ANSI_COLOR_END 'cp ~/.fgo/data/color_scheme.zsh ~/.fgo/user/'"
  else
    echo "  -$_ANSI_COLOR_ERROR Failed:$_ANSI_COLOR_END 'cp ~/.fgo/data/git_emoji_list.txt ~/.fgo/user/'"
  fi
else
  echo "  -$_ANSI_COLOR_SUCCESS Already exists$_ANSI_COLOR_END '~/.fgo/user/color_scheme.zsh'"
fi

if [ ! -f ~/.fgo/user/fgo_keybindings.zsh ]; then
  cp ~/.fgo/data/fgo_keybindings.zsh ~/.fgo/user/
  if [ $(echo $?) -eq 0 ]; then
    echo "  -$_ANSI_COLOR_SUCCESS Done:$_ANSI_COLOR_END 'cp ~/.fgo/data/fgo_keybindings.zsh ~/.fgo/user/'"
  else
    echo "  -$_ANSI_COLOR_ERROR Failed:$_ANSI_COLOR_END 'cp ~/.fgo/data/git_emoji_list.txt ~/.fgo/user/'"
  fi
else
  echo "  -$_ANSI_COLOR_SUCCESS Already exists$_ANSI_COLOR_END '~/.fgo/user/fgo_keybindings.zsh'"
fi
source ~/.fgo/fgo.zsh

echo
echo "$_ANSI_COLOR_SUCCESS Update complete.$_ANSI_COLOR_END"
echo " If you want to update above files, try $_ANSI_COLOR_WARN'cp ~/.fgo/data/<file> ~/.fgo/user/'$_ANSI_COLOR_END."


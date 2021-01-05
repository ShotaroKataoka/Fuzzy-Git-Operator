function fgo() {
  local _ANSI_COLOR_RED="\\033[31;1m"
  local _ANSI_COLOR_GREEN="\\033[32m"
  local _ANSI_COLOR_YELLOW="\\033[33m"
  local _ANSI_COLOR_GRAY="\\033[38;05;245m"
  local _ANSI_COLOR_END="\\033[0m"

  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local _git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ "$1" = "init" ]; then
      if [ "$2" = "emoji" ]; then
        cp $HOME/.fgo/user/git_emoji_list.txt "$_git_dir/.fgo_emoji_list.txt"
        echo "$_ANSI_COLOR_GREEN Success:$_ANSI_COLOR_END create $_git_dir/.fgo_emoji_list.txt"
      else;
        echo "$_ANSI_COLOR_RED Error:$_ANSI_COLOR_END invalid keyword"
      fi
    elif [ "$1" = "edit" ]; then
      if [ "$2" = "emoji" ]; then
        if [ -f "$_git_dir/.fgo_emoji_list.txt" ]; then
          vim $_git_dir/.fgo_emoji_list.txt
        else;
          echo "$_ANSI_COLOR_RED Faild:$_ANSI_COLOR_END Not found .fgo_emoji_list.txt"
          echo "$_ANSI_COLOR_YELLOW hint:$_ANSI_COLOR_END exec 'fgo init emoji' first."
        fi
      else;
        echo "$_ANSI_COLOR_RED Error:$_ANSI_COLOR_END invalid keyword"
      fi
    else;
      echo "$_ANSI_COLOR_RED Error:$_ANSI_COLOR_END invalid keyword"
    fi
  else
    echo "Not a git repository."
  fi

}

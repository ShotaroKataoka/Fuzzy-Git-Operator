# Github help
function _fgo_help_github_widget() {
  ## Color Scheme
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  ## GENERAL KEYBIND
  local GENERAL_KEYBIND_BH=$(cat ~/.fgo/data/fzf_general_bindings.txt | sed 's/%widget%/blackhall/g' | tr '\n' ',' | sed 's/,$//')

  batcat ~/.fgo/data/help_github.md --number --color=always | fzf --layout=reverse --border --cycle --info='inline' --height=50% --no-sort --ansi +m --header "Github help" --bind="$GENERAL_KEYBIND_BH" --color="$_FGO_COLOR_SCHEME"
  echo 
  echo 
  zle reset-prompt
}


# Github issue
function _fgo_gitissue_selector() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  ## Color Scheme
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  ## General Keybind
  local GENERAL_KEYBIND_IS=$(cat ~/.fgo/data/fzf_general_bindings.txt | sed 's/%widget%/issue_selector/g' | tr '\n' ',' | sed 's/,$//')
  local GENERAL_KEYBIND_BH=$(cat ~/.fgo/data/fzf_general_bindings.txt | sed 's/%widget%/blackhall/g' | tr '\n' ',' | sed 's/,$//')

  ## Initialize status
  echo 0 >| ~/.fgo/data/.status/.issue_selector/.end.status
  echo 0 >| ~/.fgo/data/.status/.issue_selector/.state.status
  echo 0 >| ~/.fgo/data/.status/.issue_selector/.put_num.status
  echo 0 >| ~/.fgo/data/.status/.issue_selector/.create_comment.status
  echo 0 >| ~/.fgo/data/.status/.issue_selector/.help.status
  if [ -n "$_is_git_dir" ]; then
    while :
    do
      
      local _fet_status_state=$(( $(cat ~/.fgo/data/.status/.issue_selector/.state.status | wc -l) % 2 ))
      _infobar="?:Help  Alt-n:Number  Alt-i:Info  ctrl-j/k:Info Down/Up  Alt-t:Open/Closed  Alt-r:Comment  Alt-o:Reopen  Alt-p:Close  Alt-w:Web"
      if [ $_fet_status_state -eq 1 ]; then
        _state_var='open'
        _prompt='Open Issues >> '
      elif [ $_fet_status_state -eq 0 ]; then
        _state_var='closed'
        _prompt='Closed Issues >> '
      fi

      local lbuf=$LBUFFER
      local tail=$RBUFFER
      local issue_list=$(gh issue list --state "$_state_var" --limit 10000)
      issue_list=$(echo "$issue_list" | sed -r 's/([0-9]+)\t+OPEN/\\033[32m\#\1\\033[0m/g')
      issue_list=$(echo "$issue_list" | sed -r 's/([0-9]+)\t+CLOSED/\\033[31m\#\1\\033[0m/g')

      issue_list=$(echo "$issue_list" | sed -r 's/\t([^\t]*)/\\033[36m\t\1\\033[0m/2')
      issue_list=$(echo "$issue_list" | sed -r 's/\t([0-9\-]*) ?[0-9\:]* ?[0-9\+]* ?[a-zA-Z]*/\\033[30;1m\t\1\\033[0m/3')

      issue_list=$(echo "$issue_list" | column -t -s $'\t')
      local issue_id=$(echo "$issue_list" | fzf --layout=reverse --prompt "$_prompt" --border --cycle --header="$_infobar" --info='inline' --height=50% --ansi +m --preview="echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'echo {a} | ~/.fgo/src/bin/github_issue_selector_preview'" --bind="$GENERAL_KEYBIND_IS,alt-n:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_selector/.end.status)+execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_selector/.put_num.status)+accept,alt-r:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_selector/.create_comment.status)+accept,alt-w:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue view {a} -w')+abort,alt-o:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue reopen {a}')+abort,alt-p:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue close {a}')+abort,alt-t:execute-silent(echo 0 >> ~/.fgo/data/.status/.issue_selector/.state.status)+abort" --preview-window=:hidden --color="$_FGO_COLOR_SCHEME")
  local GENERAL_KEYBIND_IS=$(cat ~/.fgo/data/fzf_general_bindings.txt | sed 's/%widget%/issue_selector/g' | tr '\n' ',' | sed 's/,$//')
      local _loopend=$(cat ~/.fgo/data/.status/.issue_selector/.end.status)
      local _put_num=$(cat ~/.fgo/data/.status/.issue_selector/.put_num.status)
      local _create_comment=$(cat ~/.fgo/data/.status/.issue_selector/.create_comment.status)
      local _help=$(cat ~/.fgo/data/.status/.issue_selector/.help.status)
      echo
      if [ -n "$issue_id" ]; then
        if [ $_put_num -eq 1 ]; then
          issue_id=$(echo "$issue_id" | cut -d ' ' -f 1)
          LBUFFER="$lbuf$issue_id"
          RBUFFER="$tail"
          echo 0 >| ~/.fgo/data/.status/.issue_selector/.put_num.status
        elif [ $_create_comment -eq 1 ]; then
          issue_id=$(echo "$issue_id" | cut -d ' ' -f 1 | cut -d '#' -f 2)
          $HOME/.fgo/src/bin/github_issue_selector_create_comment "$issue_id"
          echo 0 >| ~/.fgo/data/.status/.issue_selector/.create_comment.status
        elif [ $_help -eq 1 ]; then
          batcat $HOME/.fgo/data/help_gh_issue_selector.md --color=always --style numbers | fzf +m --ansi --bind "$GENERAL_KEYBIND_BH" --color="$_FGO_COLOR_SCHEME" --cycle
          echo 0 >| ~/.fgo/data/.status/.issue_selector/.help.status
        else;
          issue_id=$(echo "$issue_id" | cut -d ' ' -f 1 | cut -d '#' -f 2)
          $HOME/.fgo/src/bin/github_issue_selector_preview "$issue_id" | less
        fi
      fi
      if [ $_loopend -eq 1 ]; then
        break
      fi
    done
  else
    echo "not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

#Open Github in browser
function _fgo_github_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    gh repo view -w
  fi
  zle reset-prompt
}

# Github create issue
function _fgo_github_create_issue_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local REPLY
    autoload -Uz read-from-minibuffer
    read-from-minibuffer 'Issue title: ' 
    local _issue_title=$REPLY
    echo
    read-from-minibuffer 'Body (or e: Edit with vim): '
    local _issue_body=$REPLY
    echo
    if [ "$_issue_body" = "e" ]; then
      local _templates="\\033[31m"'without Template'"\\033[0m"
      if [ -f "$HOME/.fgo/data/buf.md" ]; then
        _templates="\\033[32m"'Left off last time'"\\033[0m\n$_templates"
      fi
      if [ -d "$HOME/.fgo/.github/ISSUE_TEMPLATE" ]; then 
        _templates="$_templates\n"$(ls $HOME/.fgo/.github/ISSUE_TEMPLATE)
      fi
      local _body_interrupt=0
      if [ ! "$_templates" = "\\033[31m"'without Template'"\\033[0m" ]; then
        ## Color Scheme
        if [ -f ~/.fgo/user/color_scheme.zsh ]; then
          local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
        else
          local _FGO_COLOR_SCHEME="dark"
        fi
        ## GENERAL KEYBIND
        local GENERAL_KEYBIND_BH=$(cat ~/.fgo/data/fzf_general_bindings.txt | sed 's/%widget%/blackhall/g' | tr '\n' ',' | sed 's/,$//')
        local selected_temp=$(echo "$_templates" | fzf +m --cycle --ansi --height=70% --prompt "Select Template >> " --bind "$GENERAL_KEYBIND_BH" --preview "echo {} | xargs -rI{a} sh -c 'if [ \"{a}\" = \"without Template\" ]; then echo \"/dev/null\"; elif [ \"{a}\" = \"Left off last time\" ]; then echo \"$HOME/.fgo/data/buf.md\"; else echo $HOME/.fgo/.github/ISSUE_TEMPLATE/{a}; fi | xargs batcat -l markdown --color=always --style=numbers'", --color="$_FGO_COLOR_SCHEME")
        if [ -n "$selected_temp" ]; then
          if [ "$selected_temp" = "without Template" ]; then
            echo "<!-- Title: $_issue_title -->" >| ~/.fgo/data/buf.md
            echo >> ~/.fgo/data/buf.md
          elif [ "$selected_temp" = "Left off last time" ]; then
            :
          else
            _template=$(cat $HOME/.fgo/.github/ISSUE_TEMPLATE/$selected_temp)
            local _template_start_num=$(expr $(echo "$_template" | grep -n -m2 '^---' | tail -n1 | cut -f1 -d:) + 1)
            _template=$(echo "$_template" | sed -n $_template_start_num',$p')
            echo "<!-- Title: $_issue_title -->" >| ~/.fgo/data/buf.md
            echo "$_template" >> ~/.fgo/data/buf.md
          fi
        else
          _body_interrupt=1
        fi
      else
        echo "<!-- Title: $_issue_title -->" >| ~/.fgo/data/buf.md
        echo >> ~/.fgo/data/buf.md
      fi
      if [ ! $_body_interrupt -eq 1 ]; then
        echo "$HOME/.fgo/data/buf.md +2" | xargs -o vim
        _issue_body=$(cat ~/.fgo/data/buf.md)
      else
        _issue_body=''
      fi
    fi
    read-from-minibuffer 'Label: '
    local _issue_label=$REPLY
    echo
    read-from-minibuffer "Send Issue? : '"$_issue_title"' (y/n): "
    echo
    if [ "$REPLY" = "y" ]; then
      gh issue create --title "$_issue_title" --body "$_issue_body" --label "$_issue_label"
      local _status=$?
      if [ ! $_status = 0 ]; then
        echo "Faild: Could not send a issue."
      else
        if [ -f "$HOME/.fgo/data/buf.md" ]; then
          rm -f ~/.fgo/data/buf.md
        fi
        echo "Success: Send a issue."
      fi
    else
      echo "Did not send a issue."
    fi
    sleep 0.1s
    echo
    echo
    echo
  else
    echo "not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

zle -N _fgo_gitissue_selector
zle -N _fgo_github_widget
zle -N _fgo_help_github_widget
zle -N _fgo_github_create_issue_widget

# Github help
function _fgo_help_github_widget() {
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _fgo_color_scheme=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _fgo_color_scheme="dark"
  fi
  batcat ~/.fgo/data/help_github.md --number --color=always | fzf --layout=reverse --border --cycle --info='inline' --height=50% --no-sort --ansi +m --header "Github help" --bind="alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,left:abort,right:accept,alt-c:abort,ctrl-h:abort,ctrl-l:accept" --color="$_fgo_color_scheme"
  echo 
  echo 
  zle reset-prompt
}


# Github issue
function _fgo_gitissue_selector() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _fgo_color_scheme=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _fgo_color_scheme="dark"
  fi
  echo 0 >| ~/.fgo/data/.status/.issue_end.status
  echo 0 >| ~/.fgo/data/.status/.issue_state.status
  echo 0 >| ~/.fgo/data/.status/.issue_put_num.status
  echo 0 >| ~/.fgo/data/.status/.issue_view_issue.status
  echo 0 >| ~/.fgo/data/.status/.issue_help.status
  if [ -n "$_is_git_dir" ]; then
    while :
    do
      
      local _fet_status_state=$(( $(cat ~/.fgo/data/.status/.issue_state.status | wc -l) % 2 ))
      _infobar="?:Help  Alt-n:Put number  Alt-i:Info  ctrl-j/k:Info Down/Up  Alt-t:Open/Closed  Alt-o:Reopen  Alt-p:Close  Alt-w:Web"
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

      # issue_list=$(echo "$issue_list" | sed -r 's/([0-9]+)\t/\\033[31m\#\1\\033[0m/g')
      issue_list=$(echo "$issue_list" | column -t -s $'\t')
      local issue_id=$(echo "$issue_list" | fzf --layout=reverse --prompt "$_prompt" --border --cycle --header="$_infobar" --info='inline' --height=50% --ansi +m --preview="echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'echo {a} | ~/.fgo/src/bin/github_issue_selector_preview'" --bind="alt-h:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,alt-j:down,alt-k:up,alt-l:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_view_issue.status)+accept,left:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,right:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_view_issue.status)+accept,ctrl-c:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,alt-c:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,ctrl-h:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,ctrl-l:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_view_issue.status)+accept,enter:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_view_issue.status)+accept,alt-n:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_put_num.status)+accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-w:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue view {a} -w')+abort,alt-o:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue reopen {a}')+abort,alt-p:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue close {a}')+abort,alt-t:execute-silent(echo 0 >> ~/.fgo/data/.status/.issue_state.status)+abort,alt-i:toggle-preview,?:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_help.status)+abort" --preview-window=:hidden --color="$_fgo_color_scheme")
      local _loopend=$(cat ~/.fgo/data/.status/.issue_end.status)
      local _put_num=$(cat ~/.fgo/data/.status/.issue_put_num.status)
      local _view_issue=$(cat ~/.fgo/data/.status/.issue_view_issue.status)
      local _help=$(cat ~/.fgo/data/.status/.issue_help.status)
      echo
      if [ $_put_num -eq 1 ]; then
        issue_id=$(echo "$issue_id" | cut -d ' ' -f 1)
        LBUFFER="$lbuf$issue_id"
        RBUFFER="$tail"
        echo 0 >| ~/.fgo/data/.status/.issue_put_num.status
      elif [ $_view_issue -eq 1 ]; then
        issue_id=$(echo "$issue_id" | cut -d ' ' -f 1 | cut -d '#' -f 2)
        $HOME/.fgo/src/bin/github_issue_selector_preview "$issue_id" | less
        echo 0 >| ~/.fgo/data/.status/.issue_view_issue.status
      elif [ $_help -eq 1 ]; then
        batcat $HOME/.fgo/data/help_gh_issue_selector.md --color=always --style numbers | fzf -m --ansi
        echo 0 >| ~/.fgo/data/.status/.issue_help.status
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
        local selected_temp=$(echo "$_templates" | fzf +m --cycle --ansi --height=70% --prompt "Select Template >> " --bind 'alt-j:down,alt-k:up,alt-h:abort,alt-l:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview,left:abort,right:accept' --preview "echo {} | xargs -rI{a} sh -c 'if [ \"{a}\" = \"without Template\" ]; then echo \"/dev/null\"; elif [ \"{a}\" = \"Left off last time\" ]; then echo \"$HOME/.fgo/data/buf.md\"; else echo $HOME/.fgo/.github/ISSUE_TEMPLATE/{a}; fi | xargs batcat -l markdown --color=always --style=numbers'")
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

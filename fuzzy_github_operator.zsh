# Github help
function _fgo_help_github_widget() {
  batcat ~/.fgo/data/help_github.md --number --color=always | fzf --layout=reverse --border --cycle --info='inline' --height=50% --no-sort --ansi +m --header "Github help" --bind="alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,left:abort,right:accept,alt-c:abort,ctrl-h:abort,ctrl-l:accept"
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
  if [ -n "$_is_git_dir" ]; then
    while :
    do
      
      local _fet_status_state=$(( $(cat ~/.fgo/data/.status/.issue_state.status | wc -l) % 2 ))
      _infobar="Alt-i:View Issue  Alt-o:Reopen Issue  Alt-p:Close Issue  Alt-t:Toggle Open/Closed  Alt-w:Web Browse"
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
      local issue_id=$(echo "$issue_list" | fzf --layout=reverse --prompt "$_prompt" --border --cycle --header="$_infobar" --info='inline' --height=50% --ansi +m --preview="echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue view {a}'" --bind="alt-h:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,alt-j:down,alt-k:up,alt-l:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+accept,left:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,right:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+accept,ctrl-c:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,alt-c:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,ctrl-h:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+abort,ctrl-l:execute-silent(echo 1 >| ~/.fgo/data/.status/.issue_end.status)+accept,alt-w:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue view {a} -w')+abort,alt-o:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue reopen {a}')+abort,alt-p:execute-silent(echo {} | cut -f 1 -d ' ' | sed -r \"s/#([0-9]*)/\1/\" | xargs -rI{a} sh -c 'gh issue close {a}')+abort,alt-t:execute-silent(echo 0 >> ~/.fgo/data/.status/.issue_state.status)+abort,alt-i:toggle-preview" --preview-window=:hidden --color="$_fgo_color_scheme")
      
      local _loopend=$(cat ~/.fgo/data/.status/.issue_end.status)
      issue_id=$(echo "$issue_id" | cut -d ' ' -f 1)
      LBUFFER="$lbuf$issue_id"
      RBUFFER="$tail"
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

zle -N _fgo_gitissue_selector
zle -N _fgo_github_widget
zle -N _fgo_help_github_widget

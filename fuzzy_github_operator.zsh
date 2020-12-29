# Github issue
function _fgo_gitissue_selector() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local lbuf=$LBUFFER
    local tail=$RBUFFER
    local issue_list=$(gh issue list --state all --limit 10000)
    issue_list=$(echo "$issue_list" | sed -r 's/([0-9]+)\t+OPEN/\\033[32m\#\1\\033[0m/g')
    issue_list=$(echo "$issue_list" | sed -r 's/([0-9]+)\t+CLOSED/\\033[31m\#\1\\033[0m/g')

    # issue_list=$(echo "$issue_list" | sed -r 's/([0-9]+)\t/\\033[31m\#\1\\033[0m/g')

    local issue_id=$(echo "$issue_list" | fzf --ansi)
    issue_id=$(echo "$issue_id" | cut -f 1)
    LBUFFER="$lbuf$issue_id"
    RBUFFER="$tail"
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

zle     -N   _fgo_gitissue_selector
bindkey '\eg\eh\ei' _fgo_gitissue_selector
zle     -N   _fgo_github_widget
bindkey '\eg\eh\ew' _fgo_github_widget

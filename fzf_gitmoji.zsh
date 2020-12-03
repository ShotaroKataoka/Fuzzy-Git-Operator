# Git emoji selector
function _fzf_gitmoji_widget() {
  local lbuf=$LBUFFER
  local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
  local _git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ -f "$_git_dir/.git_emoji_list.txt" ]; then
    local _gitmoji=$(echo $(cat $_git_dir/.git_emoji_list.txt) | sed '/^$/d')
  else
    local _gitmoji=$(echo $(cat ~/.fzf-gitmoji-selector/git_emoji_list.txt) | sed '/^$/d')
  fi
  _gitmoji=$(echo $_gitmoji | sed 's/ - / \\033[33m- /' | sed -e 's/$/\\033[0m/')
  local selected_moji=''
  selected_moji=$(echo $_gitmoji | fzf +m --ansi --cycle --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept')
  selected_moji=$(echo $selected_moji | cut -f 2 -d ' ')
  LBUFFER="$lbuf""$selected_moji""$tail"
  zle reset-prompt
}

# Git status
function _fzf_gitstatus_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    git status
    echo 
    echo 
  else
    echo "Not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

# Git add
function _fzf_gitadd_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    while :
    do
      local git_status=$(git status --short)
      git_status=$(echo $git_status | sed 's/^ M/\\033[31m M\\033[0m/g' | sed 's/^ D/\\033[31m D\\033[0m/g' | sed 's/^??/\\033[31m??\\033[0m/g')
      git_status=$(echo $git_status | sed 's/^M /\\033[32mM \\033[0m/g'| sed 's/^D /\\033[32mD \\033[0m/g' | sed 's/^A /\\033[32mA \\033[0m/g')
      git_status=$(echo $git_status | sed 's/^MM/\\033[32mM\\033[0m\\033[31mM\\033[0m/g')
      local git_selected=$(echo $git_status | fzf --ansi --cycle --bind="alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,left:abort,right:accept,alt-c:abort,ctrl-h:abort,ctrl-j:preview-down,ctrl-k:preview-up,ctrl-l:accept,alt-i:toggle-preview,ctrl-i:toggle-preview" --preview="echo {} | rev | cut -f 1 -d ' ' | rev | xargs -rI{a} sh -c 'if [ -f \"{a}\" ]; then batcat {a} --color=always; else lsi {a}; fi'" --prompt="Add/Reset Files >> ")
      if [ -n "$git_selected" ]; then
        if [ -n "$(echo "$git_selected" | grep -e "^ M" -e "^ D" -e "^MM" -e "^??")" ]; then
          git add $(echo "$git_selected" | rev | cut -f 1 -d ' ' | rev) >> /dev/null
        fi
        if [ -n "$(echo "$git_selected" | grep -e "^M " -e "^D " -e "^A ")" ]; then
          git reset HEAD $(echo "$git_selected" | rev | cut -f 1 -d ' ' | rev) >> /dev/null
        fi
      else
        break
      fi
    done
  else
    echo "Not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

# Git commit 
function _fzf_gitcommit_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local lbuf=$LBUFFER
    local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
    LBUFFER="git commit -m \"""$lbuf$tail"
    RBUFFER=\"
  else
    echo "not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

# Git log selector
function _fzf_gitlog_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local _git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ -f "$_git_dir/.git_emoji_list.txt" ]; then
      local _gitmoji=$(echo $(cat $_git_dir/.git_emoji_list.txt) | sed '/^$/d')
    else
      local _gitmoji=$(echo $(cat ~/.fzf-gitmoji-selector/git_emoji_list.txt) | sed '/^$/d')
    fi
    local _gitmoji_emoji=($(echo $_gitmoji | cut -f 2 -d ' '))
    local _gitmoji_text=($(echo $_gitmoji | cut -f 3 -d ' '))
    local _gitlog=$(git log --oneline)
    for i in $(seq 1 ${#_gitmoji_text[@]}); do
      local text=${_gitmoji_text[$i]}
      local emoji=${_gitmoji_emoji[$i]}
      _gitlog=$(echo $_gitlog | sed -e "s/$text/$emoji/g")
    done
    _gitlog=$(echo $_gitlog | sed -e 's/^/\\033[33m/g')
    _gitlog=$(echo $_gitlog | sed -e 's/ /\\033[0m /')
    _gitlog=$(echo $_gitlog | sed -e 's/Merge pull request/\\033[35m\\uf126\\033[0m Merge pull request/')
    echo
    local selected_commit=$(echo -e $_gitlog | fzf +m --height=70% --no-sort --ansi --cycle --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview' --preview="echo {} | cut -f 1 -d ' ' | xargs -rI{a} sh -c 'git diff {a}^..{a} --color=always'")
    selected_commit=$(echo $selected_commit | cut -f 1 -d ' ')
    local lbuf=$LBUFFER
    local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
    LBUFFER="$lbuf""$selected_commit""$tail"
  else
    echo "Not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

# Git Branch Selector
function _fzf_gitbranch_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local git_branchs=$(git branch)
    selected_branch=$(echo $git_branchs | sed -e '/\*/d' | cut -d " " -f 3 | fzf --cycle +m --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview' --preview "git show --color=always {}")
    if [ -n "$selected_branch" ]; then
      git switch "$selected_branch"
      echo 
      echo 
    fi
  else
    echo "not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
  zle accept-line
}

# Git Pull Selector
function _fzf_gitpull_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local git_branchs=$(git branch)
    selected_branch=$(echo $git_branchs | sed 's/\*/ /' | cut -d " " -f 3 | fzf --cycle +m --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview' --preview "git show --color=always {}")
    if [ -n "$selected_branch" ]; then
      git pull origin "$selected_branch"
      echo 
      echo 
    fi
  else
    echo "not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

# Git Push Selector
function _fzf_gitpush_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local git_branchs=$(git branch)
    selected_branch=$(echo $git_branchs | sed 's/\*/ /' | cut -d " " -f 3 | fzf --cycle +m --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview' --preview "git show --color=always {}")
    if [ -n "$selected_branch" ]; then
      git push origin "$selected_branch"
      echo 
      echo 
    fi
  else
    echo "not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

zle     -N   _fzf_gitmoji_widget
bindkey '\eg\ee' _fzf_gitmoji_widget
zle     -N   _fzf_gitstatus_widget
bindkey '\eg\es' _fzf_gitstatus_widget
zle     -N   _fzf_gitadd_widget
bindkey '\eg\ea' _fzf_gitadd_widget
zle     -N   _fzf_gitcommit_widget
bindkey '\eg\ec' _fzf_gitcommit_widget
zle     -N   _fzf_gitlog_widget
bindkey '\eg\el' _fzf_gitlog_widget
zle     -N   _fzf_gitbranch_widget
bindkey '\eg\eb' _fzf_gitbranch_widget
zle     -N   _fzf_gitpull_widget
bindkey '\eg\ep\el' _fzf_gitpull_widget
zle     -N   _fzf_gitpush_widget
bindkey '\eg\ep\es' _fzf_gitpush_widget

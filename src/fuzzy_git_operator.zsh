# Git emoji selector
function _fgo_gitemoji_widget() {
  local lbuf=$LBUFFER
  local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
  ## COLOR SCHEME
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  ## GENERAL KEYBIND
  local GENERAL_KEYBIND_BH=$(cat ~/.fgo/data/fzf_general_bindings.txt | sed 's/%widget%/blackhall/g' | tr '\n' ',' | sed 's/,$//')
  ## Random decoration
  local emoji_list=$(cat ~/.fgo/data/decorations.txt)
  local rand=$((($RANDOM % ${#emoji_list[@]}) + 1))
  local rand_emoji=${emoji_list[$rand]}
  ## Load Emoji list
  local _git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ -f "$_git_dir/.fgo_emoji_list.txt" ]; then
    local _gitemoji=$(cat $_git_dir/.fgo_emoji_list.txt)
  else
    local _gitemoji=$(cat ~/.fgo/user/git_emoji_list.txt)
  fi
  _gitemoji=$(echo $_gitemoji | sed '/^$/d' | sed 's/ - / \\033[33m- /' | sed -e 's/$/\\033[0m/')
  ## FZF
  local selected_moji=$(echo $_gitemoji | fzf +m --ansi --cycle --info='inline' --layout=reverse --border --prompt="$rand_emoji Git Emoji $rand_emoji >> " --height=35% --bind="$GENERAL_KEYBIND_BH" --color="$_FGO_COLOR_SCHEME")
  selected_moji=$(echo $selected_moji | cut -f 1 -d ' ')
  LBUFFER="$lbuf""$selected_moji""$tail"
  zle reset-prompt
}

# Git help
function _fgo_help_widget() {
  ## COLOR SCHEME
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  ## GENERAL KEYBIND
  local GENERAL_KEYBIND_BH=$(cat ~/.fgo/data/fzf_general_bindings.txt | sed 's/%widget%/blackhall/g' | tr '\n' ',' | sed 's/,$//')
  ## FZF
  batcat ~/.fgo/data/help.md --number --color=always | fzf --layout=reverse --border --cycle --info='inline' --height=50% --no-sort --ansi +m --header "Git help" --bind="$GENERAL_KEYBIND_BH" --color="$_FGO_COLOR_SCHEME"
  echo 
  echo 
  zle reset-prompt
}

# Git status
function _fgo_gitstatus_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local git_status=$(git -c color.status=always status)
    echo "\\033[33m=== Git Status ===\\033[0m\\n$git_status" | less
    echo 
    echo 
  else
    echo "Not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

# Git Diff Widget
function _fgo_gitdiff_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local git_diff_staged=$(git diff --cached --color=always)
    local git_diff_unstaged=$(git diff --color=always)
    echo "\\033[33m=== Git Diff Staged ===\\033[0m \\n$git_diff_staged\\n\\n\\033[33m=== Git Diff Unstaged ===\\033[0m \\n$git_diff_unstaged" | less
    echo
    echo 
  else
    echo "Not a git repository."
    echo 
    echo 
  fi
  zle reset-prompt
}

# Git Add Selector
function _fgo_gitadd_widget() {
  ## COLOR SCHEME
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  ## GENERAL KEYBIND
  local GENERAL_KEYBIND_BH=$(cat ~/.fgo/data/fzf_general_bindings.txt | sed 's/%widget%/blackhall/g' | tr '\n' ',' | sed 's/,$//')
  ## LOOP
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    while :
    do
      local git_status=$(git status --short | tac)
      git_status=$(echo $git_status | sed 's/^ M/\\033[31m M\\033[0m/g' | sed 's/^ D/\\033[31m D\\033[0m/g' | sed 's/^??/\\033[31m??\\033[0m/g' | sed 's/^AM/\\033[31mAM\\033[0m/g')
      git_status=$(echo $git_status | sed 's/^M /\\033[32mM \\033[0m/g'| sed 's/^D /\\033[32mD \\033[0m/g' | sed 's/^A /\\033[32mA \\033[0m/g')
      git_status=$(echo $git_status | sed 's/^MM/\\033[32mM\\033[0m\\033[31mM\\033[0m/g')
      IFS=$'\n'
      local git_selected_list=($(echo $git_status | fzf --ansi --cycle --info='inline' -m --layout=reverse --border --bind="$GENERAL_KEYBIND_BH" --preview="echo {} | rev | cut -f 1 -d ' ' | rev | xargs -rI{a} sh -c 'if [ -f \"{a}\" ]; then batcat {a} --color=always; else lsi {a}; fi'" --prompt="Add/Reset Files >> " --color="$_FGO_COLOR_SCHEME"))
      if [ -n "$git_selected_list" ]; then
        for i in `seq 1 ${#git_selected_list[@]}`
        do
          git_selected=${git_selected_list[$i]}
          if [ -n "$(echo "$git_selected" | grep -e "^ M" -e "^ D" -e "^MM" -e "^??" -e "^AM")" ]; then
            git add $(echo "$git_selected" | rev | cut -f 1 -d ' ' | rev) >> /dev/null
          fi
          if [ -n "$(echo "$git_selected" | grep -e "^M " -e "^D " -e "^A ")" ]; then
            git reset HEAD $(echo "$git_selected" | rev | cut -f 1 -d ' ' | rev) >> /dev/null
          fi
        done
      else
        break
      fi
    done
  else
    echo "Not a git repository."
    echo 
    echo 
  fi
  IFS=$' \t\n'
  zle reset-prompt
}

# Git commit 
function _fgo_gitcommit_widget() {
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local lbuf=$LBUFFER
    local tail=$RBUFFER  #${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
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
function _fgo_gitlog_widget() {
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local _git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    if [ -f "$_git_dir/.git_emoji_list.txt" ]; then
      local _gitemoji=$(cat $_git_dir/.git_emoji_list.txt)
    else
      local _gitemoji=$(cat ~/.fgo/user/git_emoji_list.txt)
    fi
    local _gitemoji_emoji=($(echo $_gitemoji | sed '/^$/d' | cut -f 1 -d ' '))
    local _gitemoji_text=($(echo $_gitemoji | sed '/^$/d' | cut -f 2 -d ' '))
    local _gitlog=$(git log --oneline)
    for i in $(seq 1 ${#_gitemoji_text[@]}); do
      local text=${_gitemoji_text[$i]}
      local emoji=${_gitemoji_emoji[$i]}
      _gitlog=$(echo $_gitlog | sed -e "s/$text/$emoji/g")
    done
    _gitlog=$(echo $_gitlog | sed -e 's/^/\\033[33m/g')
    _gitlog=$(echo $_gitlog | sed -e 's/ /\\033[0m /')
    _gitlog=$(echo $_gitlog | sed -e 's/Merge pull request/\\033[35m\\uf126\\033[0m Merge pull request/')
    _gitlog=$(echo $_gitlog | sed -e 's/Merge branch/\\033[35m\\uf126\\033[0m Merge branch/')
    _gitlog=$(echo $_gitlog | sed -e 's/Revert/\\033[31m\\uf126\\033[0m Revert/')
    _gitlog=$(echo $_gitlog | sed -r 's/(\#[0-9]+)/\\033[34;1m\\033[4m\1\\033[0m/g')
    echo
    local selected_commit=$(echo -e $_gitlog | fzf +m --info='inline' --layout=reverse --border --prompt='Git Log >> ' --height=70% --no-sort --ansi --cycle --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview' --preview="echo {} | cut -f 1 -d ' ' | xargs -rI{a} sh -c 'git diff {a}^..{a} --color=always'" --color="$_FGO_COLOR_SCHEME")
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
function _fgo_gitbranch_widget() {
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local git_branchs=$(git branch)
    selected_branch=$(echo $git_branchs | sed -e '/\*/d' | cut -d " " -f 3 | fzf --cycle +m --info='inline' --layout=reverse --border --prompt='Git Switch >> ' --height=70% --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview' --preview "git show --color=always {}" --color="$_FGO_COLOR_SCHEME")
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
function _fgo_gitpull_widget() {
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local git_branchs=$(git branch)
    selected_branch=$(echo $git_branchs | sed 's/\*/ /' | cut -d " " -f 3 | fzf --cycle +m --info='inline' --layout=reverse --border --prompt='Git Pull >> ' --height=70% --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview' --preview "git show --color=always {}" --color="$_FGO_COLOR_SCHEME")
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
function _fgo_gitpush_widget() {
  if [ -f ~/.fgo/user/color_scheme.zsh ]; then
    local _FGO_COLOR_SCHEME=$(cat ~/.fgo/user/color_scheme.zsh | sed '/^$/d' | sed '/^\#/d' | tr '\n' ',' | sed 's/,$//')
  else
    local _FGO_COLOR_SCHEME="dark"
  fi
  local _is_git_dir=$(git rev-parse --git-dir 2> /dev/null)
  if [ -n "$_is_git_dir" ]; then
    local git_branchs=$(git branch)
    selected_branch=$(echo $git_branchs | sed 's/\*/ /' | cut -d " " -f 3 | fzf --cycle +m --info='inline' --layout=reverse --border --prompt='Git Push >> ' --height=70% --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept,ctrl-j:preview-down,ctrl-k:preview-up,alt-i:toggle-preview' --preview "git show --color=always {}" --color="$_FGO_COLOR_SCHEME")
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

zle     -N   _fgo_gitemoji_widget
zle     -N   _fgo_help_widget
zle     -N   _fgo_gitdiff_widget
zle     -N   _fgo_gitstatus_widget
zle     -N   _fgo_gitadd_widget
zle     -N   _fgo_gitcommit_widget
zle     -N   _fgo_gitlog_widget
zle     -N   _fgo_gitbranch_widget
zle     -N   _fgo_gitpull_widget
zle     -N   _fgo_gitpush_widget

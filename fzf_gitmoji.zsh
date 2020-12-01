
function _fzf_gitmoji_widget() {
  local lbuf=$LBUFFER
  local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
  local selected_moji=''
  selected_moji=$(echo $(cat ~/.fzf-gitmoji-selector/git_moji_list.txt) | sed '/^$/d' | fzf +m --ansi --cycle --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept')
  selected_moji=$(echo $selected_moji | cut -f 3 -d ' ')
  LBUFFER="$lbuf""$selected_moji""$tail"
  zle reset-prompt
}
function _fzf_gitstatus_widget() {
  git status
  zle reset-prompt
}
function _fzf_gitlog_widget() {
  local _gitmoji=$(echo $(cat ~/.fzf-gitmoji-selector/git_moji_list.txt) | sed '/^$/d')
  local _gitmoji_text=($(echo $_gitmoji | cut -f 3 -d ' '))
  local _gitmoji_emoji=($(echo $_gitmoji | cut -f 2 -d ' '))
  local _gitlog=$(git log --oneline)
  end_length=10
  for i in $(seq 1 $end_length); do
    local text=${_gitmoji_text[$i]}
    local emoji=${_gitmoji_emoji[$i]}
    _gitlog=$(echo $_gitlog | sed -e "s/$text/$emoji/g")
  done
  _gitlog=$(echo $_gitlog | sed -e 's/^/\\033[1;33m/g')
  _gitlog=$(echo $_gitlog | sed -e 's/ /\\033[0m /')
  echo
  local selected_commit=$(echo -e $_gitlog | fzf +m --no-sort --ansi --cycle --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept')
  selected_commit=$(echo $selected_commit | cut -f 1 -d ' ')
  local lbuf=$LBUFFER
  local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
  LBUFFER="$lbuf""$selected_commit""$tail"
  zle reset-prompt
}

zle     -N   _fzf_gitmoji_widget
bindkey '\eg\ec' _fzf_gitmoji_widget
zle     -N   _fzf_gitstatus_widget
bindkey '\eg\es' _fzf_gitstatus_widget
zle     -N   _fzf_gitlog_widget
bindkey '\eg\el' _fzf_gitlog_widget

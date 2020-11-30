
function _fzf_gitmoji_widget() {
  local lbuf=$LBUFFER
  local tail=${LBUFFER:$(( ${#LBUFFER} - ${#trigger} ))}
  local selected_moji=''
  selected_moji=$(echo $(cat ~/1_develop/fzf-gitmoji-selector/git_moji_list.txt) | sed '/^$/d' | fzf +m --ansi --cycle --bind='alt-h:abort,alt-j:down,alt-k:up,alt-l:accept,alt-c:abort,left:abort,right:accept')
  selected_moji=$(echo $selected_moji | cut -f 3 -d ' ')
  LBUFFER="$lbuf""$selected_moji""$tail"
  zle reset-prompt
}
function _fzf_gitstatus_widget() {
  git status
  zle reset-prompt
}
zle     -N   _fzf_gitmoji_widget
bindkey '\eg\ec' _fzf_gitmoji_widget
zle     -N   _fzf_gitstatus_widget
bindkey '\eg\es' _fzf_gitstatus_widget

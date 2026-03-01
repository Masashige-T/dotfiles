# ── Prompt ──
parse_git_branch() {
  git branch 2>/dev/null | sed -n 's/* \(.*\)/ (\1)/p'
}
PS1='\[\033[01;34m\]\W\[\033[01;32m\]$(parse_git_branch)\[\033[00m\] $ '

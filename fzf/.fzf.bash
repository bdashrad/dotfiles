# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/bradclark/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/bradclark/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/bradclark/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/bradclark/.fzf/shell/key-bindings.bash"


# Exit if not interactive
case $- in
	*i*) ;;
	*) return;;
esac


# Just start tmux if we are not already in tmux
if [ -z "$TMUX" ]; then
	if [ -x "$(command -v tmux)" ]; then
		export EDITOR=vi # Tell tmux to use vi-style keys
		# Create a new session attached to the session group of the
		# 'main' session. The 'main' session is ensured to exist by
		# being created in .tmux.conf. Then make sure the session
		# created here is destroyed when the terminal is detached.
		exec tmux new-session -t main \; set-option destroy-unattached
	else
		echo "tmux not available"
	fi
fi


#
# Actual configuration follows
#

# Note: use 'bash -ic "set -ex; source ~/.bashrc"' to debug.


### Internal functions

prepend_if_not_in_path() {
	if [ -d "$2" ]; then
		if [ -z "${!1}" ]; then
			export $1="$2"
		else
			[[ ":${!1}:" == *":$2:"* ]] || export $1="$2:${!1}"
		fi
	fi
	return 0
}

append_if_not_in_path() {
	if [ -d "$2" ]; then
		if [ -z "${!1}" ]; then
			export $1="$2"
		else
			[[ ":${!1}:" == *":$2:"* ]] || export $1="${!1}:$2"
		fi
	fi
	return 0
}

source_if_file() {
	[ -s "$1" ] && source "$1"
	return 0
}

function_declared() {
	declare -F $1 >/dev/null
	return $?
}


### Generic paths

prepend_if_not_in_path PATH /usr/local/bin
prepend_if_not_in_path PATH /usr/local/sbin
prepend_if_not_in_path PATH /opt/local/bin
append_if_not_in_path PATH "$HOME/bin"

# The system may not set MANPATH, instead relying on a config file or a more
# complex mechanism (macOS), so we need to initialize MANPATH before adding to
# it.
[ -x "$(command -v man)" ] && [ -z "$MANPATH" ] && export MANPATH="$(man -w)"
prepend_if_not_in_path MANPATH /usr/local/share/man
prepend_if_not_in_path MANPATH /usr/local/man
append_if_not_in_path MANPATH $HOME/man
append_if_not_in_path MANPATH $HOME/share/man

prepend_if_not_in_path INFOPATH /usr/share/info # In case INFOPATH not set
prepend_if_not_in_path INFOPATH /usr/local/share/info
prepend_if_not_in_path INFOPATH /usr/local/info
append_if_not_in_path INFOPATH $HOME/info
append_if_not_in_path INFOPATH $HOME/share/info


### General environment

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export CLICOLOR=1 # Colors for 'ls'


### Bash options

FIGNORE='~'
HISTCONTROL=ignoreboth # Ignore duplicates and lines starting with space
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize globstar histappend


### Prompts

ps_esc() {
	printf '\[\e'$1'\]'
}

nonzero_return() { # Show nonzero return in prompt
	local retval=$?
	[ "$retval" -ne 0 ] && echo " $retval "
}

safe_git_ps1() {
	function_declared __git_ps1 && __git_ps1 " (%s)"
}
GIT_PS1_SHOWDIRTYSTATE=1 # * or +
GIT_PS1_SHOWSTASHSTATE=1 # $
GIT_PS1_SHOWUNTRACKEDFILES=1 # %
GIT_PS1_SHOWUPSTREAM=auto # < > <> or =
GIT_PS1_STATESEPARATOR= # No inconsistent space

case $(uname) in
	Darwin) pscolor=2 # green
		tmuxstatusstyle=fg=black,bg=green
		tmuxpaneactiveborderstyle=fg=green
		;;
	Linux) pscolor=3 # yellow
		tmuxstatusstyle=fg=black,bg=yellow
		tmuxpaneactiveborderstyle=fg=yellow
		;;
	*) pscolor=4 # blue
		tmuxstatusstyle=bg=blue
		tmuxpaneactiveborderstyle=fg=blue
		;;
esac

ps1=$(ps_esc "[1;31;47m")'$(nonzero_return)'$(ps_esc "[m")
ps1+=$(ps_esc "[1;4${pscolor}m")'[\u@\h \w]'$(ps_esc "[m")
ps1+=$(ps_esc "[3${pscolor}m")'$(safe_git_ps1)'$(ps_esc "[m")
ps1+='\n'
ps1+=$(ps_esc "[1;3${pscolor}m")'\! $'$(ps_esc "[m")
ps1+=' ' # nbsp for backward-searching

PS1="$ps1"

PS2=$(ps_esc "[1;4${pscolor}m")'>'$(ps_esc "[m")' '


### Tmux options
# We cannot set these in .tmux.conf, because we may not yet have a session.

if [ -n "$TMUX" ]; then
	tmux set-option status-style $tmuxstatusstyle
	tmux set-option pane-active-border-style $tmuxpaneactiveborderstyle

	tmux set-option pane-border-status top
	tmux set-option pane-border-format '[#{pane_index}: #{pane_current_command} #{pane_width}x#{pane_height}] #{pane_mode}'
fi


### Shell aliases

alias la='ls -A'
alias ll='ls -lFh'
alias lal='ls -lAFh'
alias lsrecent='ls -lFht | head'

alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'

alias tree='tree -I "*~"'
alias octave='octave -q'
alias bc='bc -lq'
alias w3m='w3m -v'
alias hd="od -A x -t x1c"

alias rule='printf \\033[33m◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼\\033[39m\\n'

asciidump()
{
	hexdump -ve '80/1 "%1_p" "\n"' "$@"
}

nkfless()
{
	nkf -w ${1} | less
}


### Application setup

# GNU ls
if [ -x "$(command -v dircolors)" ]; then
	eval $(dircolors --bourne-shell)
	alias ls='ls --color=auto'
fi


# Less
export LESS='-XFRi'
export LESSCHARSET=utf-8
if [ -x "$(command -v source-highlight)" ]; then
	src_hilite_lesspipe=$(command -v src-hilite-lesspipe.sh)
	if [ -x $src_hilite_lesspipe ]; then
		export LESSOPEN="| $src_hilite_lesspipe %s"
	fi
fi


# Homeshick
source_if_file $HOME/.homesick/repos/homeshick/homeshick.sh
source_if_file $HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash
function_declared homeshick && homeshick refresh -q 2
function_declared homeshick || echo "homeshick missing"


# Gradle: use gradlew when present
gradle() {
	local gradlew=
	local dir=.
	while [ $(cd $dir; pwd) != / ]; do
		if [ -x $dir/gradlew ]; then
			gradlew=$dir/gradlew
			break
		fi
		if [ $dir = . ]; then dir=..; else dir=$dir/..; fi
	done
	if [ -z "$gradlew" ]; then
		gradlew=$(which gradle)
	fi
	if [ -z "$gradlew" ]; then
		echo "neither gradlew nor gradle found"
		return 1
	fi
	echo "[$gradlew]"
	$gradlew "$@"
}


# Node version manager
export NVM_DIR=$HOME/.nvm
source_if_file $NVM_DIR/nvm.sh
source_if_file $NVM_DIR/bash_completion


# Rust
append_if_not_in_path PATH $HOME/.cargo/bin


# Aliases to set get config
# user.name is set in ~/.gitconfig
# These are used to set email, which depends on repo.
alias git-config-wisc='git config user.email matsuchida@wisc.edu'
alias git-config-gmail='git config user.email marktsuchida@gmail.com'


#
# OS-specific settings
#

os_guess=
case `uname` in
	*Darwin*) os_guess=darwin;;
esac

if [ -f /etc/os-release ]; then
	if grep -q 'ID_LIKE=debian' /etc/os-release || \
		grep -q 'ID=debian' /etc/os-release; then
		os_guess=debian-like
	fi
fi

case $os_guess in
	darwin) source_if_file .bashrc-darwin;;
	debian-like) source_if_file .bashrc-debian;;
esac


#
# Local settings
#
source_if_file .bashrc-local


# Ignore any settings that various installers might "smartly" append.
return

# -- last line of intended content --

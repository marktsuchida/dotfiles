# Exit if not interactive
case $- in
	*i*) ;;
	*) return;;
esac


# Just start tmux if we are not already in tmux
if [ -z "$TMUX" ]; then
	if [ -x $(command -v tmux) ]; then
		export EDITOR=vi # Tell tmux to use vi-style keys
		# Create a new session attached to the session group of the
‣       ‣       # 'main' session. The 'main' session is ensured to exist by
‣       ‣       # being created in .tmux.conf. Then make sure the session
		# created here is destroyed when the terminal is detached.
		exec tmux new-session -t main \; set-option destroy-unattached
	else
		echo "tmux not available"
	fi
fi


#
# Actual configuration follows
#


### Internal functions

prepend_if_not_in_path() {
	[[ ":${!1}:" == *":$2:"* ]] || export $1="$2:${!1}"
}

append_if_not_in_path() {
	[[ ":${!1}:" == *":$2:"* ]] || export $1="${!1}:$2"
}

source_if_file() {
	[ -s $1 ] && source $1
	return 0
}

function_declared() {
	declare -F $1 >/dev/null
	return $?
}


### Generic paths

prepend_if_not_in_path PATH /usr/local/bin
prepend_if_not_in_path PATH /opt/local/bin
append_if_not_in_path PATH "$HOME/bin"

prepend_if_not_in_path MANPATH /usr/local/share/man
prepend_if_not_in_path MANPATH /usr/local/man
append_if_not_in_path MANPATH $HOME/man
append_if_not_in_path MANPATH $HOME/share/man

prepend_if_not_in_path INFOPATH /usr/local/share/info
prepend_if_not_in_path INFOPATH /usr/local/info
append_if_not_in_path INFOPATH $HOME/info
append_if_not_in_path INFOPATH $HOME/share/info


### General environment

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export CLICOLOR=1 # Colors for 'ls'


### Prompts

ps_esc() {
	printf '\[\e'$1'\]'
}

nonzero_return() { # Show nonzero return in prompt
	local retval=$?
	[ "$retval" -ne 0 ] && echo $retval
}

safe_git_ps1() {
	function_declared __git_ps1 && __git_ps1 " (%s)"
}
GIT_PS1_SHOWDIRTYSTATE=1 # * or +
GIT_PS1_SHOWSTASHSTATE=1 # $
GIT_PS1_SHOWUNTRACKEDFILES=1 # %
GIT_PS1_SHOWUPSTREAM=auto # < > <> or =

case $(uname) in
	Darwin) pscolor=2;; # green
	Linux) pscolor=3;; # yellow
	*) pscolor=4;; # blue
esac

ps1=$(ps_esc "[1;31;47m")'$(nonzero_return)'$(ps_esc "[m")
ps1+=$(ps_esc "[1;4${pscolor}m")'[\u@\h \w]'$(ps_esc "[m")
ps1+=$(ps_esc "[3${pscolor}m")'$(safe_git_ps1)'$(ps_esc "[m")
ps1+='\n'
ps1+=$(ps_esc "[1;3${pscolor}m")'\! $'$(ps_esc "[m")
ps1+=' '

PS1="$ps1"

PS2=$(ps_esc "[1;4${pscolor}m")'>'$(ps_esc "[m")' '


### Other bash options

FIGNORE='~'
HISTCONTROL=ignoreboth # Ignore duplicates and lines starting with space
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize extglob histappend


### Shell aliases

alias lf='ls -wF'
alias ll='ls -wlFh'
alias la='ls -waF'
alias lal='ls -wlaFh'
alias lsrecent='ls -wlFht | head'

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

# Less
export LESS='-Ri'
export LESSCHARSET=utf-8
if [ -x $(command -v source-highlight) ]; then
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


#
# OS-specific settings
#

os_guess=
case `uname` in
	*Darwin*) os_guess=darwin;;
esac

if [ -f /etc/os-release ]; then
	if grep -q 'ID_LIKE=debian' /etc/os-release; then
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

case `uname` in
	*Darwin*) is_darwin=yes ;;
esac

if test "$is_darwin" = yes; then
	ulimit -u 512 -n 1024
fi

export PATH=/usr/local/bin:$PATH
export PATH=$PATH:$HOME/bin

ps_esc() {
	printf '\[\e'$1'\]'
}
ps1=$(ps_esc "[1;31;47m")'$(nonzero_return)'$(ps_esc "[m")
ps1+=$(ps_esc "[1;42m")'[\u@\h \w]'$(ps_esc "[m")
ps1+=$(ps_esc "[32m")'$(safe_git_ps1)$(aws_profile)$(kubectl_context)'$(ps_esc "[m")
ps1+='\n'
ps1+=$(ps_esc "[1;32m")'\! $'$(ps_esc "[m")
ps1+=' '
PS1="$ps1"
PS2=$(ps_esc "[1;42m")'>'$(ps_esc "[m")' '
FIGNORE='~'

HISTFILESIZE=5000
shopt -s extglob histappend

### Hosts

export MONTEVERDI=50.0.150.224

### Have ssh-agent running

eval `ssh-agent -s` >/dev/null

### Aliases and functions

alias ls='ls -wF'
alias ll='ls -wlFh'
alias la='ls -waF'
alias lal='ls -wlaFh'
alias lsrecent='ls -wlFht | head'
alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'

alias octave='octave -q'
alias bc='bc -lq'
alias w3m='w3m -v'
alias hd="od -A x -t x1c"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rule='printf \\033[33m◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼\\033[39m\\n'

if test "$is_darwin" = yes; then
	alias 'open.'='open .'
	alias Preview='open -a Preview'
	alias Skim='open -a Skim'
	alias acroread='open -a "Adobe Reader.app"'
	alias chrome='open -a "Google Chrome.app"'
	alias pbcopy='reattach-to-user-namespace pbcopy'
	alias pbpaste='reattach-to-user-namespace pbpaste'
	alias pbclear='pbcopy < /dev/null'

	pbsort()
	{
		reattach-to-user-namespace pbpaste | \
			sort "$@" | reattach-to-user-namespace pbcopy
	}

	manskim()
	{
		man -t "$@" | open -f -a Skim
	}

	manprev()
	{
		man -t "$@" | open -f -a Preview
	}

	doi()
	{
		open http://dx.doi.org/${1}
	}
fi

asciidump()
{
	hexdump -ve '80/1 "%1_p" "\n"' "$@"
}

nkfless()
{
	nkf -w ${1} | less
}

### Environmental variables for programs

for year in 2012 2013 2014 2015 2016; do
	if test -d "/usr/local/texlive/$year/texmf-dist"; then
		texlive="/usr/local/texlive/$year"
		break
	fi
done
if test -n "$texlive"; then
	texmanpath="$texlive/texmf-dist/doc/man"
	texinfopath="$texlive/texmf-dist/doc/info"
	export MANPATH=$texmanpath:$MANPATH
	export INFOPATH=$texinfopath:$INFOPATH
fi
export MANPATH=/usr/local/man:/usr/local/share/man:$MANPATH:$HOME/man:$HOME/share/man
export INFOPATH=/usr/local/info:/usr/local/share/info:$INFOPATH:$HOME/info:$HOME/share/info

export PAGER='less'
export LESS='-Ri'
export LESSCHARSET=utf-8
if test -n "$(which source-highlight)"; then
	src_hilite_lesspipe="$(which src-hilite-lesspipe.sh)"
	if test -x "$src_hilite_lesspipe"; then
		export LESSOPEN="| $src_hilite_lesspipe %s"
	fi
fi
export EDITOR=vim
export VISUAL=vim

export SCREENDIR=$HOME/.screen

export GROOVY_HOME=/usr/local/opt/groovy/libexec

# Colors for 'ls'
export CLICOLOR=1

# see also .gnuplot
export GNUTERM=x11

# Go (installed by homebrew)
if which go &>/dev/null; then
	export GOROOT=/usr/local/opt/go/libexec
	export PATH=$PATH:$GOROOT/bin
fi

# Completions (homebrew)
for scpt in /usr/local/etc/bash_completion.d/*; do
	source $scpt
done
complete -C aws_completer aws

# Git prompt if available
function_declared() {
	declare -F $1 >/dev/null
	return $?
}
safe_git_ps1() {
	function_declared __git_ps1 && __git_ps1 " (%s)"
}

# Show nonzero return in prompt
nonzero_return() {
	local retval=$?
	[ "$retval" -ne 0 ] && echo $retval
}

# Show AWS profile
aws_profile() {
	[ -n "$AWS_PROFILE" ] && echo " aws:$AWS_PROFILE"
}

# Show kubectl context in prompt
kubectl_context() {
	which kubectl &>/dev/null || return
	local context=$(kubectl config current-context 2>/dev/null)
	# Would be nice to hide "k8s:minikube" when minikube is not running,
	# but 'minikube status' is too slow to run for every prompt.
	[ -n "$context" ] && echo " k8s:$context"
}

# Homebrew
export HOMEBREW_GITHUB_API_TOKEN=25fc788cfeee232a3df829a4ec7ba0b195977f61

# Define homeshick command
source $HOME/.homesick/repos/homeshick/homeshick.sh
source $HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash

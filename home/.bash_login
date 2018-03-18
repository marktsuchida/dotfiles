# We need to avoid starting tmux when invoked from certain scripts
# (such as the XQuartz startup script). In this case, bash is a login
# shell but not an interactive shell.
case "$-" in
*i*) # Interactive shell
	if test -n "$TMUX"; then
		# Started inside tmux
		if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
	elif test -n "`which tmux`"; then
		# Let tmux know that we prefer vim
		export EDITOR=vim

		# Create a new session attached to the session group of the
		# 'main' session. The 'main' session is ensured to exist by
		# being created in .tmux.conf. Make sure the session created
		# here is destroyed when the terminal is detached.
		exec tmux new-session -t main \; set-option destroy-unattached
	else
		echo "tmux not available"
		if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
	fi
	;;
*) # Non-interactive shell
	;;
esac

#!/bin/bash
pwd | sed "s|^$HOME|~|"

# This needs to be in a script due to claude bug on Windows that prevents
# substitution of $HOME (as of this writing). Configure as follows:
#
#  "statusLine": {
#    "type": "command",
#    "command": "bash -c ~/.claude/statusline.sh"
#  }

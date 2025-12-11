#!/bin/bash
input=$(cat)

INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
MODEL=$(echo "$input" | jq -r '.model.display_name')

# This won't include system prompt and other front matter.
TOTAL_TOKENS=$((INPUT_TOKENS + OUTPUT_TOKENS))
PERCENT=$(echo "scale=1; $TOTAL_TOKENS * 100 / $CONTEXT_SIZE" | bc)

echo "${PERCENT}% ${MODEL} $(pwd | sed "s|^$HOME|~|")"

#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')

echo "${MODEL} $(pwd | sed "s|^$HOME|~|")"

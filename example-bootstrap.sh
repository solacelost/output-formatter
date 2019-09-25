#!/bin/bash
# This is some example code you can use to bootstrap formatter for your script
#   if you can count on an internet connection and don't want to include the
#   formatter itself in your release/repo.
# Ensure you .gitignore it if appropriate!

# Change this as needed to point to the release you're wanting.
formatter_url=https://raw.githubusercontent.com/solacelost/output-formatter/v1.0/formatter

# Always start with a sane place for formatter, don't leave copies everywher
original_dir=$(pwd)
cd $(dirname $(realpath $0))
# Alternative download locations are things like ~/.local/share (very reliable)
#   or /tmp (very ephemeral, may trip up some policies)

# Figure out what we can use to download things
function which_dl() {
    if which wget 2>/dev/null; then
        return 0
    elif which curl 2>/dev/null; then
        echo "-o $1"
        return 0
    fi
    echo 'Unable to download formatter, please install wget or curl and' \
         'ensure it is in your PATH.' >&2
    exit 3
}

# Downloads a release of the output-formatter to make things pretty
if [ ! -r formatter ]; then
    # Try to download the thing
    if ! $(which_dl formatter) "$formatter_url" 2>/dev/null; then
        echo "Unable to download formatter, please ensure you have network" \
             "connectivity and write permissions to $(dirname $0), or stage" \
             "formatter from the following link adjacent to $(basename $0):" >&2
        echo "$formatter_url" >&2
        exit 7
    fi
fi
. formatter

# From here, we should go back where you came from
cd "$original_dir"

# From here on you have all the functions of the formatter at your disposal

center_border_text "Everything appears to have worked!"

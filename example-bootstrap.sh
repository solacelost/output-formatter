#!/bin/bash
# This is some example code you can use to bootstrap formatter for your script
#   if you can count on an internet connection and don't want to include the
#   formatter itself in your release/repo.
# Ensure you .gitignore it if appropriate!


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
    formatter_url=https://raw.githubusercontent.com/solacelost/output-formatter/v1.0/formatter
    # Try to download the thing
    if ! $(which_dl formatter) "$formatter_url" 2>/dev/null; then
        echo 'Unable to download formatter, please ensure you have network' \
             'connectivity or stage formatter from the following link' \
             'adjacent to mkvenv.sh:' >&2
        echo "$formatter_url" >&2
        exit 7
    fi
fi
. formatter
# From here on you have all the functions of the formatter at your disposal

center_border_text "Everything appears to have worked!"

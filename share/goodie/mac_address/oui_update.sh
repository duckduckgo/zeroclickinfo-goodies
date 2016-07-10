#!/bin/sh

set -e

wget -O - http://standards-oui.ieee.org/oui/oui.txt | sed '
    # Remove Windows-style line endings.
    s/\r$//;

    # Preserve, but massage, the version information.
    s/^[[:space:]]*\(Generated.*\)/# \1/;

    # Remove unnecessary information
    2,7d;

    # Remove alternate representation.
    /^[[:space:]]*[[:xdigit:]]*[[:space:]]*(base 16)/d;

    # Ensure backslashes are escaped.
    s/\\/\\\\/;

    # Capture start of new OUI block.
    /^[[:space:]]*[[:xdigit:]-]*[[:space:]]*(hex)/ {
        s/^[[:space:]]*\([[:xdigit:]][[:xdigit:]]\)-\([[:xdigit:]][[:xdigit:]]\)-\([[:xdigit:]][[:xdigit:]]\)/\1\2\3/;
        s/^[[:space:]]*\([[:xdigit:]]*\)[[:space:]]*(hex)[[:space:]]*\(.*\)$/\1\\n\2/;
        h;
        d;
    };

    # Append to running OUI block.
    /^[[:space:]]*[^[:space:]]/ {
        s/^[[:space:]]*//g;
        H;
        d;
    };

    # Format completed OUI block.
    /^$/ {
        g;
        s/,\([^ \n]\)/, \1/g;
        s/\n/\\n/g;
        s/   */ /g;
        s/ \\n/\\n/g;
        s/ ,/,/g;
    };

    # Remove any blank lines.
    /^[[:space:]]*$/d;
    ' > oui_database.txt

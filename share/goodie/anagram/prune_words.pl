#!/usr/bin/perl

# It would be nice to automate mapping accented letters to "standard"
# letters as well to speed up word file transformation, but for now
# this simply removes apostrophized words.

open INF, "<", $ARGV[0] or die $!;
open OUTF, ">", "foobitybaz" or die $!;

while (<INF>) {
    print OUTF unless /'/;
}

1;

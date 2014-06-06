package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.

use DDG::Goodie;

triggers startend =>
    'chars',
    'number of characters',
    'number of chars',
    'num chars',
    'num characters',
    'char count',
    'character count',
    'characters count',
    'length of string',
    'length in characters',
    'length in chars';

zci is_cached => 1;
zci answer_type => "chars";

name 'Character Counter';
description 'Count the number of charaters in a query';
primary_example_queries 'chars in "my string"';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Chars.pm';
category 'computing_tools';
topics 'programming';

handle remainder => sub {
    my ($str) = @_;
    return if !$str;

    # remove leading word 'in',
    # e.g. 'chars in mississippi' would just count the string 'mississippi'.
    $str =~ s/^\s*in\b//;

    # trim spaces at beg and end of string
    $str =~ s/^\s+|\s+$//g;

    # if nothing left in the string, return without triggering the IA.
    # this means the remainder contained only the word 'in' and/or spaces.
    return if !$str;

    # if surrounded by quotation marks (either ' or ")
    # remove so we don't include them in the count
    $str =~ s/^["'](.*)["']$/$1/;

    # get the length of the string in characters
    my $len = length($str);

    # pluralize the word 'character' unless length is 1.
    # note that this works for length=0, i.e. we'll correctly get '0 characters'.
    my $characters_pluralized = (length($str) == 1 ? 'character' : 'characters');

    # build the output string
    my $text_out = qq("$str" is $len $characters_pluralized long.);

    return $text_out;
};

1;

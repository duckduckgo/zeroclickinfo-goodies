package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.

use DDG::Goodie;

triggers startend =>
    'chars',
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
    $str =~ s/^in\s//;

    # trim spaces at beg and end of string
    $str =~ s/^\s*//;
    $str =~ s/\s*$//;

    # if surrounded by quotation marks, either ' or ",
    # remove so we don't include in the count
    $str =~ s/^["'](.*)["']$/$1/;

    # get the length of the string in characters
    my $len = length($str);

    # pluralize the word 'character' unless length is 1
    my $characters_pluralized = 'character' . (length($str) > 1 ? 's' : '');

    # build the output string
    my $text_out = qq("$str" is $len $characters_pluralized long.);

    return $text_out;
};

1;

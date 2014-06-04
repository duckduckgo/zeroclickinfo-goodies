package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.

use DDG::Goodie;

triggers start => 'chars';
triggers start => 'chars in';
triggers startend => 'num chars';
triggers start => 'num chars in';
triggers startend => 'num characters';
triggers start => 'num characters in';
triggers startend => 'char count';
triggers start => 'char count in';
triggers startend => 'character count';
triggers start => 'character count in';
triggers startend => 'length of string';
triggers startend => 'length in characters';
triggers startend => 'length in chars';

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

    # trim spaces
    $str =~ s/^\s*//;
    $str =~ s/\s*$//;

    # if string has quotation marks, use that only the portion between the quotes
    if ($str =~ /\"(.*)\"/) {
	$str = $1;
    }

    # get the length of the string in characters
    my $len = length($str);

    # correctly pluralize the word 'characters' depending on the string length,
    # i.e. '1 character' vs. '2 characters'.
    my $characters_pluralized = 'character' . (length($str) > 1 ? 's' : '');
    my $text_out = qq("$str" is $len $characters_pluralized long.);

    return $text_out;
};

1;

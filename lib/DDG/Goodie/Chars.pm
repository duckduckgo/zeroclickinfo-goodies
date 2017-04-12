package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.

use strict;
use DDG::Goodie;
use Text::Trim;

triggers start =>
    'number of characters',
    'number of chars',
    'num chars',
    'num characters',
    'char count',
    'character count',
    'length in characters',
    'length in chars';

zci answer_type => "chars";
zci is_cached   => 1;

handle remainder => sub {
    my ($str) = @_;
    return if !$str;

    # remove leading words 'in' and 'of,
    # e.g. 'number of characters in mississippi' would just count the string 'mississippi'.
    $str =~ s/^\s*(in|of)\b//;
    
    # trim spaces at beg and end of string
    $str = trim $str;

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
    my $characters_pluralized = ($len == 1 ? 'character' : 'characters');

    return qq("$str" is $len $characters_pluralized long.),
      structured_answer => {
        data => {
            title    => $len,
            subtitle => "Character count: $str"
        },
        templates => {
            group => 'text'
        }
      };
};

1;

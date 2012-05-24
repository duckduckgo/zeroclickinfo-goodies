package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.

use DDG::Goodie;

triggers start => 'chars';

zci is_cached => 1;
zci answer_type => "chars";

handle remainder => sub {
    return "Chars: " .length $_ if $_;
    return;
};

1;

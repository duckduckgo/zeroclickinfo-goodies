package DDG::Goodie::Length;

use DDG::Goodie;

triggers start => "length";

zci is_cached => 1;

handle remainder => sub {
    return "Length: ".length $_ if $_;
    return;
};
1;

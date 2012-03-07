package DDG::Goodie::TitleCase;

use DDG::Goodie;

zci is_cached => 1;

triggers startend => 'title-case';

handle remainder => sub { join(' ', map { ucfirst $_ } split(/ /, $_))};

1;
package DDG::Goodie::SentenceCase;

use DDG::Goodie;

zci is_cached => 1;

triggers startend => 'sentence-case';

handle remainder => sub { join(' ', map { ucfirst $_ } split(/ /, $_))};

1;

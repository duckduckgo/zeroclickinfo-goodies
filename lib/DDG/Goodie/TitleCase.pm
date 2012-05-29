package DDG::Goodie::TitleCase;

use DDG::Goodie;

triggers startend => 'titlecase', 'ucfirst', 'title case';

zci is_cached => 1;
zci answer_type => "title_case";

handle remainder => sub { join(' ', map { ucfirst $_ } split(/ /, $_))};

1;

package DDG::Goodie::TitleCase;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "title_case";
triggers startend => 'title-case', 'titlecase', 'ucfirst';

handle remainder => sub { join(' ', map { ucfirst $_ } split(/ /, $_))};

1;

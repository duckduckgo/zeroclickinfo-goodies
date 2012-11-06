package DDG::Goodie::TitleCase;

use DDG::Goodie;

triggers startend => 'titlecase', 'ucfirst', 'title case';

primary_example_queries 'titlecase test';
description 'return the query in title case';
name 'Title Case';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/TitleCase.pm';
category 'transformations';
topics 'words_and_games';

attribution github => ['https://github.com/moollaza', 'moollaza'];

zci is_cached => 1;
zci answer_type => "title_case";

handle remainder => sub { join(' ', map { ucfirst $_ } split(/ /, $_))};

1;

package DDG::Goodie::TitleCase;
# ABSTRACT: Convert a string to title case.

use DDG::Goodie;

triggers start => 'titlecase', 'title case';

primary_example_queries 'titlecase test';
description 'return the query in title case';
name 'Title Case';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/TitleCase.pm';
category 'transformations';
topics 'words_and_games';

attribution github => ['moollaza', 'Zaahir Moolla'],
            github => ['maxluzuriaga', 'Max Luzuriaga'];

zci answer_type => "title_case";
zci is_cached   => 1;

# http://blog.apastyle.org/apastyle/2012/03/title-case-and-sentence-case-capitalization-in-apa-style.html
my %exceptions = map { $_ => 1 } ("a", "an", "and", "the", "by", "but", "for", "or", "nor", "yet", "so", "as", "at", "in", "of", "on", "per", "to");

handle remainder => sub {
    my $input = shift;

    return unless $input;

    my ($first_word, @words) = split(/\s+/, lc $input);    # Normalize to lowercase and break out words.

    my $title_case = join(
        ' ',                                               # Single spaces between words in the result
        ucfirst $first_word,                               # First word is always capped.
        map {
            ($exceptions{$_})
              ? $_                                         # Exceptions left untouched.
              : join('-', map { ucfirst } split(/-/, $_))  # Each part of a hyphenated word is capped.
        } @words
    );

    return $title_case,
      structured_answer => {
        input     => [html_enc($input)],
        operation => 'Title case',
        result    => html_enc($title_case),
      };
};

1;

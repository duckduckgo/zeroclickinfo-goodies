package DDG::Goodie::TitleCase;
# ABSTRACT: Convert a string to title case.

use strict;
use DDG::Goodie;

triggers start => 'titlecase', 'title case';

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

    return $title_case, structured_answer => {
        data => {
            title => $title_case,
            subtitle => "Title case: $input"
        },
        templates => {
            group => 'text'
        }
    };
};

1;

package DDG::Goodie::TitleCase;
# ABSTRACT: Convert a string to title case.

use DDG::Goodie;

triggers startend => 'titlecase', 'ucfirst', 'title case', 'capitalize';

primary_example_queries 'titlecase test';
description 'return the query in title case';
name 'Title Case';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/TitleCase.pm';
category 'transformations';
topics 'words_and_games';

attribution github => ['https://github.com/moollaza', 'moollaza'],
            github => ['https://github.com/maxluzuriaga', 'Max Luzuriaga'];

zci is_cached => 1;
zci answer_type => "title_case";

# http://blog.apastyle.org/apastyle/2012/03/title-case-and-sentence-case-capitalization-in-apa-style.html
my @exceptions = ("a", "an", "and", "the", "by", "but", "for", "or", "nor", "yet", "so", "as", "at", "in", "of", "on", "per", "to");

handle remainder => sub {
    return unless $_;

    my @words = split(/ /, $_);

    @words = map {
        my $word = $words[$_];
        if ($_ == 0) {
            ucfirst $word # Capitalize first word
        } else {
            if (grep { $_ eq $word } @exceptions) {
                $word # Don't capitalize minor words
            } else {
                join('-', map { ucfirst $_ } split(/-/, $word) ) # Capitalize every part of a hyphenated word
            }
        }
    } 0 .. $#words;

    return join(' ', @words);
};

1;

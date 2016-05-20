package DDG::Goodie::CamelCase;
# ABSTRACT: Converts text to camelCase

use DDG::Goodie;
use strict;

zci answer_type => "camel_case";
zci is_cached   => 1;

# Triggers
triggers start => "camelcase", "camel case";

# Handle statement
handle remainder => sub {
    my $input = shift;

    return unless $input; # Guard against "no answer"
    
    my ($first_word, @words) = split(/\s+/, lc $input);
    
    return unless @words;
    
    my $camelCase = join(
        '',
        $first_word,
        map { ucfirst $_ } @words
    );

    return $camelCase, structured_answer => {
        data => {
            title => $camelCase,
            subtitle => 'camelCase'
        },
        templates => {
            group => 'text',
            moreAt => 1
        },
        meta => {
            sourceName => 'Wikipedia',
            sourceUrl => 'https://en.wikipedia.org/wiki/CamelCase'
        }
    }
};

1;

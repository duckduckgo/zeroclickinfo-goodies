package DDG::Goodie::CamelCase;
# ABSTRACT: Converts text to camelCase

use DDG::Goodie;
use strict;

zci answer_type => "camel_case";
zci is_cached   => 1;

name "CamelCase";
description "Converts the query to camelCase";
primary_example_queries "camelcase this is a test", "camel case this is another test";
category "programming";
topics "geek", "programming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CamelCase.pm";
attribution github => ["https://github.com/Sloff", "Sloff"];

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
        id => 'camel_case',
        name => 'answer',
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

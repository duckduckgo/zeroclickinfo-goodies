package DDG::Goodie::CamelCase;
# ABSTRACT: Converts text to camelCase

use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';
use strict;

zci answer_type => "camel_case";
zci is_cached   => 1;

# Triggers
triggers start => "camelcase", "camel case";

my $matcher = wi(
    groups => ['command'],
    options => {
        command => qr/camel ?case/i,
    },
);

# Handle statement
handle query_raw => sub {
    my $input = shift;

    my $result = $matcher->match($input) or return;

    my ($first_word, @words) = split(/\s+/, lc $result->{primary});

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

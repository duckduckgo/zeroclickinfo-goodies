#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "if_you_could";
zci is_cached   => 0;

# Build a structured answer that should match the response from the
# Perl file.
my $answer = 'This DuckDuckHack.';
my $my_structured_answer = {
    id        => 'if_you_could',
    data      => {
        title    => $answer,
        subtitle => "If you could hack your search engine, what would you do?",
    },
    meta      => {
        sourceName => 'DuckDuckHack',
        sourceUrl  => 'https://duck.co'
    },
    templates => {
            group => "text",
    }
};

ddg_goodie_test(
    [qw( DDG::Goodie::IfYouCould )],
    'if you could hack your search engine, what would you do?' => test_zci(
        $answer,
        structured_answer => $my_structured_answer
    ),
    'if you could hack your search engine, what would you do' => test_zci(
        $answer,
        structured_answer => $my_structured_answer
    ),
    'if you could hack your search engine' => test_zci(
        $answer,
        structured_answer => $my_structured_answer
    ),
    'If you could hack your search engine' => test_zci(
        $answer,
        structured_answer => $my_structured_answer
    ),
    'If you could hack your search engine?' => test_zci(
        $answer,
        structured_answer => $my_structured_answer
    ),
    'if you could hack a search engine'          => undef,
    'if you could'                               => undef,
    'what would you do'                          => undef,
    'what if you could hack your search engine'  => undef,
);

done_testing;

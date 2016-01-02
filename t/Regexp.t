#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'regexp';
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, $expression, $text) = @_;
    return $result,
        structured_answer => {
            id   => 'regexp',
            name => 'Answer',
            data => {
                title       => 'Regular Expression Match',
                subtitle    => "Match regular expression /$expression/ on $text",
                record_data => $result,
            },
            templates => {
                group   => 'list',
                options => {
                    content => 'record',
                },
                moreAt  => 0,
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }


done_testing;


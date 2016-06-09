#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "constants";
zci is_cached   => 1;

sub build_test
{
    my ($text, $subtitle, $title) = @_;
    return test_zci($text, structured_answer => {
        data => {
            constant => $title,
            subtitle => $subtitle,
        },
        templates => {
            group => 'text',
            options => {
                title_content => 'DDH.constants.title_content'
            }
        },
        meta => {
            signal => 'high'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Constants )],
    "Hardy Ramanujan number" => build_test(
        '1^3 + 12^3 = 9^3 + 10^3',
        'Hardy Ramanujan Number 1729',
        "1<sup>3</sup> + 12<sup>3</sup> = 9<sup>3</sup> + 10<sup>3</sup>",
    ),
    #without apostrophe
    "Avogadros number" => build_test(
        '6.0221415 × 10^23 mol^-1',
        'Avogadro\'s Number',
        '6.0221415 × 10<sup>23</sup> mol<sup>-1</sup>',
    ),
    #with apostrophe
    "Avogadro's number" => build_test(
        '6.0221415 × 10^23 mol^-1',
        'Avogadro\'s Number',
        '6.0221415 × 10<sup>23</sup> mol<sup>-1</sup>',
    ),
    #constant without html (only plain)
    "Eulers constant" => build_test(
        '0.577215665',
        "Euler's Constant",
        '0.577215665',
    ),
    "How old is my grandma?" => undef,
    "why?" => undef,
);

done_testing;

#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'root';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::CalcRoots
    )],
    'square root of negative 9' => test_zci(
    "The 2-root of -9 is 3 i",
        heading           => "Root Calculator", 
        structured_answer => {
            input     => ["2-root of -9"],
            operation => 'Calculate',
            result    => "<sup>2</sup>&radic;-9 = 3<em>i</em>"
            }
    ),
    'negative square root of negative 25' =>test_zci(
    "The -2-root of -25 is -5 i",
        heading           => "Root Calculator", 
        structured_answer => {
            input     => ["-2-root of -25"],
            operation => 'Calculate',
            result    => "-<sup>2</sup>&radic;-25 = -5<em>i</em>"
            }
    ),
    '2nd root of 100' => test_zci(
        "The 2-root of 100 is 10.",
        heading           => "Root Calculator", 
        structured_answer => {
            input     => ["2-root of 100"],
            operation => 'Calculate',
            result    => qq|<sup>2</sup>&radic;100 = <a href="javascript:;" onclick="document.x.q.value='10';document.x.q.focus();">10</a>|
            }
    ),
    'cube root of 33' => test_zci(
        "The 3-root of 33 is 3.20753432999583.",
        heading           => "Root Calculator", 
        structured_answer => {
            input     => ["3-root of 33"],
            operation => 'Calculate',
            result    => qq|<sup>3</sup>&radic;33 = <a href="javascript:;" onclick="document.x.q.value='3.20753432999583';document.x.q.focus();">3.20753432999583</a>|
        }
    ),
);
done_testing;

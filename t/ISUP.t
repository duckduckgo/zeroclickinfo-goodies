#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use LWP::Simple;

zci answer_type => "isup";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::ISUP )],
    'isup duck.co' => test_zci(
        'Seems up!',
        structured_answer => {
            input     => [],
            operation => 'duck.co',
            result    => 'Seems up!'
        }
    ),
    'isup http://www.duckduckduck.com' => test_zci(
        'Seems to be down!',
        structured_answer => {
            input     => [],
            operation => 'http://www.duckduckduck.com',
            result    => 'Seems to be down!'
        }
    ),
    'isdown www.codenirvana.net' => test_zci(
        'Seems up!',
        structured_answer => {
            input     => [],
            operation => 'www.codenirvana.net',
            result    => 'Seems up!'
        }
    ),
    'online codenirvana.net' => test_zci(
        'Seems up!',
        structured_answer => {
            input     => [],
            operation => 'codenirvana.net',
            result    => 'Seems up!'
        }
    ),
    'https://duck.co is down' => test_zci(
        'Seems up!',
        structured_answer => {
            input     => [],
            operation => 'https://duck.co',
            result    => 'Seems up!'
        }
    ),
    'is up www.gitduck.com' => test_zci(
        'Seems up!',
        structured_answer => {
            input     => [],
            operation => 'www.gitduck.com',
            result    => 'Seems to be down!'
        }
    ),
    'is down www.gitduck.com' => test_zci(
        'Seems up!',
        structured_answer => {
            input     => [],
            operation => 'www.gitduck.com',
            result    => 'Seems to be down!'
        }
    ),
    'isup 123'    => undef,
    'isup httpxyz://github.com' => undef,
    'isup xyz' => undef,
    'isup https://github' => undef,
);

done_testing;

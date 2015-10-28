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
    'isup codenirvana.net/p/contact-us.html' => test_zci(
        'Seems up!',
        structured_answer => {
            input     => [],
            operation => 'codenirvana.net/p/contact-us.html',
            result    => 'Seems up!'
        }
    ),
    'isup 123'    => undef,
    'isup httpxyz://github.com' => undef,
    'isup xyz' => undef,
    'isup https://github' => undef,
);

done_testing;

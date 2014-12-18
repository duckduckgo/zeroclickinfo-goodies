#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'guid';
zci is_cached => 0;

my @answer = (qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/, structured_answer => { input =>[], operation => 'random GUID', result =>qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/});

ddg_goodie_test([qw( DDG::Goodie::GUID ) ],

    # Check that the trigger kicks in.
    'guid'                       => test_zci(@answer),
    'uuid'                       => test_zci(@answer),
    'globally unique identifier' => test_zci(@answer),
    'rfc 4122'                   => test_zci(@answer),
);

done_testing;

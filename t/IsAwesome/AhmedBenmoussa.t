#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_ahmed_benmoussa";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(DDG::Goodie::IsAwesome::AhmedBenmoussa)],
    
    'duckduckhack ahmedbenmoussa' => test_zci('AhmedBenmoussa is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack ahmedbenmoussa is awesome' => undef,
);

done_testing;

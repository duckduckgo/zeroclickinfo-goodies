#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "lorem_ipsum";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::LoremIpsum )],
    'lorem ipsssum 3' => undef,
    'lorem dipsum' => undef,
    'lipsum 3' => test_zci(qr/([a-zA-Z. ]+\n\n){2,2}[a-zA-Z. ]+/),
    'lipsum 10' => test_zci(qr/([a-zA-Z. ]+\n\n){9,9}[a-zA-Z. ]+/),
    'lorem ipsum 100233' => test_zci(qr/([a-zA-Z. ]+\n\n){3,3}[a-zA-Z. ]+/),
    
);

done_testing;

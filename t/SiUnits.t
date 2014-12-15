#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'si_base_units';
zci is_cached => 0;

ddg_goodie_test(
    [qw(
        DDG::Goodie::SiUnits
    )],
    'newtons si' => test_zci("", html => "<div style=\"font-size:15px\">Newtons expressed in SI base units: <div style=\"font-size:20px; padding-top:5px;\">kg&#183;m&#183;s<sup>-2</sup></div></div>"),
);

done_testing;
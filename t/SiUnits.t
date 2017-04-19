#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'si_base_units';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::SiUnits
    )],
    "newtons in si base units" => test_zci("",html => qq(<div class="zci--statement">Newtons expressed in SI base units: <div class="zci--unit">kg&#183;m&#183;s<sup>-2</sup></div></div>)),
    "si joules" => test_zci("",html => qq(<div class="zci--statement">Joules expressed in SI base units: <div class="zci--unit">kg&#183;m<sup>2</sup>&#183;s<sup>-2</sup></div>)),
);

done_testing;
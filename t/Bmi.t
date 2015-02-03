#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "bmi";
zci is_cached   => 1;

my $html = '<h3>BMI Calculator</h3>
<div class="unit">
    <a href="#" class="i">Imperial</a> | <a href="#" class="m selected">Metric</a>
</div>
<form id="form_bmi_m">
    <input type="number" min="0" id="height" placeholder="Height in cm"/>
    <input type="number" id="weight" placeholder="Weight"/>
    <input type="submit" value="Calculate"/>
</form>
<form id="form_bmi_i">
    <input type="number" min="0" id="feet" placeholder="Feet"/>
    <input type="number" min="0" id="inches" placeholder="Inches"/>
    <input type="number" id="pounds" placeholder="Pounds"/>
    <input type="submit" value="Calculate"/>
</form>

<div id="div_result">
    
</div>';

ddg_goodie_test(
    [qw(
        DDG::Goodie::Bmi
    )],
    'bmi' => test_zci('null', html => $html),
);

done_testing;

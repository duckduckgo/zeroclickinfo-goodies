#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

my $html = '<i><b>Play <span id="game">2048</span></b></i> <span class="counter"><span class="points">0</span> Points</div>
<div id="2048-area">
    <table class="area" id="area">
        <tr><td></td><td></td><td></td><td></td></tr>
        <tr><td></td><td></td><td></td><td></td></tr>
        <tr><td></td><td></td><td></td><td></td></tr>
        <tr><td></td><td></td><td></td><td></td></tr>
    </table>
</div>';

ddg_goodie_test(
    [qw( DDG::Goodie::2048 )],

    'play 2048' => test_zci(
        answer => "",
        html => $html
    ),

    '2048 online' => undef
);

done_testing;

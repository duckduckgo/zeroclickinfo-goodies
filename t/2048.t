#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

my $html = '<i><b>Play <span id="game">2048</span> <br><br><span id="dimension">4</span> x 4</b></i>

<span class="counter"><span class="points">0</span> Points</span>
<div id="2048-area">
      <table class="area" id="area">
      </table>
</div>';

ddg_goodie_test(
    [qw( DDG::Goodie::2048 )],

    'play 2048' => test_zci(
        'Play 2048',
        html => $html
    ),
    '2048 online' => undef
);

done_testing;

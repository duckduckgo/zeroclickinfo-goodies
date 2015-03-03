#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

my $html = '<div id="2048-area">'.
			'<table class="area" id="area">'.
			'<tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr>'.
			'<tr><td></td><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td></td></tr></table></div>';

ddg_goodie_test(
    [qw( DDG::Goodie::2048 )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'play 2048' => test_zci(html => $html),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    '2048 online' => undef
);

done_testing;

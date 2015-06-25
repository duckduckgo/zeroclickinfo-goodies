#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'percent_error';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::PercentError
	)],
	'%err 41 43' => test_zci('Accepted: 41 Experimental: 43 Error: 4.8780487804878%', html => qq(Accepted: 41 Experimental: 43 Error: <a href="javascript:;" onclick="document.x.q.value='0.0487804878048781';document.x.q.focus();">4.8780487804878%</a>), answer_type => 'percent_error'),
	'percent-error 34.5 35' => test_zci('Accepted: 34.5 Experimental: 35 Error: 1.44927536231884%', html => qq(Accepted: 34.5 Experimental: 35 Error: <a href="javascript:;" onclick="document.x.q.value='0.0144927536231884';document.x.q.focus();">1.44927536231884%</a>), answer_type => 'percent_error'),
    "%-error 2.88 2.82" => test_zci("Accepted: 2.88 Experimental: 2.82 Error: 2.08333333333334%", html => "Accepted: 2.88 Experimental: 2.82 Error: <a href=\"javascript:;\" onclick=\"document.x.q.value='0.0208333333333334';document.x.q.focus();\">2.08333333333334%</a>"),
    "% error 45.12 45.798" => test_zci("Accepted: 45.12 Experimental: 45.798 Error: 1.50265957446809%", html => "Accepted: 45.12 Experimental: 45.798 Error: <a href=\"javascript:;\" onclick=\"document.x.q.value='0.0150265957446809';document.x.q.focus();\">1.50265957446809%</a>"),
    "percent err -45.12 -50.00" => test_zci("Accepted: -45.12 Experimental: -50.00 Error: 10.8156028368794%", html => "Accepted: -45.12 Experimental: -50.00 Error: <a href=\"javascript:;\" onclick=\"document.x.q.value='0.108156028368794';document.x.q.focus();\">10.8156028368794%</a>"),
    "percent-error 1;1" => test_zci("Accepted: 1 Experimental: 1 Error: 0%", html => "Accepted: 1 Experimental: 1 Error: <a href=\"javascript:;\" onclick=\"document.x.q.value='0';document.x.q.focus();\">0%</a>"),
);

done_testing;


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
);

done_testing;


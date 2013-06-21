#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'helpline';

ddg_goodie_test(
	[qw(
		DDG::Goodie::HelpLine
	)],
	'suicide' => test_zci(qr/24 Hour Suicide Hotline: [\d\-){7}]/),
);

done_testing;


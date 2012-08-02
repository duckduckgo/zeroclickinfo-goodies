#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'isvalid';
zci is_cached   => 1;

ddg_goodie_test(
	[qw(DDG::Goodie::IsValid::JSON)],
	'is valid json {"test":"lol"}' => test_zci('Your JSON is valid!'),
);

ddg_goodie_test(
	[qw(DDG::Goodie::IsValid::JSON)],
	'is valid json {"test" "lol"}' => test_zci('Your JSON is invalid!'),
);

ddg_goodie_test(
	[qw(DDG::Goodie::IsValid::XML)],
	'is valid xml <test></test>' => test_zci('Your XML is valid!'),
);

ddg_goodie_test(
	[qw(DDG::Goodie::IsValid::XML)],
	'is valid xml <test>lol' => test_zci('Your XML is invalid!'),
);

done_testing;

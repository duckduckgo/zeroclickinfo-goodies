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
	'is valid json {"test" "lol"}' => test_zci('Your JSON is invalid: <pre style="font-size:12px;display:inline;">\':\' expected, at character offset 8 (before ""lol"}")</pre>')
);

ddg_goodie_test(
	[qw(DDG::Goodie::IsValid::XML)],
	'is valid xml <test></test>' => test_zci('Your XML is valid!'),
);

ddg_goodie_test(
	[qw(DDG::Goodie::IsValid::XML)],
	'is valid xml <test>lol' => test_zci('Your XML is invalid: <pre style="font-size:12px;display:inline;">no element found at line 1, column 9, byte 9</pre>')
);

done_testing;

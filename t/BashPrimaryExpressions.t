use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'bashprimaryexpressions';

ddg_goodie_test(
	[
		'DDG::Goodie::BashPrimaryExpressions'
	],
	"bash [ -a b ]" => test_zci(
		"[ -a b ] - True if b exists"
	),
);

done_testing;
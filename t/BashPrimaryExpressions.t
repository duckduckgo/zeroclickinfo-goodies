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
	    "True if b exists",
	    html => qr/.+/,
	    heading => "[ -a b ] (Bash)",
	),
	'bash [[ "abc" < "cba" ]]' => test_zci(
	    'True if "abc" string-sorts before "cba" in the current locale',
	    html => qr/.+/,
	    heading => '[[ "abc" < "cba" ]] (Bash)',
	),
	'bash [ 2 -gt 1 ]' => test_zci(
	    'True if 2 is numerically greater than 1',
	    html => qr/.+/,
	    heading => '[ 2 -gt 1 ] (Bash)',
	),
	'bash [ ! hello == world ]' => test_zci(
	    'False if the strings hello and world are equal',
	    html => qr/.+/,
	    heading => '[ ! hello == world ] (Bash)',
	),
	'bash [[ /tmp/hello -nt /etc/test ]]' => test_zci (
	    'True if /tmp/hello has been changed more recently than /etc/test or if /tmp/hello exists and /etc/test does not',
	    html => qr/.+/,
	    heading => '[[ /tmp/hello -nt /etc/test ]] (Bash)',
	),
    'bash [ -z hello ]' => test_zci(
        "True if the length of 'hello' is zero", 
        html => qr/.+/,
	heading => '[ -z hello ] (Bash)',
    ),
    'bash if [[ "abc" -lt "cba" ]]' => test_zci(
        'True if "abc" is numerically less than "cba"', 
        html => qr/.+/,
	heading => '[[ "abc" -lt "cba" ]] (Bash)',
    ),
);

done_testing;

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'expression_description';
zci is_cached   => 1;

ddg_goodie_test(
    [
     'DDG::Goodie::BashPrimaryExpressions'
    ],
    "bash [ -a b ]" => test_zci(
	qr/.+ true if b exists./,
	html => qr/.+/,
	heading => "[ -a b ] (Bash)",
    ),
    'bash [[ "abc" < "cba" ]]' => test_zci(
	qr/.+ true if "abc" string-sorts before "cba" in the current locale./,
	html => qr/.+/,
	heading => '[[ &quot;abc&quot; &lt; &quot;cba&quot; ]] (Bash)',
    ),
    'bash [ 2 -gt 1 ]' => test_zci(
	qr/.+ true if 2 is numerically greater than 1./,
	html => qr/.+/,
	heading => '[ 2 -gt 1 ] (Bash)',
    ),
    'bash [ ! hello == world ]' => test_zci(
	qr/.+ false if the strings hello and world are equal./,
	html => qr/.+/,
	heading => '[ ! hello == world ] (Bash)',
    ),
    'bash [[ /tmp/hello -nt /etc/test ]]' => test_zci (
	qr#.+ true if /tmp/hello has been changed more recently than /etc/test or if /tmp/hello exists and /etc/test does not.#,
	html => qr/.+/,
	heading => '[[ /tmp/hello -nt /etc/test ]] (Bash)',
    ),
    'bash [ -z hello ]' => test_zci(
        qr/.+ true if the length of 'hello' is zero./,
        html => qr/.+/,
	heading => '[ -z hello ] (Bash)',
    ),
    'bash if [[ "abc" -lt "cba" ]]' => test_zci(
        qr/.+ true if "abc" is numerically less than "cba"./,
        html => qr/.+/,
	heading => '[[ &quot;abc&quot; -lt &quot;cba&quot; ]] (Bash)',
    ),
    'bash if [ 1 -lt 2 -a 1 -lt 3 ]' => undef,
    'bash if [ ![ 1 -lt 2 ] ]' => undef,
);

done_testing;

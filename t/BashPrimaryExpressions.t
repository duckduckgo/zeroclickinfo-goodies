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
		"[ -a b ] - True if b exists",
		html => "<code>[ -a b ]</code> - True if <code>b</code> exists"
	),
	'bash [[ "abc" < "cba" ]]' => test_zci(
		'[[ "abc" < "cba" ]] - True if "abc" string-sorts before "cba" in the current locale',
		html => '<code>[[ &quot;abc&quot; &lt; &quot;cba&quot; ]]</code> - True if <code>&quot;abc&quot;</code> string-sorts before <code>&quot;cba&quot;</code> in the current locale'
	),
	'bash [ 2 -gt 1 ]' => test_zci(
		'[ 2 -gt 1 ] - True if 2 is numerically greater than 1',
		html => "<code>[ 2 -gt 1 ]</code> - True if <code>2</code> is numerically greater than <code>1</code>"
	),
	'bash [ ! hello == world ]' => test_zci(
		'[ ! hello == world ] - False if the strings hello and world are equal',
		html => "<code>[ ! hello == world ]</code> - False if the strings <code>hello</code> and <code>world</code> are equal"
	),
	'bash [[ /tmp/hello -nt /etc/test ]]' => test_zci (
		'[[ /tmp/hello -nt /etc/test ]] - True if /tmp/hello has been changed more recently than /etc/test or if /tmp/hello exists and /etc/test does not',
		html => "<code>[[ /tmp/hello -nt /etc/test ]]</code> - True if <code>/tmp/hello</code> has been changed more recently than <code>/etc/test</code> or if <code>/tmp/hello</code> exists and <code>/etc/test</code> does not"
	),
    'bash [ -z hello ]' => test_zci(
        "[ -z hello ] - True if the length of 'hello' is zero", 
        html => '<code>[ -z hello ]</code> - True if the length of &#39;<code>hello</code>&#39; is zero'
    ),
    'bash if [[ "abc" -lt "cba" ]]' => test_zci(
        '[[ "abc" -lt "cba" ]] - True if "abc" is numerically less than "cba"', 
        html => '<code>[[ &quot;abc&quot; -lt &quot;cba&quot; ]]</code> - True if <code>&quot;abc&quot;</code> is numerically less than <code>&quot;cba&quot;</code>'
    ),
);

done_testing;

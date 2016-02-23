#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "security_addons";
zci is_cached   => 1;
my $list_data = [
    { browser => "Firefox", link => "https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/" },
    { browser => "Safari", link => "https://extensions.apple.com/?category=security" },
    { browser => "Google Chrome", link => "https://chrome.google.com/webstore/search/anonymous" },
    { browser => "Opera", link => "https://addons.opera.com/en/extensions/category/privacy-security/" },
    { browser => "Vivaldi", link => "https://chrome.google.com/webstore/search/anonymous" }
];
my $plaintext="";
foreach(@$list_data){
    $plaintext.=$_->{browser};
    $plaintext.=": ";
    $plaintext.=$_->{link};
    $plaintext.="\n";
}
my @structured_answer = {
    id => "security_addons",
    name => "software",
    data => {
        title => "Security Addons",
        list => $list_data
    },
    meta => {},
    templates => {
        group => 'list',
        options => {
            list_content => "DDH.security_addons.list_content"
        },
    },
};
my $answer = test_zci($plaintext,structured_answer=>@structured_answer);
ddg_goodie_test(
	[
		'DDG::Goodie::SecurityAddons'
	],

    'privacy extensions' => $answer,
    'privacy extension' => $answer,
    'privacy addons' => $answer,
    'privacy addon' => $answer,

    'privacy extensions firefox' => $answer,
    'firefox privacy extension' => $answer,

    'google chrome privacy addons' => $answer,
    'opera privacy addon' => $answer,
    'safari privacy extensions' => $answer,

    'ie privacy extension' => undef,
    'internet explorer privacy addons' => undef,
);

done_testing;

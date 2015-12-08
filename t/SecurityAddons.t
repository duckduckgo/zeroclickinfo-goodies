#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "security_addons";
zci is_cached   => 1;
my $plaintext="Firefox: https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/";
   $plaintext.="\nSafari: https://extensions.apple.com/?category=security";
   $plaintext.="\nGoogle Chrome: https://chrome.google.com/webstore/search/anonymous";
   $plaintext.="\nOpera: https://addons.opera.com/en/extensions/category/privacy-security/?order=popular&language=en";
my @record_data = [
    ['Firefox',"https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/"],
    ['Safari',"https://extensions.apple.com/?category=security"],
    ['Google Chrome',"https://chrome.google.com/webstore/search/anonymous"],
    ['Opera',"https://addons.opera.com/en/extensions/category/privacy-security/?order=popular&language=en"]
];
my @record_data_firefox = [
    ['Firefox',"https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/","selected"],
    ['Safari',"https://extensions.apple.com/?category=security"],
    ['Google Chrome',"https://chrome.google.com/webstore/search/anonymous"],
    ['Opera',"https://addons.opera.com/en/extensions/category/privacy-security/?order=popular&language=en"]
];
my @record_data_safari = [
    ['Firefox',"https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/"],
    ['Safari',"https://extensions.apple.com/?category=security","selected"],
    ['Google Chrome',"https://chrome.google.com/webstore/search/anonymous"],
    ['Opera',"https://addons.opera.com/en/extensions/category/privacy-security/?order=popular&language=en"]
];
my @record_data_chrome = [
    ['Firefox',"https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/"],
    ['Safari',"https://extensions.apple.com/?category=security"],
    ['Google Chrome',"https://chrome.google.com/webstore/search/anonymous","selected"],
    ['Opera',"https://addons.opera.com/en/extensions/category/privacy-security/?order=popular&language=en"]
];
my @record_data_opera = [
    ['Firefox',"https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/"],
    ['Safari',"https://extensions.apple.com/?category=security"],
    ['Google Chrome',"https://chrome.google.com/webstore/search/anonymous"],
    ['Opera',"https://addons.opera.com/en/extensions/category/privacy-security/?order=popular&language=en","selected"]
];
sub new_answer{
    return {
        id => "security_addons",
        name => "software",
        data => {
            title => "Security Addons",
            record_data => $_[0]
        },
        meta => {},
        templates => {      
            group => 'list',
            options => {
                content => "DDH.security_addons.record"
            },
        },
    };
}
my $answer = test_zci($plaintext,structured_answer=>new_answer(@record_data));
my $answer_firefox = test_zci($plaintext,structured_answer=>new_answer(@record_data_firefox));
my $answer_safari = test_zci($plaintext,structured_answer=>new_answer(@record_data_safari));
my $answer_chrome = test_zci($plaintext,structured_answer=>new_answer(@record_data_chrome));
my $answer_opera = test_zci($plaintext,structured_answer=>new_answer(@record_data_opera));
ddg_goodie_test(
	[
		'DDG::Goodie::SecurityAddons'
	],
    
    'privacy extensions' => $answer,
    'privacy extension' => $answer,
    'privacy addons' => $answer,
    'privacy addon' => $answer,
    
    'privacy extensions firefox' => $answer_firefox,
    'firefox privacy extension' => $answer_firefox,
    
    'google chrome privacy addons' => $answer_chrome,
    'opera privacy addon' => $answer_opera,
    'safari privacy extensions' => $answer_safari,
    
    'ie privacy extension' => undef,
    'internet explorer privacy addons' => undef,
);

done_testing;

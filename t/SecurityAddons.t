#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "security_addons";
zci is_cached   => 1;
my $plaintext="Firefox: https://addons.mozilla.org/en-US/firefox/tag/anonymous";
   $plaintext.="\nSafari: https://extensions.apple.com/?q=anonymous";
   $plaintext.="\nGoogle Chrome: https://chrome.google.com/webstore/search/anonymous";
   $plaintext.="\nOpera: https://addons.opera.com/en/search/?query=anonymous&type=extensions";
my @record_data = {
    'Firefox' => "https://addons.mozilla.org/en-US/firefox/tag/anonymous",
    'Safari' => "https://extensions.apple.com/?q=anonymous",
    'Google Chrome' => "https://chrome.google.com/webstore/search/anonymous",
    'Opera' => "https://addons.opera.com/en/search/?query=anonymous&type=extensions"
};
my @record_keys = ["Firefox", "Safari", "Google Chrome", "Opera"];
my $structured_answer = {
    id => "security_addons",
    name => "software",
    data => {
        title => "Security Addons",
        record_data => @record_data
    },
    meta => {},
    templates => {      
        group => 'list',
        options => {
            content => "record"
        },
    },
};
my $answer = test_zci($plaintext,structured_answer=>$structured_answer);
ddg_goodie_test(
	[
		'DDG::Goodie::SecurityAddons'
	],
    
    'how to browse the web anonymously' => $answer,
    'search privately' => $answer,
    'search anonymously' => $answer,
    'how to browse the web privately' => $answer,
    
    'how to browse the web privately firefox' => $answer,
    'firefox how to browse the web privately' => $answer,
    
    'google chrome how to browse the web privately' => $answer,
    'opera how to browse the web privately' => $answer,
    'safari how to browse the web privately' => $answer,
    
    'ie how to browse the web privately' => undef,
    'internet explorer how to browse the web privately' => undef,
);

done_testing;

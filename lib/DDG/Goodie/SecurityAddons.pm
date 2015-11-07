package DDG::Goodie::SecurityAddons;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "security_addons";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "Security Addons";
description "Shows addons for popular browsers regarding anonymity";
primary_example_queries "how to browse the web anonymously", "search privately", "search anonymously", "how to browse the web privately";
secondary_example_queries "firefox how to browse the web anonymously";
category "software";
topics "computing";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SecurityAddons/lights0123/lights0123.pm";
attribution github => ["lights0123", "lights0123"],
            web => ["http://lights0123.com", "lights0123"];

# Triggers
triggers startend => "privacy extensions", "privacy addons", "privacy extension", "privacy addon"; #if the keywords are at the beginning or end, then trigger

my @triggerwords = ("firefox", "safari", "google chrome", "opera", "chrome");
my $plaintext="Firefox: https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/";
$plaintext.="\nSafari: https://extensions.apple.com/?category=security";
$plaintext.="\nGoogle Chrome: https://chrome.google.com/webstore/search/anonymous";
$plaintext.="\nOpera: https://addons.opera.com/en/extensions/category/privacy-security/?order=popular&language=en";
my @record_data = {
    'Firefox' => "https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/",
    'Safari' => "https://extensions.apple.com/?category=security",
    'Google Chrome' => "https://chrome.google.com/webstore/search/anonymous",
    'Opera' => "https://addons.opera.com/en/extensions/category/privacy-security/?order=popular&language=en"
};
my @record_keys = ["Firefox", "Safari", "Google Chrome", "Opera"];
my @structured_answer = {
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

handle remainder => sub {
    if($_){
        my $remainder = $_;
        return unless grep { $remainder eq $_ } @triggerwords;
    }
    
	return $plaintext,
    structured_answer => @structured_answer;
};

1;

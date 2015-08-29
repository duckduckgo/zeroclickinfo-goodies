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
triggers startend => "how to browse the web anonymously", "search privately", "search anonymously", "how to browse the web privately"; #if the keywords are at the beginning or end, then trigger

# Handle statement
handle remainder => sub {
    
    if (!($_ eq "firefox" || $_ eq "safari" || $_ eq "google chrome" || $_ eq "opera" || $_ eq "chrome" || $_ eq "")) { #if one of the keywords is not found, then exit
        return;
    }
    
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
	return $plaintext,
    structured_answer => {
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
};

1;

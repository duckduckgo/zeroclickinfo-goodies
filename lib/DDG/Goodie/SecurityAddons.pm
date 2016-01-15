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
primary_example_queries "privacy extensions", "privacy extension", "privacy addons", "privacy addon";
secondary_example_queries "firefox privacy addon";
category "software";
topics "computing";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SecurityAddons/lights0123/lights0123.pm";
attribution github => ["lights0123", "lights0123"],
            web => ["http://lights0123.com", "lights0123"];

# Triggers
triggers startend => "privacy extensions", "privacy addons", "privacy extension", "privacy addon"; #if the keywords are at the beginning or end, then trigger

my @triggerwords = ("firefox", "safari", "google chrome", "opera", "chrome");
my $list_data = [
    { browser => "Firefox", link => "https://addons.mozilla.org/en-US/firefox/collections/mozilla/privacy/" },
    { browser => "Safari", link => "https://extensions.apple.com/?category=security" },
    { browser => "Google Chrome", link => "https://chrome.google.com/webstore/search/anonymous" },
    { browser => "Opera", link => "https://addons.opera.com/en/extensions/category/privacy-security/" }
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

handle remainder => sub {
    if($_){
        my $remainder = $_;
        return unless grep { $remainder eq $_ } @triggerwords;
    }
    
	return $plaintext,
    structured_answer => @structured_answer;
};

1;
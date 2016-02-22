package DDG::Goodie::SecurityAddons;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "security_addons";
zci is_cached   => 1;

# Triggers
triggers startend => "privacy extensions", "privacy addons", "privacy extension", "privacy addon"; #if the keywords are at the beginning or end, then trigger

my @triggerwords = ("firefox", "safari", "google chrome", "opera", "chrome", "vivaldi");
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

handle remainder => sub {
    if($_){
        my $remainder = $_;
        return unless grep { $remainder eq $_ } @triggerwords;
    }
    
	return $plaintext,
    structured_answer => @structured_answer;
};

1;
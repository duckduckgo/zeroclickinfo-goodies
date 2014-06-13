package DDG::Goodie::URLEncode;
# ABSTRACT: Displays the percent-encoded url.

use DDG::Goodie;
use URI::Encode qw(uri_encode);
use warnings;
use strict;

zci answer_type => 'encoded_url';
primary_example_queries 'url encode http://nospaces.duckduckgo.com/hook em horns' , 'encode url xkcd.com/a webcomic of%romance+math+sarcasm+language';
secondary_example_queries 'http://arstechnica.com/spaces after end  url encode', 'apple.com/mac encode URL';
description 'Displays the percent-encoded url';
name 'URLEncode';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/URLEncode.pm';
category 'computing_tools';
topics 'programming', 'web_design';
attribution twitter => ['nshanmugham', 'Nishanth Shanmugham'],
            web => ['http://nishanths.github.io', 'Nishanth Shanmugham'],
            github => ['https://github.com/nishanths', 'Nishanth Shanmugham'];

triggers startend => 'url encode', 'encode url';
my $url = "https://en.wikipedia.org/wiki/Url_encoding";
handle remainder => sub {
	my $holder = uri_encode($_);
	return "Encoded URL: $holder", html => "<div>Encoded URL: $holder</div><div>More at <a href=\"$url\">Wikipedia</a></div>";
};
1;

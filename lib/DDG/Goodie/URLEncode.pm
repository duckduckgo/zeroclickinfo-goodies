package DDG::Goodie::URLEncode;
# ABSTRACT: Displays the percent-encoded url.

use DDG::Goodie;
use URI::Escape::XS qw(encodeURIComponent);
use warnings;
use strict;

triggers startend   =>      'url encode', 'encode url', 'urlencode', 'encodeurl', 'url escape', 'escape url', 'urlescape', 'escapeurl';

primary_example_queries     'url encode https://duckduckgo.com/' , 'encode url xkcd.com/blag';
secondary_example_queries   'http://arstechnica.com/ url escape', 'apple.com/mac/ escape url';

zci answer_type =>          'encoded_url';
zci is_cached   =>          1;

name                        'URLEncode';
description                 'Displays the percent-encoded url';
code_url                    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/URLEncode.pm';
category                    'computing_tools';
topics                      'programming', 'web_design';
attribution twitter =>      ['nshanmugham', 'Nishanth Shanmugham'],
            web     =>      ['http://nishanths.github.io', 'Nishanth Shanmugham'],
            github  =>      ['https://github.com/nishanths', 'Nishanth Shanmugham'];


handle remainder => sub {
    my $encoded_url = encodeURIComponent($_);

    my $text = "Percent-encoded URL: $encoded_url";
    my $html = qq(<div class="zci--urlencode"><div class="text--secondary mini-title">Percent-encoded URL: </div><div class="text--primary url_encoded">$encoded_url</div></div>);

    return $text, html => $html;
};

1;

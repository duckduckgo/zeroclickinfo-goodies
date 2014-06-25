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

name                        'URLEncode';
description                 'Displays the percent-encoded url';
code_url                    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/URLEncode.pm';
category                    'computing_tools';
topics                      'programming', 'web_design';
attribution twitter =>      ['nshanmugham', 'Nishanth Shanmugham'],
            web     =>      ['http://nishanths.github.io', 'Nishanth Shanmugham'],
            github  =>      ['https://github.com/nishanths', 'Nishanth Shanmugham'];


my $css = share("style.css")->slurp();
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
};

handle remainder => sub {
    my $encoded_url = encodeURIComponent($_);

    my $text = "Percent-encoded URL: $encoded_url";
    my $html = qq(<div class="zci--urlencode"><span class="text--secondary">Percent-encoded URL: </span><span class="text--primary">$encoded_url</span></div>);
    $html = append_css($html);

    return $text, html => $html;
};

1;

package DDG::Goodie::URLDecode;
# ABSTRACT: Displays the decoded URL for a percent coded uri

use DDG::Goodie;
use URI::Escape::XS qw(decodeURIComponent);
use warnings;
use strict;

triggers startend   =>      'url decode', 'decode url', 'urldecode', 'decodeurl', 'url unescape', 'unescape url', 'urlunescape', 'unescapeurl';

primary_example_queries     'url decode https%3A%2F%2Fduckduckgo.com%2F' , 'decode url xkcd.com%2Fblag';
secondary_example_queries   'http%3A%2F%2Farstechnica.com%2F url unescape', 'linux.com%2Ftour%2F unescape url';

zci answer_type =>          'decoded_url';

name                        'URLDecode';
description                 'Displays the uri from a percent encoded url';
code_url                    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/URLDecode.pm';
category                    'computing_tools';
topics                      'programming', 'web_design';


my $css = share("style.css")->slurp();
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
};

handle remainder => sub {
    return unless /\+|%[0-9a-fA-F]{2}/;
    my $decoded_url = decodeURIComponent($_);

    my $text = "URL: $decoded_url";
    my $html = '<div class="zci--urldecode"><span class="text--secondary">URL: </span><span class="text--primary">'.html_enc($decoded_url).'</span></div>';

    return $text, html => append_css($html);
};

1;

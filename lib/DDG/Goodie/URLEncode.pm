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
            github  =>      ['nishanths', 'Nishanth Shanmugham'];


handle remainder => sub {
    my $in = $_;

    return unless $in;

    my $encoded_url = encodeURIComponent($in);

    my $text = "Percent-encoded URL: $encoded_url";

    return $text,
      structured_answer => {
        input     => [html_enc($in)],
        operation => 'URL percent-encode',
        result    => html_enc($encoded_url),
      };
};

1;

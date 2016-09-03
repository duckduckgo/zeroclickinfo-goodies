package DDG::Goodie::URLEncode;
# ABSTRACT: Displays the percent-encoded url.

use DDG::Goodie;
use URI::Escape::XS qw(uri_escape);
use warnings;
use strict;

triggers startend   =>      'url encode', 'encode url', 'urlencode', 'encodeurl', 'url escape', 'escape url', 'urlescape', 'escapeurl',
                            'uri encode', 'encode uri', 'uriencode', 'encodeuri', 'uri escape', 'escape uri', 'uriescape', 'escapeuri';

zci answer_type =>          'encoded_url';
zci is_cached   =>          1;

handle remainder => sub {
    my $in = $_;

    return unless $in;

    ## URI::Escape::XS::uri_escape expects a byte string, so downgrade our string
    ## https://metacpan.org/pod/URI::Escape::XS#uri_escape
    utf8::downgrade($in);

    my $encoded_url = uri_escape($in);

    my $text = "Percent-encoded URL: $encoded_url";
    my $subtitle = "URL percent-encode: $in";

    return $text, structured_answer => {
        data => {
            title => $encoded_url,
            subtitle => $subtitle
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    };
};

1;

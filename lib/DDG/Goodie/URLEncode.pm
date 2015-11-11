package DDG::Goodie::URLEncode;
# ABSTRACT: Displays the percent-encoded url.

use DDG::Goodie;
use URI::Escape::XS qw(encodeURIComponent);
use warnings;
use strict;

triggers startend   =>      'url encode', 'encode url', 'urlencode', 'encodeurl', 'url escape', 'escape url', 'urlescape', 'escapeurl';

zci answer_type =>          'encoded_url';
zci is_cached   =>          1;

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

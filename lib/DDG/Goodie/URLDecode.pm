package DDG::Goodie::URLDecode;
# ABSTRACT: Displays the decoded URL for a percent encoded uri

use DDG::Goodie;
use URI::Escape::XS qw(uri_unescape);
use warnings;
use strict;

my $trigger_words = qr#urlunescape|unescapeurl|(unescape url)|decodeurl|(decode url)|urldecode|(url decode)|(url unescape)#;

triggers query_raw => qr#%[0-9A-Fa-f]{2}#;

zci answer_type => 'decoded_url';
zci is_cached   => 1;

handle query_raw => sub {
    # unless trigger words exist, only answer when we have a single word
    unless (m/$trigger_words/) {
        return if m/\s+/;
    }
    #remove triggers and trim
    s/(^$trigger_words)|($trigger_words$)//i;
    s/(^\s+)|(\s+$)//;

    my $in      = $_;
    my $decoded = uri_unescape($in);

    if ($decoded =~ /^\s+$/) {
        $decoded =~ s/\r/CReturn/;
        $decoded =~ s/\n/Newline/;
        $decoded =~ s/\t/Tab/;
        $decoded =~ s/\s/Space/;
    }

    my $text = "URL Decoded: $decoded";
    my $subtitle = "URL decode: $in";

    return $text, structured_answer => {
        data => {
            title => html_enc($decoded),
            subtitle => html_enc($subtitle)
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    };
};

1;

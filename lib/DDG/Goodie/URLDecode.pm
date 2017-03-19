package DDG::Goodie::URLDecode;
# ABSTRACT: Displays the decoded URL for a percent encoded uri

use DDG::Goodie;
use URI::Escape::XS qw(uri_unescape);
use warnings;
use strict;
my $trigger_words = qr#ur[li]unescape|unescapeur[li]|(unescape ur[li])|decodeur[li]|(decode ur[li])|ur[li]decode|(ur[li] decode)|(ur[li] unescape)#i;

triggers query_raw => qr#%[0-9A-Fa-f]{2}#;

zci answer_type => 'decoded_url';
zci is_cached   => 1;

handle query_raw => sub {
    # unless trigger words exist, only answer when we have a single word
    unless (m/$trigger_words/) {
        return if m/\s+/;
    }
    #remove triggers and trim
    s/(^$trigger_words)|($trigger_words$)//;
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
            title => $decoded,
            subtitle => $subtitle
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    };
};

1;

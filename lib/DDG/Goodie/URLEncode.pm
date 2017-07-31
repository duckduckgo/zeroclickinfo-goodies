package DDG::Goodie::URLEncode;
# ABSTRACT: Displays the percent-encoded url.

use DDG::Goodie;
use URI::Escape::XS qw(uri_escape);
use warnings;
use strict;

zci answer_type =>          'encoded_url';
zci is_cached   =>          1;

triggers startend => share('triggers.txt')->slurp;

handle remainder => sub {

    # Return unless the remainder is empty or contains online or tool
    return unless ( $_ =~ /(^$|online|tool|utility)/i );
    
    return '',
        structured_answer => {
            data => {
                title => 'URL Encoder/Decoder',
                subtitle => 'Enter URL below, then click the button to encode it'
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.urlencode.content'
                }
            }
        };
};

1;

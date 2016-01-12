package DDG::Goodie::Bin2Unicode;
# ABSTRACT: Convert binary to unicode 

use DDG::Goodie;
use strict;

no warnings 'non_unicode';

zci answer_type => 'bin2unicode';
zci is_cached   => 1;

triggers query => qr{^([01\s]{8,})(?:(?:to\s+)?(?:unicode|text|ascii))?$};

handle matches => sub {

    my $bin = my $unicode = shift;
    $unicode =~ s/([01]+)/chr(oct("0b$1"))/ge;
    return "Binary '$bin' converted to unicode is '$unicode'",,
        structured_answer => {
            id => 'bin2unicode',
            name => 'Answer',
            data => {
              title => $unicode,
              subtitle => "Input: $bin",
            },

            templates => {
                group => 'text',
                moreAt => 0
            }
        };
};

1;

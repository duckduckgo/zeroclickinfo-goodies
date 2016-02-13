package DDG::Goodie::Bin2Unicode;

# ABSTRACT: Convert binary to unicode

use DDG::Goodie;
use strict;

no warnings qw'non_unicode overflow portable';

zci answer_type => 'bin2unicode';
zci is_cached   => 1;

triggers query => qr{^([01\s]{8,})(?:\s+(?:to\s+)?(?:unicode|text|ascii))?$};

my $MAX_CODE_PT = 1114111;

handle matches => sub {
    my $q = $_; # orginal query
    my $bin_string = shift @_; # captured binary string

    my $want_ascii = $q =~ /\bascii\b/;

    my @bins = $bin_string =~ /([01]+|\s+)/g;
    my $str;
    for my $b (@bins){
        if($b =~ /^[01]+$/){
            return if length($b) % 8;
            # Overflow/non-portable warnings expected
            my $i = oct("0b$b");
            # Assume ascii if out of range or explicitly requested.
            # This will work for characters all in the same string
            # but will not print the right non-ascii characters *if*
            # they are also in the string.
            $str .= (($i > $MAX_CODE_PT) || $want_ascii)
                ? pack('B*', $b)
                : chr($i);
        }
        else {
            $str .= $b;
        }
    }

    return "Binary '$bin_string' converted to " . $want_ascii ? 'ascii' : 'unicode' . " is '$str'",
        structured_answer => {
            id => 'bin2unicode',
            name => 'Answer',
            data => {
              title => $str,
              subtitle => "Input: $q",
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        };
};

1;

package DDG::Goodie::Base;
use 5.010;
use strict;
use warnings;
use Math::Int2Base qw/int2base/;
use DDG::Goodie;

triggers any => qw/hex hexadecimal octal oct binary base/;

handle query_clean => sub {
    return unless  /^([0-9]+)\s*(?:(?:in|as)\s+)?(hex|hexadecimal|octal|oct|binary|base\s*([0-9]+))$/;
    my $number = $1;
    my $base = $3;
    unless (defined $base) {
        given ($2) {
            when ('hex'        ) { $base = 16 }
            when ('hexadecimal') { $base = 16 }
            when ('oct'        ) { $base =  8 }
            when ('octal'      ) { $base =  8 }
            when ('binary'     ) { $base =  2 }
        }
    }
    return if $base < 2 || $base > 36;
    my $based = int2base($number, $base);
    return "$number in base $base is $based";
};

1;

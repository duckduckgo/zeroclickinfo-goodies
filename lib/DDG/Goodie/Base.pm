package DDG::Goodie::Base;
use strict;
use warnings;
use Math::Int2Base qw/int2base/;
use DDG::Goodie;

triggers query_clean => qr/^[0-9]+\s*(?:in|as)\s+(?:hex|octal|oct|binary|base\s*[0-9]+)$/;

handle query_clean => sub {
    my ($number, undef, @rest) = split ' ', $_;
    my $base = $rest[0] eq 'hex' ? 16
            : ($rest[0] eq 'octal' || $rest[0] eq 'oct') ?  8
            : $rest[0] eq 'binary' ? 2
            : $rest[1];
    return if $base < 2 || $base > 36;
    my $based = int2base($number, $base);
    return "$number in base $base is $based";
};

1;

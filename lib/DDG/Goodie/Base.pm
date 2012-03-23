package DDG::Goodie::Base;
use 5.010;
use strict;
use warnings;
use Math::Int2Base qw/int2base/;
use DDG::Goodie;

triggers any => qw/hex hexadecimal octal oct binary base/;
zci answer_type => "conversion";
zci is_cached => 1;
my %base_map = (
    hex         => 16,
    hexadecimal => 16,
    oct         =>  8,
    octal       =>  8,
    binary      =>  2,
);

handle query_clean => sub {
    return unless  /^([0-9]+)\s*(?:(?:in|as)\s+)?(hex|hexadecimal|octal|oct|binary|base\s*([0-9]+))$/;
    my $number = $1;
    my $base = $3 // $base_map{$2};
    return if $base < 2 || $base > 36;
    my $based = int2base($number, $base);
    return "$number in base $base is $based";
};

1;

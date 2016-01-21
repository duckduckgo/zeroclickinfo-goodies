package DDG::Goodie::Base;
# ABSTRACT: convert numbers between arbitrary bases

use strict;
use DDG::Goodie;

use Math::Int2Base qw/int2base/;
use 5.010;

zci answer_type => "conversion";
zci is_cached => 1;

use bigint;

my %base_map = (
    hex         => 16,
    hexadecimal => 16,
    oct         =>  8,
    octal       =>  8,
    binary      =>  2,
);
my $map_keys = join '|', keys %base_map;

triggers any => 'base', keys %base_map;

handle query_clean => sub {
    return unless /^(?<num>[0-9]+)\s*(?:(?:in|as|to)\s+)?(?:(?<bt>$map_keys)|(?:base\s*(?<bn>[0-9]+)))$/;
    my $number = $+{'num'};
    my $base = $+{'bn'} // $base_map{$+{bt}};
    return if $base < 2 || $base > 36;
    my $based = int2base($number, $base);
    return "$number in base $base is $based",
      structured_answer => {
        input     => ["$number"],
        operation => 'Decimal to base ' . $base,
        result    => $based
    };
};

1;

package DDG::Goodie::Base;
# ABSTRACT: convert numbers between arbitrary bases

use strict;
use DDG::Goodie;

use Math::Int2Base qw(int2base base2int);
use 5.010;
use bigint;

my %base_map = (
    hex         => 16,
    hexadecimal => 16,
    oct         =>  8,
    octal       =>  8,
    binary      =>  2,
    dec         => 10,
    decimal     => 10
);
my $map_keys = join '|', keys %base_map;

my %prefix_map = (
    '0b'          => 2,
    '0x'          => 16
);
my $prefix_keys = join '|', keys %prefix_map;

triggers any => 'base', keys %base_map;

zci answer_type => "conversion";
zci is_cached => 1;

primary_example_queries '255 in hex', '0xFF to binary', '44 in base 9 to base 3';
secondary_example_queries '255 in base 16', '42 in binary';
description 'convert numbers between arbitrary bases';
name 'Base';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Base.pm';
category 'conversions';
topics 'math';
attribution web => [ 'http://perlgeek.de/blog-en', 'Moritz Lenz' ],
            github => [ 'http://github.com/moritz', 'Moritz Lenz'];


handle query_clean => sub {
    return unless /^(?<la>$prefix_keys)?(?<inp>[0-9A-Za-z]+)\s*((?:(?:in|as)\s+)?(?:(?<lt>$map_keys)|(?:base\s*(?<ln>[0-9]+)))\s+)?(?:(?:in|as|to)\s+)?(?:(?<rt>$map_keys)|(?:base\s*(?<rn>[0-9]+)))$/;
    my $input = uc $+{'inp'}; # uc is necessary as Int2Base doesnt support lowercase
    my $from_base = 10;
    if (defined $+{'la'}) {
        return if (defined $+{'ln'} || defined $+{'lt'}); #to avoid input like '0xFF in binary' 
        $from_base = $prefix_map{$+{'la'}};
    } elsif (defined $+{'ln'}) {
        $from_base = $+{'ln'};
    } elsif (defined $+{'lt'}) {
        $from_base = $base_map{$+{'lt'}};
    }
    my $to_base = $+{'rn'} // $base_map{$+{'rt'}};
    return if $to_base < 2 || $to_base > 36 || $from_base < 2 || $from_base > 36;
    my $output;
    eval { $output = convert_base($input, $from_base, $to_base) }; return if $@;
    
    return "$input in base $to_base is $output",
      structured_answer => {
        input     => ["$input"],
        operation => "From base $from_base to base $to_base",
        result    => $output
      };
};

sub convert_base {
    my ($num, $from, $to) = @_;
    return int2base( base2int($num, $from), $to); 
}

1;

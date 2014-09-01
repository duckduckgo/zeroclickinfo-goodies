package DDG::Goodie::Base;
# ABSTRACT: convert numbers between arbitrary bases

use DDG::Goodie;

use Math::Int2Base qw/int2base/;
use 5.010;
use bigint;

my %base_map = (
    hex         => 16,
    hexadecimal => 16,
    oct         =>  8,
    octal       =>  8,
    binary      =>  2,
);

triggers any => 'base', keys %base_map;

zci answer_type => "conversion";
zci is_cached => 1;

primary_example_queries '255 in hex';
secondary_example_queries '255 in base 16', '42 in binary';
description 'convert a number to an arbitrary base';
name 'Base';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Base.pm';
category 'conversions';
topics 'math';
attribution web => [ 'http://perlgeek.de/blog-en', 'Moritz Lenz' ],
            github => [ 'http://github.com/moritz', 'moritz'];


handle query_clean => sub {
    return unless  /^([0-9]+)\s*(?:(?:in|as|to)\s+)?(hex|hexadecimal|octal|oct|binary|base\s*([0-9]+))$/;
    my $number = $1;
    my $base = $3 // $base_map{$2};
    return if $base < 2 || $base > 36;
    my $based = int2base($number, $base);
    return "$number in base $base is $based";
};

1;

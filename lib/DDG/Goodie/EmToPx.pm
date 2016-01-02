package DDG::Goodie::EmToPx;
# ABSTRACT: em <-> px for font sizes.

use strict;
use warnings;
use DDG::Goodie;

triggers any => "em", "px";

zci answer_type => "conversion";
zci is_cached   => 1;

primary_example_queries '10 px to em';
secondary_example_queries '12.2 px in em assuming a 12.2 font size';
description 'convert from px to em';
name 'EmToPx';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EmToPx.pm';
category 'conversions';
topics 'programming';
attribution twitter => ['crazedpsyc','crazedpsyc'],
            cpan    => ['CRZEDPSYC','crazedpsyc'];


sub em_to_px {
    my ($to_convert, $fontsize) = @_;
    return $to_convert * $fontsize;
}

sub px_to_em {
    my ($to_convert, $fontsize) = @_;
    return sprintf('%.3f', $to_convert / $fontsize) =~ s/\.?0+$//r;
}

my $number = qr/(\d++\.\d*+|\d*+\.\d++|\d++)/;
my $whatis = qr/(convert|change|what\s*('?s|is|are))?/i;
my $amount = qr/(?<amount>$number)/i;
my $source = qr/(?<source>em|px)/i;
my $target = qr/(?<target>em|px)/i;
my $fs = qr/((font[ -]?|base[- ]?pixel[- ]?)size)/i;
my $fontsize = qr/((with|at|using|assuming)(\s*an?)?)?\s*(?<fm>$fs\s*(of)?\s*)?((?<fontsize>$number)\s*(px)?)\s*(?(<fm>)|($fs))?/i;

handle query_lc => sub {
    my $query = $_;
    $query =~ s/(?![\.\s])\W//g;
    return unless $query =~ /^${whatis}?\s*${amount}\s*${source}\s*(?:in|to)\s*${target}\s*${fontsize}?\s*$/i;
    my $target   = $+{target};
    my $num      = $+{amount};
    my $source   = $+{source};
    my $fontsize = $+{fontsize} // 16;
    return if ($target eq $source || !$num);

    my $result = ($target eq 'px') ? em_to_px($num, $fontsize) . 'px'
                                   : px_to_em($num, $fontsize) . 'em';
    my $formatted_input = "Convert $num $source to $target with a font-size of ${fontsize}px";

    return $result,
        structured_answer => {
            id   => 'em_to_px',
            name => 'Answer',
            data => {
                title    => $result,
                subtitle => $formatted_input,
            },
            templates => {
                group  => 'text',
                moreAt => 0,
            },
        };
};

1;

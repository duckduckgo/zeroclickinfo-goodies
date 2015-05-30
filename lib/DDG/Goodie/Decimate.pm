package DDG::Goodie::Decimate;
# ABSTRACT: Write an abstract here
# Do a long division, showing a complete decimal expansion, including the repetend.

use DDG::Goodie;
use strict;

zci answer_type => "decimate";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "Decimate";
description "Calculates complete decimal expansion of a quotient, showing the repetend.";
primary_example_queries "decimate 2473 / 23";
secondary_example_queries "long divide 2473 / 23", "longdiv 2473 / 23";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "calculations";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Decimate.pm";
attribution github => ["umvegas", "Matthew Vega"],
            twitter => "\@umvegas";

# Triggers
triggers start => "decimate", "divide", "longdiv", "long div", "long divide", "long division";

# Handle statement
handle remainder => sub {

    # optional - regex guard
    return unless qr/^\w+/;

    return unless $_; # Guard against "no answer"

    my @ml = /(\d+)\s*(?:\/|by)\s*(\d+)/;
    return unless @ml;
    
    my $numer = $ml[0];
    my $denom = $ml[1];
    my @nl = split("", $numer);
    my $dotAt = @nl;
    my $nd = 0;
    my $rem = $numer; # initialize to anything true-ish
    my %map = ();
    my @ans = ();
    my $i;
    for ($i = 0; $rem != 0; $i++) {
        if ($nd) {
            $nd = $nd . ($i < @nl ? $nl[$i] : "0");
        } else {
            $nd = $nl[$i];
        }
        my $quo = int($nd / $denom);
        $rem = $nd % $denom;
        push @ans, $quo;
        if ($rem != 0) { # into the decimal expansion
            $nd = $rem;
            if ($i >= @nl) {
                if ($map{$rem}) {
                    pop @ans;
                    last;
                } else {
                    $map{$rem} = $i;
                }
            }
        }
    }
    my $lz = 1;
    my $postDot = 0;
    my @repetend = ();
    my $answer = "$numer / $denom = ";
    for ($i = 0; $i < @ans; $i++) {
        if ($lz) {
            if ($i == $dotAt) {
                $lz = 0;
                $answer .= "0";
            } elsif ($ans[$i] != 0) {
                $lz = 0;
            }
        }
        if (!$lz) {
            if ($i == $dotAt) {
                $answer .= ".";
                $postDot = 1;
            }
            if ($postDot) {
                push @repetend, $ans[$i];
            }
            $answer .= $ans[$i];
        }
    }
    if (@repetend == 1) {
        $answer .= " (last digit repeats)";
    } elsif (@repetend > 1) {
        $answer .= " (last " . @repetend . " digits repeat)";
    } else {
        $answer .= " (non-repeating)";
    }
    return $answer;
};

1;

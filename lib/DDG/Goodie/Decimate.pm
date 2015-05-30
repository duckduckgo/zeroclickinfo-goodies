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
    
    my @ml = /(\d+)\s*(?:\/|by)\s*(\d+)/; # numerator / denominator, "/" or "by"
    return unless @ml;                    # quit if no match
    
    my $numer = $ml[0];         # the numerator
    my $denom = $ml[1];         # the denominator
    my @nl = split("", $numer); # list of digits in the numerator
    my $dotAt = @nl;            # position of the decimal in the numerator
    my $nd = "";                # working portion of the numerator
    my $rem = $numer;           # remainder, initial value must be != 0
    my %map = ();               # record of which remainders have occurred
    my @ans = ();               # list of digits in the answer
    my $i;                      # iterator position
    for ($i = 0; $rem != 0; $i++) {      # until no remainder
        $nd .= $i < @nl ? $nl[$i] : "0"; # get the next digit, or zero
        my $quo = int($nd / $denom); # the working quotient, without remainder
        $rem = $nd % $denom;         # find the remainder
        push @ans, $quo;             # remember the working quotient
        if ($rem != 0) {             # work still left to do
            $nd = $rem;              # remainder becomes the working numerator
            if ($i >= @nl) {         # into the decimal expansion
                if ($map{$rem}) {    # this remainder has occurred before
                    pop @ans;        # forget the last (duplicate) quotient
                    last;            # and we're done
                } else {             # haven't seen this remainder,
                    $map{$rem} = $i; # but we have now, so remember it
                }
            }
        }
    }
    my $lz = 1;                        # leading zeros, until we see a non-zero
    my $postDot = 0;                   # past the decimal point, not at first
    my @repetend = ();                 # list of decimal places, if they repeat
    my $answer = "$numer / $denom = "; # start building the answer text
    for ($i = 0; $i < @ans; $i++) {    # for each digit in the answer
        if ($lz) {                     # have we seen non-zero?
            if ($i == $dotAt) {        # are we at the decimal position?
                $lz = 0;               # zeros not leading anymore after the dot
                $answer .= "0";        # add a zero to the answer before the dot
            } elsif ($ans[$i] != 0) {  # found a non-zero
                $lz = 0;               # remember that we have
            }
        }
        if (!$lz) {                       # done with leading zeros?
            if ($i == $dotAt) {           # are we at the decimal position?
                $answer .= ".";           # if so, add the dot to the answer
                $postDot = 1;             # remember that we've past the dot
            }
            if ($postDot) {               # are we past the dot?
                push @repetend, $ans[$i]; # if so, remember in case of repeats
            }
            $answer .= $ans[$i];          # finally, add the current digit
        }
    }
    if (@repetend == 1 && $rem) {            # only one repeating digit
        $answer .= " (last digit repeats)";
    } elsif (@repetend > 1 && $rem) {        # more than one repeating digit
        $answer .= " (last " . @repetend .
            " digits repeat)";
    } elsif ($postDot) {                     # a non-repeating decimal
        $answer .= " (non-repeating)";
    }
    return $answer;                          # all done!
};

1;

package DDG::Goodie::Roman;
# ABSTRACT: Convert between Roman and Arabic numeral systems.

use strict;
use DDG::Goodie;

use Roman;
use utf8;

triggers any => "roman", "arabic";

zci is_cached => 1;
zci answer_type => "roman_numeral_conversion";

handle remainder => sub {
    my $in = uc shift;
    $in =~ s/(?:\s*|in|to|numerals?|number)//gi;

    return unless $in;

    my $out;
    if ($in =~ /^\d+$/) {
        $out = uc(roman($in));
    } elsif ($in =~ /^[mdclxvi]+$/i) {
        $in  = uc($in);
        $out = arabic($in);
    }
    return unless $out;

    return $out . ' (roman numeral conversion)', structured_answer => {
        data => {
            title => $out,
            subtitle => "Roman numeral conversion: $in"
        },
        templates => {
            group => 'text'
        }    
    };
};

1;

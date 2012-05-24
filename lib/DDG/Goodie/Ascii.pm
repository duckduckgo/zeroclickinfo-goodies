package DDG::Goodie::Ascii;
# ABSTRACT: ASCII

use DDG::Goodie;

triggers end => "ascii";

zci answer_type => "ascii_conversion";
zci is_cached => 1;

handle remainder => sub {
    my $ascii = pack("B*", $1) if /^(([0-1]{8})*)\s+(in|to)$/; 
    return $ascii if $ascii;
    return;
};

1;


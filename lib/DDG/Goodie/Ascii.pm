package DDG::Goodie::Ascii;

use DDG::Goodie;

zci answer_type => "ascii_conversion";
zci is_cached => 1;
triggers end => "ascii";


handle remainder => sub {
    my $ascii = pack("B*", $1) if /^(([0-1]{8})*)\s+(in|to)$/; 
    return $ascii if $ascii;
    return;
};

1;


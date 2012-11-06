package DDG::Goodie::Binary;

use DDG::Goodie;

triggers end => "binary";

zci is_cached => 1;
zci answer_type => "binary_conversion";

primary_example_queries 'foo in binary';
secondary_example_queries '0x1e to binary';
description 'convert ASCII, numbers, and hex to binary';
name 'Binary';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Binary.pm';
category 'conversions';
topics 'geek';

sub bin {
    my @tex = shift;
    my $bin;
    for(my $x = 0; $x <= $#tex; $x++) {
        $bin .= unpack("B*", $tex[$x]);
    }
    return $bin;
}

sub dec2bin {
    my @dec = shift;
    my $str = unpack("B*", pack("N", $dec[0] ));
    $str =~ s/^0+(?=\d)//;   # first suppress leading zeros
# Then add some more ...    
    return ('0' x (8 - (length($str) % 8))) . $str if (length($str)%8 > 0); 
    return $str
}

sub hex2bin {
    dec2bin(hex(shift));
}

sub bin2dec {
    my @bin = shift;
    my $str = unpack("N", pack("B32", substr("0" x 32 . $bin[0], -32)));
    return $str;
}


handle remainder => sub {
    my @out;
    @out = (bin2dec($1), "binary", "decimal")   if /^[^01]*([01]+)\s+(from)?$/;
    @out = (hex2bin($2), "hex", "binary")       if /^(0x|Ox|x)([0-9a-fA-F]+)\s+(in|to)$/ && !@out;
    @out = (dec2bin($1), "decimal", "binary")   if /^([0-9 ]+)\s+(in|to)$/ && !@out;
    @out = (hex2bin($1), "hex", "binary")       if /^([0-9a-fA-F]+)\s+(in|to)$/ && !@out;
    @out = (bin($1), "a string", "binary")      if /^(.*)\s+(in|to)$/ && !@out;
    return qq/"$1" as $out[1] is "$out[0]" in $out[2]./;
};

1;

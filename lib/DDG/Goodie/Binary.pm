package DDG::Goodie::Binary;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "binary_conversion";
triggers end => "binary";

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
    return bin2dec($1) if /^[^01]*([01]+)\s+(from)?$/;
    return hex2bin($2) if /^(0x|Ox|x)([0-9a-fA-F]+)\s+(in|to)$/;
    return dec2bin($1) if /^([0-9 ]+)\s+(in|to)$/;
    return hex2bin($1) if /^([0-9a-fA-F]+)\s+(in|to)$/;
    return '\"'.$1.'\" as a string is '.bin($1).' in binary.' if /^(.*)\s+(in|to)$/;
    return;
}


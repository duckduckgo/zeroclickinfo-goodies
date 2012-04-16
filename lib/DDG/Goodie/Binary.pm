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

sub decbinjust {
    my @dec = shift;
    my $dig = unpack("B*", pack("N", $dec[0] ));
    # first suppress leading zeros
    $dig =~ s/^0+(?=\d)//;
    # Then add some more ...    
    $dig = ('0' x (8 - (length($dig) % 8))) . $dig if (length($dig)%8 > 0); 
    return $dig; 
}

sub dec2bin {
    my @dec = shift;
    @dec = split('[ ,|:;]+',$dec[0]);
    my $str;
	$str = decbinjust($dec[0]);
    for(my $x=1; $x<= $#dec; $x++) {
	$str .= ' '.decbinjust($dec[$x]);
    }
    return $str;
}

sub hex2bin {
    my @arg = shift;
    my $hex = $arg[0];
    $hex =~ s/0x/x/g;  
    $hex =~ s/[Oo]x/x/g;  
    @hex = split('[ ,|:;]+',$hex);
    my $str;
    $str = decbinjust(hex($hex[0]));
    for(my $x=1; $x<= $#hex; $x++) {
	$str .= ' '. decbinjust(hex($hex[$x]));
    }
    return $str;
}

sub bin2dec {
    my @bin = shift;
    my $str = unpack("N", pack("B32", substr("0" x 32 . $bin[0], -32)));
    return $str;
}


handle remainder => sub {
    return bin2dec($1) if /^[^01]*([01]+)\s+(from|as)?$/;
    return hex2bin($1) if /^(((0x|Ox|ox|x)([0-9a-fA-F]+)[ ,|:;]*)+)\s+(in|to)$/;
    return dec2bin($1) if /^(([0-9]+[ ,|:;]*)+)\s+(in|to)$/;
    return hex2bin($1) if /^(([0-9a-fA-F]+[ ,|:;]*)+)\s+(in|to)$/;
    return '"'.$1.'" as a string is '.bin($1).' in binary.' if /^(.*)\s+(in|to)$/;
    return;
};

1;



package DDG::Goodie::Binary;
# ABSTRACT: Convert decimal, hex and string to binary.

use DDG::Goodie;

use Bit::Vector;

triggers end => "binary";

zci is_cached => 1;
zci answer_type => "binary_conversion";

primary_example_queries 'foo in binary', '12 as binary', 'hex 0xffff into binary';
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
    my $dec = shift;
    #  Method for packing without 'q' taken from:
    #  http://www.perlmonks.org/?node_id=163123
    my $vec = Bit::Vector->new_Dec(64, $dec);
    my $str = unpack("B*", pack('NN', $vec->Chunk_Read(32, 32), $vec->Chunk_Read(32, 0)));
    $str =~ s/^0+(?=\d)//;    # first suppress leading zeros
    my $alignment = length($str) % 8;    # Then see if we need to pad for byte-sized output.
    return ($alignment) ? ('0' x (8 - $alignment)) . $str : $str;
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

    if (/^([01]+)(\s+from)?$/) {
        # Looks like they gave us some binary, let's turn it into decimal!
        @out = ($1, bin2dec($1), "binary", "decimal");
    } elsif (s/\s+(in|to|into|as)$//) {
        # Looks like they are asking for a conversion to binary
        # So, try to figure out what they've got.
        # They can either tell us explicitly or we can try to just work it out.
        if (/^(?:decimal\s+)?([0-9]+)$/) {
            @out = ($1, dec2bin($1), "decimal", "binary");
        } elsif (/^(?:hex\s+)?(?:0x|Ox|x)?([0-9a-fA-F]+)$/) {
            # Normalize the hex output with lowercase and a prepended '0x'.
            @out = ('0x' . lc $1, hex2bin($1), "hex", "binary");
        } else {
            # We didn't match anything else, so just convert whatever string is left.
            @out = ('"' . $_ . '"', bin($_), "string", "binary");
        }
    }
    return unless (@out);    # Didn't hit any conditions, must not be us.
    return qq/Binary conversion: $out[0] ($out[2]) = $out[1] ($out[3])/;
};

1;

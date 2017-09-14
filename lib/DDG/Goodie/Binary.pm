package DDG::Goodie::Binary;
# ABSTRACT: Convert decimal, hex and string to binary.

use strict;
use DDG::Goodie;

use Bit::Vector;

triggers end => "binary";

zci answer_type => "binary_conversion";
zci is_cached   => 1;

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
    my ($input, $from, $to, $result);

    if (/^([01]+)(\s+from)?$/) {
        # Looks like they gave us some binary, let's turn it into decimal!
        $input = $1;
        $from = "Binary";
        $to = "Decimal";
        $result = bin2dec($1);
    } elsif (s/\s+(in|to|into|as)$//) {
        # Looks like they are asking for a conversion to binary
        # So, try to figure out what they've got.
        # They can either tell us explicitly or we can try to just work it out.
        if (/^(?:decimal\s+)?([0-9]+)$/) {
            $input = $1;
            $from = "Decimal";
            $to = "Binary";
            $result = dec2bin($1);
        } elsif (/^(?:hex\s+)?(?:0x|Ox|x)?([0-9a-fA-F]+)$/) {
            # Normalize the hex output with lowercase and a prepended '0x'.
            $input = '0x' . lc $1;
            $from = "Hex";
            $to = "Binary";
            $result = hex2bin($1);
        } else {
            # We didn't match anything else, so just convert whatever string is left.
            $input = $_;
            $from = "String (UTF-8)";
            $to = "Binary";
            # change input's internal encoding into UTF-8
            my $utf8_input = Encode::encode('utf8', $_);
            $result = bin($utf8_input);
        }
    }
    return unless ($input);    # Didn't hit any conditions, must not be us.

    return qq/Binary conversion: $input ($from) = $result ($to)/,
        structured_answer => {
            data => {
              title => $result,
              subtitle =>$from . ' to ' . $to . ': ' . $input
            },
            templates => {
              group => 'text'
            }
    };
};

1;

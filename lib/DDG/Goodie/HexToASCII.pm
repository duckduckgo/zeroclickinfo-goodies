package DDG::Goodie::HexToASCII;
# ABSTRACT: Returns the ASCII representaion of a given hexadecimal value. (If printbale of course).

use strict;

use DDG::Goodie;
# Used to restrict long generated outputs
use constant MAX_OUTPUT_LEN => 256;

triggers start => 'ascii';

zci answer_type => 'ascii';

primary_example_queries 'ascii 0x74657374';
secondary_example_queries 'ascii 0x5468697320697320612074657374';
description 'Return the ASCII representation of a given printable HEX number.';
name 'HexToASCII';
code_url 'http://github.com';
category 'computing_tools';
topics 'programming';
attribution github => ['https://github.com/koosha--', 'koosha--'],
			twitter => '_koosha_';

handle remainder => sub {
    my $value = $_;
    $value =~ s/^\s+//;
    $value =~ s/\s+$//;
    if ($value =~ /^(?:[0\\]x)?([0-9a-f]+)$/i or 
        $value =~ /^([0-9a-f]+)h?$/i) {
       my @digits = $1 =~ /(..)/g;
       my $string = '';
       foreach my $digit (@digits) {
           my $hex = hex $digit;
           return if $hex <= 0x1F || $hex >= 0x7F;
           $string .= chr $hex;
       }
       # Don't let long strings make the output untidy
       if (length($string) > MAX_OUTPUT_LEN) {
           $string = substr($string, 0, MAX_OUTPUT_LEN - 3) . '...';
       }
       $string =~ s/\n/ /g;
       return "$string (ASCII)";
    }
    return;
};

1;

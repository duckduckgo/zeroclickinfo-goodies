package DDG::Goodie::Bin2Unicode;

# ABSTRACT: Convert binary to unicode

use DDG::Goodie;
use strict;

no warnings qw'non_unicode overflow portable';

zci answer_type => 'bin2unicode';
zci is_cached   => 1;

triggers query => qr{^([01\s]{8,})(?:\s+(?:to\s+)?(?:unicode|text|ascii))?$};

my $MAX_CODE_PT = 1114111;

my %ctrl_chars = (
    0 => 'Null character (NUL)',
    1 => 'Start of Heading (SOH)',
    2 => 'Start of Text (STX)',
    3 => 'End-of-text character (ETX)',
    4 => 'End-of-transmission character (EOT)',
    5 => 'Enquiry character (ENQ)',
    6 => 'Acknowledge character (ACK)',
    7 => 'Bell character (BEL)',
    8 => 'Backspace (BS)',
    9 => 'Horizontal tab (HT)',
    10 => 'Line feed (LF)',
    11 => 'Vertical tab (VT)',
    12 => 'Form feed (FF)',
    13 => 'Carriage return (CR)',
    14 => 'Shift Out (SO)',
    15 => 'Shift In (SI)',
    16 => 'Data Link Escape (DLE)',
    17 => 'Device Control 1 (DC1)',
    18 => 'Device Control 2 (DC2)',
    19 => 'Device Control 3 (DC3)',
    20 => 'Device Control 4 (DC4)',
    21 => 'Negative-acknowledge character (NAK)',
    22 => 'Synchronous Idle (SYN)',
    23 => 'End of Transmission Block (ETB)',
    24 => 'Cancel character (CAN)',
    25 => 'End of Medium (EM)',
    26 => 'Substitute character (SUB)',
    27 => 'Escape character (ESC)',
    28 => 'File Separator (FS)',
    29 => 'Group Separator (GS)',
    30 => 'Record Separator (RS)',
    31 => 'Unit Separator (US)',
    32 => 'Space (SP)',
    127 => 'Delete (DEL)',
    128 => 'Padding Character (PAD)',
    129 => 'High Octet Preset (HOP)',
    130 => 'Break Permitted Here (BPH)',
    131 => 'No Break Here (NBH)',
    132 => 'Index (IND)',
    133 => 'Next Line (NEL)',
    134 => 'Start of Selected Area (SSA)',
    135 => 'End of Selected Area (ESA)',
    136 => 'Character Tabulation Set (HTS)',
    137 => 'Character Tabulation with Justification (HTJ)',
    138 => 'Line Tabulation Set (VTS)',
    139 => 'Partial Line Forward (PLD)',
    140 => 'Partial Line Backward (PLU)',
    141 => 'Reverse Line Feed (RI)',
    142 => 'Single-Shift Two (SS2)',
    143 => 'Single-Shift Three (SS3)',
    144 => 'Device Control String (DCS)',
    145 => 'Private Use 1 (PU1)',
    146 => 'Private Use 2 (PU2)',
    147 => 'Set Transmit State (STS)',
    148 => 'Cancel character (CCH)',
    149 => 'Message Waiting (MW)',
    150 => 'Start of Protected Area (SPA)',
    151 => 'End of Protected Area (EPA)',
    152 => 'Start of String (SOS)',
    153 => 'Single Graphic Character Introducer (SGCI)',
    154 => 'Single Character Intro Introducer (SCI)',
    155 => 'Control Sequence Introducer (CSI)',
    156 => 'String Terminator (ST)',
    157 => 'Operating System Command (OSC)',
    158 => 'Private Message (PM)',
    159 => 'Application Program Command (APC)'
);

my $zaahirs_hideout = '0' x 48;

handle matches => sub {
    my $q = $_; # orginal query
    my $bin_string = shift @_; # captured binary string

    my $str;
    if($bin_string eq $zaahirs_hideout){
        $str = q{Congratulations, you've discovered Zaahir's hideout!};
        goto DONE;
    }
    my $want_ascii = $q =~ /\bascii\b/;

    my @bins = $bin_string =~ /([01]+|\s+)/g;
    for my $b (@bins){
        if($b =~ /^[01]+$/){
            return if length($b) % 8;
            # Overflow/non-portable warnings expected
            my $i = oct("0b$b");
            if((exists $ctrl_chars{$i}) && (@bins == 1)){
                $str = $ctrl_chars{$i};
				$str = "Control character: $str" unless ($i == 32) || ($i == 127);
                last;
            }
            # Assume ascii if out of range or explicitly requested.
            # This will work for characters all in the same string
            # but will not print the right non-ascii characters *if*
            # they are also in the string.
            $str .= (($i > $MAX_CODE_PT) || $want_ascii)
                ? pack('B*', $b)
                : chr($i);
        }
        else {
            $str .= $b;
        }
    }

    # return if all control/space (https://en.wikipedia.org/wiki/List_of_Unicode_characters#Control_codes)
    return if $str =~ /^[\p{Control} ]+$/;

    DONE:
    return "Binary '$bin_string' converted to " . $want_ascii ? 'ascii' : 'unicode' . " is '$str'",
        structured_answer => {
            id => 'bin2unicode',
            name => 'Answer',
            data => {
              title => $str,
              subtitle => "Input: $q",
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        };
};

1;

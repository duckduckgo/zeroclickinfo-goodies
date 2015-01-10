package DDG::Goodie::HexToASCII;
# ABSTRACT: Returns the ASCII representaion of a given hexadecimal value. (If printbale of course).

use strict;

use DDG::Goodie;
# Used to restrict long generated outputs
use constant MAX_INPUT_CHARS => 128;

triggers start => 'ascii';

zci is_cached   => 1;
zci answer_type => 'ascii';

primary_example_queries 'ascii 0x74657374';
secondary_example_queries 'ascii 0x5468697320697320612074657374';
description 'Return the ASCII representation of a given printable HEX number.';
name 'HexToASCII';
code_url 'http://github.com';
category 'computing_tools';
topics 'programming';
attribution github => ['https://github.com/koosha--', 'koosha--'];

handle remainder => sub {
    my $value = $_;
    $value =~ s/^\s+//;
    $value =~ s/\s+$//;
    if ($value =~ /^(?:[0\\]x)?([0-9a-f]+)$/i or $value =~ /^([0-9a-f]+)h?$/i) {
        my @digits = $1 =~ /(..)/g;
        my ($pure, $html, $count);
        # Now convert them one by one, until it seems like there might be too many.
        while (my $digit = shift @digits and $count++ <= MAX_INPUT_CHARS) {
            my $printable = printable_chr(hex $digit);
            return unless $printable;
            $pure .= $printable->{pure};
            $html .= $printable->{html};
        }

        # If they gave us more input than we're willing to handle, throw in
        # an appropriate ellipsis for their output type and call it done.
        if (scalar @digits) {
            $pure .= '...';
            $html .= '&hellip;';
        }

        return $pure . ' (ASCII)',
          structured_answer => {
            input     => [$value],
            operation => 'Hex to ASCII',
            result    => $html,
          };
    }
    return;
};

# Some of these are actually printable whitespace, but
# for consistency, we'll make them discoverable, too.
my %invisibles = (
    0x00 => { abbr => 'NUL', desc => 'null' },
    0x01 => { abbr => 'SOH', desc => 'start of heading' },
    0x02 => { abbr => 'STX', desc => 'start of text' },
    0x03 => { abbr => 'ETX', desc => 'end of text' },
    0x04 => { abbr => 'EOT', desc => 'end of transmission' },
    0x05 => { abbr => 'ENQ', desc => 'enquiry' },
    0x06 => { abbr => 'ACK', desc => 'acknowledge' },
    0x07 => { abbr => 'BEL', desc => 'bell', },
    0x08 => { abbr => 'BS',  desc => 'backspace', },
    0x09 => { abbr => 'TAB', desc => 'horizontal tab', },
    0x0A => { abbr => 'LF',  desc => 'linefeed', },
    0x0B => { abbr => 'VT',  desc => 'vertical tab', },
    0x0C => { abbr => 'FF',  desc => 'form feed', },
    0x0D => { abbr => 'CR',  desc => 'carriage return', },
    0x0E => { abbr => 'SO',  desc => 'shift out', },
    0x0F => { abbr => 'SI',  desc => 'shift in', },
    0x10 => { abbr => 'DLE', desc => 'data link escape', },
    0x11 => { abbr => 'DC1', desc => 'device control 1', },
    0x12 => { abbr => 'DC2', desc => 'device control 2', },
    0x13 => { abbr => 'DC3', desc => 'device control 3', },
    0x14 => { abbr => 'DC4', desc => 'device control 4', },
    0x15 => { abbr => 'NAK', desc => 'negative acknowledge', },
    0x16 => { abbr => 'SYN', desc => 'synchronous idle', },
    0x17 => { abbr => 'ETB', desc => 'end of transmission block', },
    0x18 => { abbr => 'CAN', desc => 'cancel', },
    0x19 => { abbr => 'EM',  desc => 'end of medium', },
    0x1A => { abbr => 'SUB', desc => 'substitute', },
    0x1B => { abbr => 'ESC', desc => 'escape', },
    0x1C => { abbr => 'FS',  desc => 'file separator', },
    0x1D => { abbr => 'GS',  desc => 'group separator', },
    0x1E => { abbr => 'RS',  desc => 'record separator', },
    0x1F => { abbr => 'US',  desc => 'unit separator', },
    0x7F => { abbr => 'DEL', desc => 'delete', },
);

# The actual hex to ASCII conversion.
# Returns a hashref with a 'pure' and 'html' representation.
# The html representation includes tagged information on invisible
# characters (defined as non-printable + non-space whitespace.)
# The pure ASCII representation elides the invisible characters.
sub printable_chr {
    my ($hex) = @_;

    # Looks like non-ASCII, don't give them anything.
    return if ($hex > 0x7F);
    my $representation;
    if (my $char_info = $invisibles{$hex}) {
        $representation->{html} = '<code title="' . $char_info->{desc} . '">[' . $char_info->{abbr} . ']</code>';
        $representation->{pure} = '';    # Don't want to add any printable whitespace and wonder what happened.
    } else {
        # This must be a printable character, so just let chr figure it out
        $representation->{html} = html_enc($representation->{pure} = chr $hex);
    }

    return $representation;
}

1;

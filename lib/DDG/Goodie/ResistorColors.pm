package DDG::Goodie::ResistorColors;
# ABSTRACT: Convert a resistor value into color codes.
#           e.g. "4.7K ohms" -> "yellow purple black brown"

# Ideas for future improvements
# - reverse query (e.g. "yellow purple black brown" -> "4.7K ohms"
# - show 4 and 5 band markings
# - show surface mount resistor markings
# - detect if query contains tolerance (e.g. 10%) and use appropriate color

use DDG::Goodie;
use Math::Round;
use POSIX qw(abs floor log10 pow);

# \x{2126} is the unicode ohm symbol
triggers query_nowhitespace => qr/^(.*)(ohm|ohms|\x{2126})/i;

zci is_cached => 1;
zci answer_type => 'resistor_colors';

primary_example_queries '4.7k ohm';
secondary_example_queries '1\x{2126}';
description 'find resistor color bands';
name 'ResistorColors';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ResistorColors.pm';
category 'conversions';
topics 'science';

attribution twitter => 'joewalnes',
            web => ['http://joewalnes.com', 'joewalnes.com'],
            email => ['joe@walnes.com', 'Joe Walnes'];

# These hex codes came from
# http://en.wikipedia.org/wiki/Electronic_color_code
my %digits_to_colors = (
    -2 => { hex => '#c0c0c0', label => '#000', name => 'silver', multiplier => '0.01'},
    -1 => { hex => '#cfb53b', label => '#000', name => 'gold'  , multiplier => '0.1'},
    0  => { hex => '#000000', label => '#fff', name => 'black' , multiplier => '1'},
    1  => { hex => '#964b00', label => '#fff', name => 'brown' , multiplier => '10'},
    2  => { hex => '#ff0000', label => '#fff', name => 'red'   , multiplier => '100'},
    3  => { hex => '#ffa500', label => '#000', name => 'orange', multiplier => '1K'},
    4  => { hex => '#ffff00', label => '#000', name => 'yellow', multiplier => '10K'},
    5  => { hex => '#9acd32', label => '#000', name => 'green' , multiplier => '100K'},
    6  => { hex => '#6495ed', label => '#000', name => 'blue'  , multiplier => '1M'},
    7  => { hex => '#ee82ee', label => '#000', name => 'purple', multiplier => '10M'},
    8  => { hex => '#a0a0a0', label => '#000', name => 'gray'  , multiplier => '100M'},
    9  => { hex => '#ffffff', label => '#000', name => 'white' , multiplier => '1000M'},
);

handle matches => sub {
    my $input = shift;
    my $value = parse_value($input);
    if (defined $value) {
        $value = round_to_significant_places($value, 3);
        my @digits = number_to_color_digits($value);
        return render($value, \@digits);
    }
    return;
};

# Given ohm rating as string (e.g. 3.2m or 3M2), return
# integer value (e.g. 3200000).
sub parse_value {
    my $input = shift;
    if ($input =~ m/^(\d+)(\.(\d+))?([km])?$/i) {
        # e.g. 123, 1.23, 1M, 1.23M
        my $multiplier = 1;
        if ($4) {
            $multiplier = 1000 if $4 eq 'k' || $4 eq 'K';
            $multiplier = 1000000 if $4 eq 'm' || $4 eq 'M';
        }
        return ("$1." . ($3 || 0)) * $multiplier;
    } elsif ($input =~ m/^(\d+)([km])(\d+)$/i) {
        # e.g. 12K3
        my $multiplier = 1;
        $multiplier = 1000 if $2 eq 'k' || $2 eq 'K';
        $multiplier = 1000000 if $2 eq 'm' || $2 eq 'M';
        return ("$1." . ($3 || 0)) * $multiplier;
    } else {
        return;
    }
};

# Round a value to significant places.
# e.g. (123456789, 3) -> 123000000)
#      (0.0045678, 3) -> 0.00457)
sub round_to_significant_places {
  my $value = shift;
  my $significant = shift;
  if ($value == 0) {
    return 0;
  }
  return nearest(pow(10, int(floor(log10(abs($value))) - ($significant - 1))), $value);
}

# Given ohm rating as integer (e.g. 470000), return
# array of color digits (e.g. 4, 7, 0, 3). See %digits_to_colors.
sub number_to_color_digits {
    my $value = shift;
    return (0, 0, 0, 0) if $value == 0; # special case
    my @value_digits = split(//, $value * 100);
    return (
        $value_digits[0] || 0,
        $value_digits[1] || 0,
        $value_digits[2] || 0,
        scalar(@value_digits) - 5);
};

# Given a numeric value, format it like '3.2M' etc.
sub format_value {
    my $value = shift;
    if ($value >= 1000000) {
      return ($value / 1000000) . 'M';
    } elsif ($value >= 1000) {
      return ($value / 1000) . 'K';
    } else {
      return $value;
    }
};

# Given array of color digits (e.g. 3, 3, 1, 4),
# return text and html representation of colors.
sub render {
    my ($value, $digits) = @_;
    my $formatted_value = format_value($value);
    my $ohms = $formatted_value eq '1' ? 'ohm' : 'ohms';
    my $text = "$formatted_value\x{2126} ($ohms) resistor colors:";
    my $html = "$formatted_value&#x2126; ($ohms) resistor colors:";

    while (my ($index, $digit) = each @$digits) {
        if (exists $digits_to_colors{$digit}) {
            my $name  = $digits_to_colors{$digit}{name};
            my $hex   = $digits_to_colors{$digit}{hex};
            my $label = $digits_to_colors{$digit}{label};
            my $style = "display:inline-block;background-color:$hex;color:$label;"
                . "border:1px solid #c8c8c8;margin-top:-1px;padding:0px 4px;"
                . "border-radius:4px;-webkit-border-radius:4px;-moz-border-radius:4px;";
            if ($index == scalar(@$digits) - 1) {
                my $multiplier = $digits_to_colors{$digit}{multiplier};
                $text .= " $name (\x{00D7}$multiplier)";
                $html .= " <span style='$style'>$name (&times;$multiplier)</span>";
            } else {
                $text .= " $name ($digit),";
                $html .= " <span style='$style'>$name ($digit)</span>";
            }
        } else {
            return;
        }
    }
    $html .= "<br/><span style='font-size:92.8%;color:#333'>Followed by a gap and tolerance color. "
        . "<a href='http://resisto.rs/#$formatted_value'>More at resisto.rs</a></span>";

    return $text, html => $html;
};

1;

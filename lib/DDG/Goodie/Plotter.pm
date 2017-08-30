package DDG::Goodie::Plotter;
# ABSTRACT: Plots points and lines on a coordinate plane

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'plotter';

zci is_cached => 1;

triggers startend => 'point', 'plot point', 'graph point', 'plot line', 'line', 'graph line';

# Handle statement
handle remainder => sub {
    #if it is a point
    if (index($req->query_lc, "point") > -1) {
        return unless /^\s*(?:-|)\d+(?:\.\d+)*(?:(?:\s|,)+(?:-|)\d+(?:\.\d+)*)\s*$/;
        my @numbers = grep(/^(-|\d)/, split /(?:\s|,)+/);
        my $point_x = $numbers[0];
        my $point_y = $numbers[1];
        #prepare x and y to be shown by scaling and adjusting them
        $point_x *= 10 ** unit_size($point_x);
        $point_y *= 10 ** unit_size($point_y);
        $point_x += 100;
        $point_y = 200 - ($point_y + 100);
        my $formatted = join(', ', @numbers);
        
        return "Graph of $formatted",
            structured_answer => {

                data => {
                    title    => 'Graph of Point',
                    subtitle => $formatted,
                    is_point => 1,
                    is_line => 0,
                    point_x => $point_x,
                    point_y => $point_y,
                    x_axis_start => -axis($numbers[0]),
                    y_axis_start => -axis($numbers[1]),
                    x_axis_end => axis($numbers[0]),
                    y_axis_end => axis($numbers[1])
                },

                templates => {
                    group => 'info',
                    options => {
                        content => "DDH.plotter.plane"
                    }
                }
            };
   } elsif (index($req->query_lc, "line") > -1) {
        return unless /^\s*y\s*=\s*(?:-|)\d+(?:\.\d+)*\s*x\s*(?:\+|-)\s*(?:-|)\d+(?:\.\d+)*\s*$/;
        
        my @numbers = grep(/^(-|\d)/, split /(?:\s|x|\+|-|=)+/);
        my $m_value = $numbers[0];
        my $b_value = $numbers[1];
        #change minus to the opposite of the b value
        my $sign = '+';
        if (index($_, '+') == -1) {
            $b_value *= -1;
            $sign = '-';
        }
        #find the first point
        my $x1 = -100;
        my $y1 = $m_value * $x1 + $b_value;
        my $y_start = $y1;
        #adjust the first point
        $x1 += 100;
        $y1 *= 10 ** unit_size($y1);
        $y1 = 200 - ($y1 + 100);
        #find the second point
        my $x2 = 100;
        my $y2 = $m_value * $x2 + $b_value;
        my $y_end = $y2;
        #adjust the second point
        $x2 += 100;
        $y2 *= 10 ** unit_size($y2);
        $y2 = 200 - ($y2 + 100);
        #prepare equation to be shown
        $b_value = abs($b_value);
        my $formatted = "y = $m_value x $sign $b_value";
        return "Graph of $formatted",
            structured_answer => {

                data => {
                    title    => 'Graph of Line',
                    subtitle => $formatted,
                    is_point => 0,
                    is_line => 1,
                    x1 => $x1,
                    y1 => $y1,
                    x2 => $x2,
                    y2 => $y2,
                    x_axis_start => -100,
                    y_axis_start => -axis($y_start),
                    x_axis_end => 100,
                    y_axis_end => axis($y_end)
                },

                templates => {
                    group => 'info',
                    options => {
                        content => "DDH.plotter.plane"
                    }
                }
            };
   }
};

sub unit_size {
    #find the size to adjust the point by
    my ($value) = @_;
    my $unit_value = 0;
    my $abs = abs($value);
    if ($abs >= 100) {
        my $str_value = "$abs";
        $unit_value = -(length($str_value) - 2);
        if (index($str_value, '.') != -1) {
            $unit_value += length($str_value) - index($str_value, '.')
        }
    }
    if ($abs < 1) {
        my $str_value = "$abs";
        $unit_value = 2;
    }
    return $unit_value;
}

sub axis {
    #find the amount adjusted for use by the axis labels
    my ($value) = @_;
    my $abs = abs($value);
    my $power = 2;
    if ($abs >= 100) {
        my $str_value = "$abs";
        if (index($str_value, '.') != -1) {
            $power -= length($str_value) - index($str_value, '.') - 1;
            $power += length($str_value) - index($str_value, '.')
        } else {
            $power += length($str_value) - 2;
        }
    }
    if ($abs < 1) {
        my $str_value = "$abs";
        $power = 0;
    }
    return 10 ** $power;
}

1;

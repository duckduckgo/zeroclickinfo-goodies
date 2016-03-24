package DDG::Goodie::Perimeter;
# ABSTRACT: Compute the perimeter of basic shapes.

use strict;
use DDG::Goodie;

triggers start => "perimeter", "circumference";

zci is_cached => 1;
zci answer_type => "perimeter";

handle query_lc => sub {
    if ($_ =~ m/^(?:circumference (?:of\s|)(?:circle\s|)(\d+(?:\.\d+)?))|(?:(perimeter) (?:of\s|)(?:(square|circle|pentagon|hexagon|octagon) (\d+(?:\.\d+)?)|(rectangle) (\d+(?:\.\d+)?)[,;]?\s(\d+(?:\.\d+)?)|(triangle) (\d+(?:\.\d+)?)[,;]?\s(\d+(?:\.\d+)?)[,;]?\s(\d+(?:\.\d+)?)))$/) {
        my %polygons = ("pentagon" => 5, "hexagon" => 6, "octagon" => 8);
        my $shape = $1 ? "circle" : $3 || $5 || $8;

        my $subtitle = "Perimeter of $shape with sides of ";
        my $answer;

        if ($shape eq "square") {
            $subtitle .= $4;
            $answer = $4 * 4;
        } elsif ($shape eq "rectangle") {
            $subtitle .= "$6 and $7";
            $answer = ($6 * 2) + ($7 * 2)
        } elsif ($shape eq "triangle") {
            $subtitle .= "$9, $10 and $11";
            $answer = $9 + $10 + $11;
        } elsif ($shape eq "circle") {
            $subtitle = "Circumference of circle with radius of ".($1 || $4);
            $answer = (2 * 3.14159265358979323846) * ($1 || $4);
        } else {
            if (substr $shape, index($shape, "agon") eq "agon") {
                $subtitle .= $4;
                $answer = $4 * $polygons{$shape};
            }
        }

        return $answer, structured_answer => {
            data => {
                title => $answer,
                subtitle => $subtitle
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        }
    }
    return;
};

1;

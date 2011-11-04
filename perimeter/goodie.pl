# Calculates the perimiter of a square, rectangle, triangle, regular pentagon, regular hexagon, 
# regular octagon or the circumference of a circle with given specified edges/radius.
use Math::Trig;

if (!$type && $q_check_lc =~ m/^(perimeter) (?:of\s|)(?:(rectangle) (\d+(\.\d+)?)\s(\d+(\.\d+)?))$/ ||
 $q_check_lc =~ m/^(perimeter) (?:of\s|)(?:(triangle) (\d+(\.\d+)?)\s(\d+(\.\d+)?)\s(\d+(\.\d+)?))$/ ||
 $q_check_lc =~ m/^(perimeter) (?:of\s|)(?:(square|circle|pentagon|hexagon|octagon) (\d+(\.\d+)?))$/ ||
 $q_check_lc =~ m/^(circumference) (?:(?:of\s|)circle\s)?(\d+(\.\d+)?)$/) {
	my %polygons = ("pentagon" => 5, "hexagon" => 6, "octagon" => 8);
    my $shape = $1 eq "circumference" ? "circle" : $2;
    my $answerPrefix = "Perimeter of $shape: ";
    my $answer;

    if ($shape eq "square") {
        $answer = $3 * 4;
    } elsif ($shape eq "rectangle") {
        $answer = ($3 * 2) + ($5 * 2)
    } elsif ($shape eq "triangle") {
        $answer = $3 + $5 + $7;
    } elsif ($shape eq "circle") {
        $answerPrefix = "Circumference: ";
        $answer = (2 * pi) * ($1 eq "perimeter" ? $3 : $2);
    } else {
		if (substr $shape, index($shape, "agon") eq "agon") {
			$answer = $3 * $polygons{$shape};
		}
	}

    $answer_results = $answerPrefix.$answer;
    $answer_type = "perimeter";
}
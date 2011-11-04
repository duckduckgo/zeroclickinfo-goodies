# Calculates the perimeter of a square, rectangle, triangle, regular pentagon, regular hexagon, 
# regular octagon or the circumference of a circle with given specified edges/radius.
use Math::Trig;

if (!$type && $q_check_lc =~ m/^(?:circumference (?:of\scircle\s|)(?:circle\s|)(\d+(?:\.\d+)?))|(?:(perimeter) (?:of\s|)(?:(square|circle|pentagon|hexagon|octagon) (\d+(?:\.\d+)?)|(rectangle) (\d+(?:\.\d+)?)\s(\d+(?:\.\d+)?)|(triangle) (\d+(?:\.\d+)?)\s(\d+(?:\.\d+)?)\s(\d+(?:\.\d+)?)))$/) {
	my %polygons = ("pentagon" => 5, "hexagon" => 6, "octagon" => 8);
    my $shape = $1 ? "circle" : $3 || $5 || $8;
	
	my $answerPrefix = "Perimeter of $shape: ";
    my $answer;

    if ($shape eq "square") {
        $answer = $4 * 4;
    } elsif ($shape eq "rectangle") {
        $answer = ($6 * 2) + ($7 * 2)
    } elsif ($shape eq "triangle") {
        $answer = $9 + $10 + $11;
    } elsif ($shape eq "circle") {
        $answerPrefix = "Circumference: ";
        $answer = (2 * pi) * ($1 || $4);
    } else {
		if (substr $shape, index($shape, "agon") eq "agon") {
			$answer = $4 * $polygons{$shape};
		}
	}

    $answer_results = $answerPrefix.$answer;
    $answer_type = "perimeter";
}
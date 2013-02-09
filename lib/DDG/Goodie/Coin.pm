package DDG::Goodie::Coin;

use DDG::Goodie;

triggers start => 'flip', 'toss', 'coin';

handle query_lc => sub {
	return unless my ($a, $n) = $_ =~ /^((?:flip|toss) a coin|(?:flip|toss) (\d{0,2}) coins?)$/;
	my @output;
	my @ht = ("heads", "tails");
	my $flips = 1;
	my $flip;
	my $b = "flip a coin";
	my $c = "toss a coin";
	my $count;

	$n = 1 if ($a eq $b||$a eq $c);

	if($n >= 1) {
		for ($count = 1; $count <= $n; $count++) {
			$flip = $ht[int rand @ht];
			push @output, $flip;
		}
	}
	return join(', ', @output) .  ' (random)' if @output;
};

1;

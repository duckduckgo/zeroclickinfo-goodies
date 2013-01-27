package DDG::Goodie::Coin;

use DDG::Goodie;

triggers start => 'flip', 'coin', 'coins';

handle query_lc => sub {
  return unless my ($a, $n) = $_ =~ /^(flip a coin|flip (\d{0,2}) coins?)$/;
	my @output;
	my @ht = ("heads", "tails");
	my $flips = 1;
	my $flip;
	my $b = "flip a coin";
	my $count;

	if($a eq $b) {
		$n = 1;
	}

	if($n >= 1) {
		for ($count = 1; $count <= $n; $count++) {
			$flip = $ht[int rand @ht];
			push @output, $flip;
		}
	}
	return join(' ', @output, '(random)') if @output;
};

1;

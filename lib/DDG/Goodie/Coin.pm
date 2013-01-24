package DDG::Goodie::Coin;

use DDG::Goodie;

triggers start => 'flip', 'coin';

handle remainder => sub {
  return unless my ($a, $n) = $_ =~ /^(flip a coin|flip (/d{0,2) coins?)$/;
	my @output;
	my @ht = ('heads', 'tails');
	my $flips = 1;
	my $option = 2;
	my $flip;

	if($a = "flip a coin" || "heads or tails") {
		$n = 1;
	}

	if($n >= 1) {

		for (1 .. $flips) {
			$flip = int(rand(@choices));
			#$flip = $a[int rand($#a)];
			push @output, $flip;
		}
	}
	return join(' ', @output) if @output;
}

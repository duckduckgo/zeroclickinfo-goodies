package DDG::Goodie::Coin;

use DDG::Goodie;

triggers start => 'flip', 'toss', 'coin', 'heads';

primary_example_queries 'flip a coin', 'toss a coin';
secondary_example_queries 'flip 4 coins', 'heads or tails';

description 'flip a coin';
name 'Coin Flip';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Coin.pm';
topics 'trivia';
category 'random';
attribution github => [ 'http://github.com/mattlehning', 'mattlehning' ];

my $css = share("style.css")->slurp();
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
}

handle query_lc => sub {
	my $flips;
	if ($_ =~ /^(heads or tails[ ]?[\?]?)|((flip|toss) a coin)$/) {
		$flips = 1;
	}
	elsif ($_ =~ /^(?:flip|toss) (\d{0,2}) coins?$/) {
		$flips = $1;
	}
	
	return unless ($flips);
	
	my @output;
	my @ht = ("heads", "tails");

	for (1..$flips) {
		my $flip = $ht[int rand @ht];
		push @output, $flip;
	}

	my $result = join(', ', @output) .  ' (random)' if @output;
	return ($result, html => append_css($result)) if @output;
	return;
};

1;

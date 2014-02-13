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

handle query_lc => sub {
	my $flips;
	my $ru = 0;

	if ($_ =~ /^(heads or tails[ ]?[\?]?)|((flip|toss) a coin)$/) {
		$flips = 1;
	}
	elsif ($_ =~ /^(ор[её]л или решка[ ]?[\?]?)|((подбросить|кинуть) монет[к]?у)$/) {
		$flips = 1;
		$ru = 1;
	}
	elsif ($_ =~ /^(?:flip|toss) (\d{0,2}) coins?$/) {
		$flips = $1;
	}
	elsif ($_ =~ /^(?:подбросить|кинуть) (\d{0,2}) монет(у|ку|ы|ки|ок)?$/) {
		$flips = $1;
		$ru = 1;
	}

	return unless ($flips);


	my @output;
	my @ht;
	
	if ($ru == 1) {
		@ht = ("орёл", "решка")
	} else {
		@ht = ("heads", "tails");
	}
	

	for (1..$flips) {
		my $flip = $ht[int rand @ht];
		push @output, $flip;
	}
	
	
	if ($ru == 1) {
		return join(', ', @output) .  ' (случайно)' if @output;
	}

	return join(', ', @output) .  ' (random)' if @output;
};

1;

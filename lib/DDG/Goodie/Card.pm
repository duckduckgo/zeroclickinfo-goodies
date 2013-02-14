package DDG::Goodie::Card;

use DDG::Goodie;
use utf8;

triggers start => 'choose', 'pick', 'card', 'pull';

handle query_lc => sub {
  return unless my ($a, $n) = $_ =~ /^((?:choose|pick|pull)\s+a\s+card|(?:pick|choose|pull)\s+(\d{0,2})\s+cards?)$/;
	my @output;
        my @choices = ("ace of spades 🂡",  "2 of spades 🂢", "3 of spades 🂣", "4 of spades 🂤", "5 of spades 🂥", "6 of spades 🂦", "7 of spades 🂧", "8 of spades 🂨", "9 of spades 🂩", "10 of spades 🂪", "jack of spades 🂫", "queen of spades 🂭", "king of spades 🂮", "ace of diamonds 🃁",  "2 of diamonds 🃂", "3 of diamonds 🃃", "4 of diamonds 🃄", "5 of diamonds 🃅", "6 of diamonds 🃆", "7 of diamonds 🃇", "8 of diamonds 🃈", "9 of diamonds 🃉", "10 of diamonds 🃊", "jack of diamonds 🃋", "queen of diamonds 🃍", "king of diamonds 🃎", "ace of hearts 🂱", "2 of hearts 🂲", "3 of hearts         🂳", "4 of hearts 🂴", "5 of hearts 🂵", "6 of hearts 🂶", "7 of hearts 🂷", "8 of hearts 🂸", "9 of hearts 🂹", "10 of hearts 🂺", "jack of hearts 🂻", "queen of hearts 🂽", "king of hearts 🂾", "ace of clubs 🂾", "2 of clubs 🃒", "3 of clubs 🃓", "4 of clubs 🃔", "5 of clubs 🃕", "6 of clubs 🃖", "7 of clubs 🃗", "8 of clubs 🃘", "9 of clubs 🃙", "10 of clubs 🃚", "jack of clubs 🃛", "queen of clubs 🃝", "king of clubs 🃞");

	my $cards = 1;
	my $card;
	my $b = "pick a card";
	my $c = "choose a card";
	my $d = "pull a card";
	my $count;

	$n = 1 if($a eq $b||$a eq $c||$a eq $d);

	if($n >= 1) {
		for ($count = 1; $count <= $n; $count++) {
			$card = $choices[int rand @choices];
			push @output, $card;
		}
	}
	return join(', ', @output) . ' (random)' if @output;
};

1;

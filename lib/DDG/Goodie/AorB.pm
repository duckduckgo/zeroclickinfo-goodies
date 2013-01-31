package DDG::Goodie::AorB;

use DDG::Goodie;

triggers any => "pick", "choose", "or";

zci answer_type => "rand";

handle query_lc => sub {
	return unless /^(?:pick|choose)?\s*((?:[^\s]+)(?:\s+[^\s]+)*(?:\s+or\s+(?:[^\s]+))+)$/;
	my @query = split(' ', $1);
	my @del = grep{ $query[$_] eq 'or' } 0..$#query;
	my $pick;
	my $a = 0;
	for (@del) {
		splice(@query, $_-$a, 1);
		$a++;
	}

	$pick = $query[int rand @query];
	return $pick." (random)";

};

1;

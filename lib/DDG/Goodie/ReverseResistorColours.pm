package DDG::Goodie::ReverseResistorColours;
#ABSTRACT: Do the reverse of what ResistorColors.pm does.

use DDG::Goodie;
use utf8;

triggers query_raw => qr/^resistors?|resistors?$/i;

zci is_cached => 1;
zci answer_type => 'ohms';

primary_example_queries 'red yellow white gold resistor';
secondary_example_queries 'resistor red yellow white';
description 'find resistance based on colour bands';
name 'ReverseResistorColours';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/lib/DDG/Goodie/ReverseResistorColours.pm';
category 'reference';
topics 'science';

my %coloursToDigits = (
	'black'  => { value => 0,   tolerance => ''  },
	'brown'  => { value => 1,   tolerance => 1,  },
	'red'    => { value => 2,   tolerance => 2   },
	'orange' => { value => 3,   tolerance => ''  },
	'yellow' => { value => 4,   tolerance => 5   },
	'green'  => { value => 5,   tolerance => .5  },
	'blue'   => { value => 6,   tolerance => .25 },
	'violet' => { value => 7,   tolerance => .1  },
	'grey'   => { value => 8,   tolerance => .05 },
	'white'  => { value => 9,   tolerance => ''  },
	'gold'   => { value => '',  tolerance => 5   },
	'silver' => { value => '',  tolerance => 10  },
);

handle query_raw => sub {
	s/gray/grey/g; #learn how to spell 'grey' right
	s/purple/violet/g; #because we can say both
	s/ ?resistors? ?//;
	my $count = 0;
	my $resistance = 0;
	my @colours = (split(' ', $_));
	my $marginE = 0;
	my $append = '';
	if ((scalar(@colours) != 3) && (scalar(@colours) != 4)) { return };
	foreach my $colour (@colours) {
		if (!exists $coloursToDigits{$colour}) { return };
	}
	$resistance += ($coloursToDigits{$colours[0]}{value} * 10);
	$resistance += $coloursToDigits{$colours[1]}{value};
	for (my $i = 0; $i < $coloursToDigits{$colours[2]}{value}; $i++) {
		$resistance = $resistance * 10;
	}
	my $mult = $coloursToDigits{$colours[2]}{value};
	if (exists $colours[3]) {
		$marginE = $coloursToDigits{$colours[3]}{tolerance};
	} else {
		$marginE = 20;
	}
	if ($resistance > 1000 && $resistance < 999999) {
		$resistance = $resistance / 1000;
		$append = 'k';
	}
	if ($resistance > 1000000 && $resistance < 999999999) {
		$resistance = $resistance / 1000000;
		$append = 'M';
	}
	if ($resistance > 1000000000) {
		$resistance = $resistance / 1000000000;
		$append = "G";
	}
	#U+2126 is the ohm symbol, U+00B1 is the plus-minus sign.
	my $answer = "A $_ resistor has a resistance of $resistance $append\x{2126} \x{00B1} $marginE\%.";
	my $source = '<a href="https://en.wikipedia.org/wiki/Electronic_color_code">More at Wikipedia</a>';

	return $answer, html => "$answer $source";
};

1;

package DDG::Goodie::Geometry;
# ABSTRACT: Provides a formula shower / calculator for geometry

use utf8;
use Math::Trig;
use DDG::Goodie;

primary_example_queries 'geometry square';
secondary_example_queries 'formula for circle area', 'geometry cube volume size: 4';
triggers startend => 'geometry', 'formula', 'calc';

name 'Geometry';
description 'Little calculator and formula shower for geometric formulas';
category 'formulas';

sub getParameter {
	my ($trigger, $string, $count) = @_;
	unless($count){
		if($string =~ /(?:$trigger)\s?[=:]?\s?(\d+((\.|,)\d+)?)/){
			#(?:$m)\s?[=:]?\s? => matches the name of the formula, following by optional whitespace, = or :, whitespace
			#(\d+((\.|,)\d+)?) => matches the number, optional with a decimal point (point or comma) and numbers after it
			#store the number in $number
			my $number = $1;
			#changes a comma to a point because in some countrys people use a comma instead a point as a decimal point
			$number =~ s/,/\./;
			return $number;
			#return the number as scalar
		}
	} elsif($string =~ /($trigger)\s?[=:]?\s?\d+((\.|,)\d+)?(,\s\d+([.,]\d+)?){$count}/){
		#there schould be $n + 1 numbers defined
		#(?:$m)\s?[=:]?\s? => matches the name of the formula, following by optional whitespace, = or :, whitespace
		#(\d+((\.|,)\d+)?) => matches the first number, optional with a decimal point (point or comma) and numbers after it
		#(,\s\d+([.,]\d+)?){$n} => matches all other numbers, optional with a decimal point (point or comma) and numbers after it
		my @number = split(/,\s/, $&);
		#splits the numbers
		$number[0] =~ s/($trigger)\s?[=:]?\s?//;
		#removes the name of the formula, following by optional whitespace, = or :, optional whitespace
		for(my $i = 0; $i <= $count; ++$i){
			$number[$i] =~ s/,/\./;
			#changes a comma to a point because in some countrys people use a comma instead a point as a decimal point for each number
		}
		return @number;
		#return the numbers as array
	}
	return 0;
}

sub makehtml {
	my ($html, $svg) = @_;
	return '<div id="zci--geometry-formulas" class="text--primary">'.$html.'</div><svg id="zci--geometry-svg" viewBox="-5 -5 170 130" style="display: none">'.$svg.'</svg>';
}

#schema: <name> => [<trigger>, <symbol>]
my %formulas = (
	'volume' => ['volume', 'V'],
	'area' => ['area|fläche', 'A'],
	'surface' => ['area|surface|fläche', 'A'],
	'circumference' => ['perimeter|circumference|umfang', 'u'],
	'diagonal' => ['diagonal', 'e']
);
#schema: <name> => [<trigger>, svg, [hash]<formulas>, [sub]<parameter>]
#schema of <formula>: <name> => [string representing formula, html representing formula, sub calculating formula]
my %shapes = (
	'square' => ['square|quadrat',
		'<path d="M 0,0 h 120 v 120 h -120 z" class="fill" data-formula="A"></path>
			<path d="M 0,0 h 120 m 0,120 h -120 m 120,0 v -120 m -120,0 v 120" class="stroke" data-formula="u"></path>
			<path d="M 0,0 l 120,120" class="stroke special" data-formula="e"></path>', {
		'area' => ['a'.chr(178), 'a<sup>2</sup>', sub {
			return $_[0] ** 2;
		}],
		'circumference' => ['4a', '4a', sub {
			return 4 * $_[0];
		}],
		'diagonal' => ['a'.chr(8730).'2', 'a&radic;2', sub {
			return $_[0] * sqrt(2);
		}]
	}, sub {
		return getParameter('a|length|size', $_[0]);
	}],
	'rect' => ['rect|rechteck',
		'<path d="M 0,0 h 160 v 120 h -160 z" class="fill" data-formula="A"></path>
			<path d="M 0,0 h 160 m 0,120 h -160 m 160,0 v -120 m -160,0 v 120" class="stroke" data-formula="u"></path>
			<path d="M 0,0 l 160,120" class="stroke special" data-formula="e"></path>', {
		'area' => ['ab', 'ab', sub {
			return $_[0] * $_[1];
		}],
		'circumference' => ['2(a+b)', '2(a+b)', sub {
			return 2 * ($_[0] + $_[1]);
		}],
		'diagonal' => [chr(8730).'a'.chr(178).'+b'.chr(178), '&radic;a<sup>2</sup>+b<sup>2</sup>', sub {
			return sqrt($_[0] ** 2 + $_[1] ** 2);
		}]
	}, sub {
		my ($a, $b) = getParameter('length|size', $_[0], 1);
		$a = getParameter('a', $_[0]) unless $a;
		$b = getParameter('b', $_[0]) unless $b;
		return ($a, $b) if $a and $b;
	}],
	'equilateral triangle' => ['equilateral triangle|gleichseitiges dreieck',
		'<path d="M 70,0 l 70,120 m -140,0 l 70,-120 m 70,120 h -140" class="stroke" data-formula="u"></path>
			<path d="M 70,0 l 70,120 h -140 z" class="fill" data-formula="A"></path>', {
		'area' => ['(a'.chr(178).'*'.chr(8730).'3)/4', '(a<sup>2</sup>*&radic;3)/4', sub {
			return $_[0] / 4 * sqrt(3);
		}],
		'circumference' => ['3a', '3a', sub {
			return $_[0] * 3;
		}]
	}, sub {
		return getParameter('a|length|size', $_[0]);
	}],
	'circle' => ['circle|kreis',
		'<circle cx="60" cy="60" r="60" class="fill" data-formula="A"></circle>
			<circle cx="60" cy="60" r="60" class="stroke" data-formula="u"></circle>', {
		'area' => [chr(960).'r'.chr(178), '&pi;r<sup>2</sup>', sub {
			return pi * $_[0] ** 2;
		}],
		'circumference' => ['2'.chr(960).'r', '2&pi;r', sub {
			return 2 * pi * $_[0];
		}]
	}, sub {
		my $r = getParameter('radius|r', $_[0]);
		$r = getParameter('diameter|d', $_[0]) / 2 unless $r;
		return $r if $r;
	}],
	'cube' => ['cube|würfel',
		'<path d="M 0,120 v -80 l 40,-40 h 80 v 80 l -40 40 z" class="fill" data-formula="A"></path>
			<path d="M 0,120 l 40,-40 v -80 v 80 h 80" class="stroke backface"></path>
			<path d="M 0,40 l 120,40" class="stroke special" data-formula="e"></path>
			<path d="M 0,120 v -80 l 40,-40 h 80 v 80 l -40 40 z" class="fill" data-formula="V"></path>
			<path d="M 0,40 h 80 v 80 h -80 v -80 l 40,-40 h 80 v 80 l -40,40 v -80 l 40,-40" class="stroke"></path>', {
		'volume' => ['a'.chr(179), 'a<sup>3</sup>', sub {
			return $_[0] ** 3;
		}],
		'surface' => ['6a'.chr(178), '6a<sup>2</sup>', sub {
			return 6 * $_[0] ** 2;
		}],
		'diagonal' => ['a'.chr(8730).'3', 'a&radic;3', sub {
			return $_[0] * sqrt(3);
		}]
	}, sub {
		return getParameter('a|length|size', $_[0]);
	}],
	'cuboid' => ['cuboid|quader',
		'<path d="M 0,120 v -80 l 40,-40 h 120 v 80 l -40 40 z" class="fill" data-formula="A"></path>
			<path d="M 0,120 l 40,-40 v -80 v 80 h 120" class="stroke backface"></path>
			<path d="M 0,40 l 160,40" class="stroke special" data-formula="e"></path>
			<path d="M 0,120 v -80 l 40,-40 h 120 v 80 l -40 40 z" class="fill" data-formula="V"></path>
			<path d="M 0,40 h 120 v 80 h -120 v -80 l 40,-40 h 120 v 80 l -40,40 v -80 l 40,-40" class="stroke"></path>', {
		'volume' => ['abc', 'abc',  sub {
			return $_[0] * $_[1] * $_[2];
		}],
		'surface' => ['2(ab + ac + bc)', '2(ab + ac + bc)', sub {
			return 2 * ($_[0] * $_[1] + $_[0] * $_[2] + $_[1] * $_[2]);
		}],
		'diagonal' => [chr(8730).'(a'.chr(178).' + b'.chr(178).' + c'.chr(178).')', '&radic;(a<sup>2</sup> + b<sup>2</sup> + c<sup>2</sup>)', sub {
			return 2 * ($_[0] * $_[1] + $_[0] * $_[2] + $_[1] * $_[2]);
		}]
	}, sub {
		my ($a, $b, $c) = getParameter('size|length', $_[0], 2);
		$a = getParameter('a', $_[0]) unless $a;
		$b = getParameter('b', $_[0]) unless $b;
		$c = getParameter('c', $_[0]) unless $c;
		return ($a, $b, $c) if $a and $b and $c;
	}],
	'ball' => ['ball|kugel',
		'<circle class="fill" cx="60" cy="60" r="60" data-formula="A"></circle>
			<path d="M 0,60 a 30 10 0 0 1 120,0" class="stroke backface"></path>
			<circle class="fill" cx="60" cy="60" r="60" data-formula="V"></circle>
			<path d="M 0,60 a 30 10 0 1 0 120,0 a 25 25 0 0 0 -120,0 a 25 25 0 0 0 120,0" class="stroke"></path>', {
		'volume' => ['4/3'.chr(960).'r'.chr(179), '4/3&pi;r<sup>3</sup>', sub {
			return 4 / 3 * pi * $_[0] ** 3;
		}],
		'surface' => ['4'.chr(960).'r'.chr(178), '4&pi;r<sup>2</sup>', sub {
			return 4 * pi * $_[0] ** 2;
		}]
	}, sub {
		my $r = getParameter('radius|r', $_[0]);
		$r = getParameter('radius|r', $_[0]) / 2 unless $r;
		return $r unless $r;
	}]
);

handle remainder => sub {
	if(length $_ > 0){
		while(my($name, @shape) = each %shapes){
			if($_ =~ /$shape[0][0]/i){
				#is it the shape wanted?
				my ($text, $html) = '';
				my @parameter = $shape[0][3]($_);
				my $typeLabel;
				#get the parameter
				while(my($type, @formula) = each $shape[0][2]){
					#is it the formula wanted?
					if($_ =~ /$formulas{$type}[0]/i){
						#Yes, return the formula symbol + formula
						$text = $formulas{$type}[1].' = '.$formula[0][0];
						$html = $formulas{$type}[1].' = '.$formula[0][1];
						# + result if paremters are defined
						if($parameter[0] != 0){
							$text .= ' = '.$formula[0][2](@parameter);
							$html .= ' = '.$formula[0][2](@parameter);
						}
						#resets the iterators
						keys $shape[0][2];
						keys %shapes;
						return $text, html => makehtml($html, $shape[0][1]);
					}
					#No, append the formula symbol + formula
					$text .= ', ' if $text;

					$typeLabel = ucfirst($type); #Store the type with first letter as uppercase

					$text .= $typeLabel.': '.$formulas{$type}[1].' = '.$formula[0][0];
					$html .= '<div title="'.$typeLabel.'">';
					$html .= '<span>'.$typeLabel.':</span>'.$formulas{$type}[1].' = '.$formula[0][1];
					# + result if parameters are defined
					if($parameter[0] != 0){
						$text .= ' = '.$formula[0][2](@parameter);
						$html .= ' = '.$formula[0][2](@parameter);
					}
					$html .= '</div>';
					#to $result
				}
				#resets the iterators
				keys $shape[0][2];
				keys %shapes;
				#$result should be something like: 'A = ab, u = 2(a + b), e = chr(8730).'a'.chr(178).'+b'.chr(178)' (query: geometry rect)
				return $text, html => makehtml($html, $shape[0][1]);
			}
		}
	}

	return;
};
1;

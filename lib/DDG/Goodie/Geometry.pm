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

#schema: <name> => [<trigger>, <symbol>]
my %formulas = (
	'volume' => ['volume', 'V'],
	'area' => ['area|fläche', 'A'],
	'surface' => ['area|surface|fläche', 'A'],
	'perimeter' => ['perimeter|umfang', 'u'],
	'diagonal' => ['diagonal', 'e']
);
#schema: <name> => [<trigger>, [hash]<formulas>, [sub]<parameter>]
#schema of <formula>: <name> => [string representing formula, html representing formula, sub calculating formula]
my %shapes = (
	'square' => ['square|quadrat', {
		'area' => ['a'.chr(178), 'a<sup>2</sup>', sub {
			return $_[0] ** 2;
		}],
		'perimeter' => ['4a', '4a', sub {
			return 4 * $_[0];
		}],
		'diagonal' => ['a'.chr(8730).'2', 'a&radic;2', sub {
			return $_[0] * sqrt(2);
		}]
	}, sub {
		return getParameter('a|length|size', $_[0]);
	}],
	'rect' => ['rect|rechteck', {
		'area' => ['ab', 'ab', sub {
			return $_[0] * $_[1];
		}],
		'perimeter' => ['2(a+b)', '2(a+b)', sub {
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
	'equilateral triangle' => ['equilateral triangle|gleichseitiges dreieck', {
		'area' => ['(a'.chr(178).'*'.chr(8730).'3)/4', '(a<sup>2</sup>*&radic;3)/4', sub {
			return $_[0] / 4 * sqrt(3);
		}],
		'perimeter' => ['3a', '3a', sub {
			return $_[0] * 3;
		}]
	}, sub {
		return getParameter('a|length|size', $_[0]);
	}],
	'circle' => ['circle|kreis', {
		'area' => [chr(960).'r'.chr(178), '&pi;r<sup>2</sup>', sub {
			return pi * $_[0] ** 2;
		}],
		'perimeter' => ['2'.chr(960).'r', '2&pi;r', sub {
			return 2 * pi * $_[0];
		}]
	}, sub {
		my $r = getParameter('radius|r', $_[0]);
		$r = getParameter('diameter|d', $_[0]) / 2 unless $r;
		return $r if $r;
	}],
	'cube' => ['cube|würfel', {
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
	'cuboid' => ['cuboid|quader', {
		'volume' => ['abc', 'abc',  sub {
			return $_[0] * $_[1] * $_[2];
		}],
		'surface' => ['2(ab + ac + bc)', '2(ab + ac + bc)', sub {
			return 2 * ($_[0] * $_[1] + $_[0] * $_[2] + $_[1] * $_[2]);
		}]
	}, sub {
		my ($a, $b, $c) = getParameter('size|length', $_[0], 2);
		$a = getParameter('a', $_[0]) unless $a;
		$b = getParameter('b', $_[0]) unless $b;
		$c = getParameter('c', $_[0]) unless $c;
		return ($a, $b, $c) if $a and $b and $c;
	}],
	'ball' => ['ball|kugel', {
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
				my @parameter = $shape[0][2]($_);
				#get the parameter
				while(my($type, @formula) = each $shape[0][1]){
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
						keys $shape[0][1];
						keys %shapes;
						return $text, html => $html;
					}
					#No, append the formula symbol + formula
					if($text){
						$text .= ', ';
						$html .= '<br />';
					}
					$text .= $formulas{$type}[1].' = '.$formula[0][0];
					$html .= $formulas{$type}[1].' = '.$formula[0][1];
					# + result if paremters are defined
					if($parameter[0] != 0){
					 $text .= ' = '.$formula[0][2](@parameter);
					 $html .= ' = '.$formula[0][2](@parameter);
				 }
					#to $result
				}
				#resets the iterators
				keys $shape[0][1];
				keys %shapes;
				#$result should be something like: 'A = ab, u = 2(a + b), e = chr(8730).'a'.chr(178).'+b'.chr(178)' (query: geometry rect)
				return $text, html => $html;
			}
		}
	}

	return;
};
1;

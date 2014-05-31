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
 my ($m, $s, $n) = @_;
 unless($n){
  if($s =~ /(?:$m)\s?[=:]?\s?(\d+((\.|,)\d+)?)/){
   #(?:$m)\s?[=:]?\s? => matches the name of the formula, following by optional whitespace, = or :, whitespace
   #(\d+((\.|,)\d+)?) => matches the number, optional with a decimal point (point or comma) and numbers after it
   #store the number in $r
   my $r = $1;
   #changes a comma to a point because in some countrys people use a comma instead a point as a decimal point
   $r =~ s/,/\./;
   return $r;
   #return the number as scalar
  }
 } elsif($s =~ /($m)\s?[=:]?\s?\d+((\.|,)\d+)?(,\s\d+([.,]\d+)?){$n}/){
  #there schould be $n + 1 numbers defined
  #(?:$m)\s?[=:]?\s? => matches the name of the formula, following by optional whitespace, = or :, whitespace
  #(\d+((\.|,)\d+)?) => matches the first number, optional with a decimal point (point or comma) and numbers after it
  #(,\s\d+([.,]\d+)?){$n} => matches all other numbers, optional with a decimal point (point or comma) and numbers after it
  my @r = split(/,\s/, $&);
  #splits the numbers
  $r[0] =~ s/($m)\s?[=:]?\s?//;
  #removes the name of the formula, following by optional whitespace, = or :, whitespace
  for(my $i = 0; $i <= $n; ++$i){
   $r[$i] =~ s/,/\./;
   #changes a comma to a point because in some countrys people use a comma instead a point as a decimal point for each number
  }
  return @r;
  #return the numbers as array
 }
 return 0;
}

handle remainder => sub {
 if(length $_ > 0){
  #schema: <name> => [<trigger>, <symbol>]
  my %formulas = (
   'volume' => ['volume', 'V'],
   'area' => ['area|fläche', 'A'],
   'surface' => ['area|surface|fläche', 'A'],
   'perimeter' => ['perimeter|umfang', 'u'],
   'diagonal' => ['diagonal', 'e']
  );
  #schema: <name> => [<trigger>, [hash]<formulas>, [sub]<parameter>]
  #schema of <formula>: <name> => [string representing formula, sub calculating formula]
  my %shapes = (
   'square' => ['square|quadrat', {
    'area' => ['a'.chr(178), sub {
     return $_[0] ** 2;
    }],
    'perimeter' => ['4a', sub {
     return 4 * $_[0];
    }],
    'diagonal' => ['a'.chr(8730).'2', sub {
     return $_[0] * sqrt(2);
    }]
   }, sub {
    return getParameter('a|length|size', $_[0]);
   }],
   'rect' => ['rect|rechteck', {
    'area' => ['ab', sub {
     return $_[0] * $_[1];
    }],
    'perimeter' => ['2(a+b)', sub {
     return 2 * ($_[0] + $_[1]);
    }],
    'diagonal' => [chr(8730).'a'.chr(178).'+b'.chr(178), sub {
     return sqrt($_[0] ** 2 + $_[1] ** 2);
    }]
   }, sub {
    my ($a, $b) = getParameter('length|size', $_[0], 1);
    $a = getParameter('a', $_[0]) unless $a;
    $b = getParameter('b', $_[0]) unless $b;
    return ($a, $b) if $a and $b;
   }],
   'equilateral triangle' => ['equilateral triangle|gleichseitiges dreieck', {
    'area' => ['(a'.chr(178).'*'.chr(8730).'3)/4', sub {
     return $_[0] / 4 * sqrt(3);
    }],
    'perimeter' => ['3a', sub {
     return $_[0] * 3;
    }]
   }, sub {
    return getParameter('a|length|size', $_[0]);
   }],
   'circle' => ['circle|kreis', {
    'area' => [chr(960).'r'.chr(178), sub {
     return pi * $_[0] ** 2;
    }],
    'perimeter' => ['2'.chr(960).'r', sub {
     return 2 * pi * $_[0];
    }]
   }, sub {
    my $r = getParameter('radius|r', $_[0]);
    $r = getParameter('diameter|d', $_[0]) / 2 unless $r;
    return $r if $r;
   }],
   'cube' => ['cube|würfel', {
    'volume' => ['a'.chr(179), sub {
     return $_[0] ** 3;
    }],
    'surface' => ['6a'.chr(178), sub {
     return 6 * $_[0] ** 2;
    }],
    'diagonal' => ['a'.chr(8730).'3', sub {
     return $_[0] * sqrt(3);
    }]
   }, sub {
    return getParameter('a|length|size', $_[0]);
   }],
   'cuboid' => ['cuboid|quader', {
    'volume' => ['abc', sub {
     return $_[0] * $_[1] * $_[2];
    }],
    'surface' => ['2(ab + ac + bc)', sub {
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
    'volume' => ['4/3'.chr(960).'r'.chr(179), sub {
     return 4 / 3 * pi * $_[0] ** 3;
    }],
    'surface' => ['4'.chr(960).'r'.chr(178), sub {
     return 4 * pi * $_[0] ** 2;
    }]
   }, sub {
    my $r = getParameter('radius|r', $_[0]);
    $r = getParameter('radius|r', $_[0]) / 2 unless $r;
    return $r unless $r;
   }]
  );

  for my $s(keys %shapes){
   if($_ =~ /$shapes{$s}[0]/i){
    #is it the shape wanted?
    my $r = '';
    my @p = $shapes{$s}[2]($_);
    #get the parameter
    for my $f(keys $shapes{$s}[1]){
     #is it the formula wanted?
     if($_ =~ /$formulas{$f}[0]/i){
      #Yes, return the formula symbol + formula
      $r = $formulas{$f}[1].' = '.$shapes{$s}[1]{$f}[0];
      # + result if paremters are defined
      $r .= ' = '.$shapes{$s}[1]{$f}[1](@p) if $p[0] != 0;
      return $r;
     }
     #No, append the formula symbol + formula
     $r .= ', ' if $r;
     $r .= $formulas{$f}[1].' = '.$shapes{$s}[1]{$f}[0];
     # + result if paremters are defined
     $r .= ' = '.$shapes{$s}[1]{$f}[1](@p) if $p[0] != 0;
     #to $r
    }
    #return $r. $r should be something like: 'A = ab, u = 2(a + b), e = chr(8730).'a'.chr(178).'+b'.chr(178)' for query geometry rect
    return $r;
   }
  }
 }

 return;
};
1;

package DDG::Goodie::Geometry;
use Math::Trig;
use DDG::Goodie;

triggers start => 'geometry', 'formula', 'calc';

name 'Geometry';
description 'Little calculator and formula shower for geometric formulas';
category 'formulas';

sub getParameter {
 my ($t, $s, $n) = @_;
 unless($n){
  if($s =~ /(?:$t)\s?[=:]?\s?(\d+((\.|,)\d+)?)/){
   my $r = $1;
   $r =~ s/,/\./;
   return $r;
  }
 } elsif($s =~ /($t)\s?[=:]?\s?\d+((\.|,)\d+)?(,\s\d+([.,]\d+)?){$n}/){
  my @r = split(/,\s/, $&);
  $r[0] =~ s/($t)\s=?\s?//;
  for(my $i = 0; $i <= $n; ++$i){
   $r[$i] =~ s/,/\./;
  }
  return @r;
 }
 return 0;
}

handle remainder => sub {
 if(length $_ > 0){
  #match the shape / body
  if($_ =~ /circle/){
   #get the size of the shape
   my $r = getParameter('radius|r', $_);
   $r = getParameter('diameter|d', $_) / 2 unless $r;
   #match the formula
   if($_ =~ /area/){
    #return the solution if parameter is defined else return the formula itself
    return 'A = '.(pi * $r ** 2) if $r;
    return 'A = '.chr(960).'r'.chr(178);
   } elsif($_ =~ /perimeter/){
    return 'u = '.(2 * pi * $r) if $r;
    return 'u = 2'.chr(960).'r';
   }
   #could not match formula
  } elsif($_ =~ /square/){
   my $a = getParameter('a|length|size', $_);
   if($_ =~ /area/){
    return 'A = '.($a ** 2) if $a;
    return 'A = a'.chr(178);
   } elsif($_ =~ /perimeter/){
    return 'u = '.($a * 4) if $a;
    return 'u = 4a';
   }
  } elsif($_ =~ /rect/){
   my ($a, $b) = getParameter('length|size', $_, 1);
   $a = getParameter('a', $_);
   $b = getParameter('b', $_);
   if($_ =~ /area/){
    return 'A = '.($a * $b) if $a and $b;
    return 'A = ab';
   } elsif($_ =~ /perimeter/){
    return 'u = '.(2 * ($a + $b)) if $a and $b;
    return 'u = 2(a+b)';
   }
  } elsif($_ =~ /equilateral triangle/){
   my $a = getParameter('a|length|size', $_);
   if($_ =~ /area/){
    return 'A = '.($a / 4 * sqrt(3)) if $a;
    return 'A = (a'.chr(178).'*'.chr(8730).'3)/4';
   } elsif($_ =~ /perimeter/){
    return 'u = '.(3 * $a) if $a;
    return 'u = 3a';
   }
  } elsif($_ =~ /cube/){
   my $a = getParameter('a|length|size', $_);
   if($_ =~ /volume/){
    return 'V = '.($a ** 3) if $a;
    return 'V = a'.chr(179);
   } elsif($_ =~ /area|surface/){
    return 'A = '.(6 * $a ** 2) if $a;
    return 'A = 6a'.chr(178);
   } elsif($_ =~ /diagonal/){
    return 'd = '.($a * sqrt(3)) if $a;
    return 'd = a'.chr(8730).'3';
   }
  } elsif($_ =~ /cuboid/){
   my ($a, $b, $c) = getParameter('size|length', $_, 2);
   $a = getParameter('a', $_, 0) unless $a;
   $b = getParameter('b', $_, 0) unless $b;
   $c = getParameter('c', $_, 0) unless $c;
   if($_ =~ /volume/){
    return 'V = '.($a * $b * $c) if $a and $b and $c;
    return 'V = abc';
   } elsif($_ =~ /area|surface/){
    return 'A = '.(2 * ($a * $b + $a * $c + $b * $c)) if $a and $b and $c;
    return 'A = 2(ab + ac + bc)';
   }
  } elsif($_ =~ /ball/){
   my $r = getParameter('radius|r', $_);
   $r = getParameter('diameter|d', $_) / 2 unless $r;
   if($_ =~ /volume/){
    return 'V = '.(4 / 3 * pi * $r ** 3) if $r;
    return 'V = 4/3'.chr(960).'r'.chr(179);
   } elsif($_ =~ /area|surface/){
    return 'A = '.(4 * pi * $r ** 2) if $r;
    return 'A = 4'.chr(960).'r'.chr(178);
   }
  }
 }
 return;
};
1;

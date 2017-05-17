package DDG::Goodie::MolarMass;
# ABSTRACT: Calculates the molar mass of a chemical compound from its formula

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'molar_mass';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers start => 'molar mass of';


# Handle statement
handle remainder => sub {

    my $remainder = $_;

    # Optional - Guard against no remainder
    # I.E. the query is only 'triggerWord' or 'trigger phrase'
    #
    # return unless $remainder;

    # Optional - Regular expression guard
    # Use this approach to ensure the remainder matches a pattern
    # I.E. it only contains letters, or numbers, or contains certain words
    #
    # return unless qr/^\w+|\d{5}$/;

    my $mass = molar_mass($remainder);

    return "The molar mass of $remainder is $mass.",
        structured_answer => {

            data => {
                title    => $mass,
                subtitle => "The molar mass of $remainder"
            },

            templates => {
                group => 'text'
            }
        };
};

my %masses = (
  'H' => 1.008,
  'He' => 4.0026,
  'Li' => 6.94,
  'Be' => 9.01218,
  'B' => 10.81,
  'C' => 12.011,
  'N' => 14.007,
  'O' => 15.999,
  'F' => 18.9984,
  'Ne' => 20.1797,
  'Na' => 22.9898,
  'Mg' => 24.305,
  'Al' => 26.9815,
  'Si' => 28.085,
  'P' => 30.9738,
  'S' => 32.06,
  'Cl' => 35.45,
  'Ar' => 39.948,
  'K' => 39.0983,
  'Ca' => 40.078,
  'Sc' => 44.9559,
  'Ti' => 47.867,
  'V' => 50.9415,
  'Cr' => 51.9961,
  'Mn' => 54.938,
  'Fe' => 55.845,
  'Co' => 58.9332,
  'Ni' => 58.6934,
  'Cu' => 63.546,
  'Zn' => 65.38,
  'Ga' => 69.723,
  'Ge' => 72.63,
  'As' => 74.9216,
  'Se' => 78.971,
  'Br' => 79.904,
  'Kr' => 83.798,
  'Rb' => 85.4678,
  'Sr' => 87.62,
  'Y' => 88.9058,
  'Zr' => 91.224,
  'Nb' => 92.9064,
  'Mo' => 95.95,
  'Tc' => 97.0,
  'Ru' => 101.07,
  'Rh' => 102.906,
  'Pd' => 106.42,
  'Ag' => 107.868,
  'Cd' => 112.414,
  'In' => 114.818,
  'Sn' => 118.71,
  'Sb' => 121.76,
  'Te' => 127.6,
  'I' => 126.904,
  'Xe' => 131.293,
  'Cs' => 132.905,
  'Ba' => 137.327,
  'La' => 138.905,
  'Ce' => 140.116,
  'Pr' => 140.908,
  'Nd' => 144.242,
  'Pm' => 145.0,
  'Sm' => 150.36,
  'Eu' => 151.964,
  'Gd' => 157.25,
  'Tb' => 158.925,
  'Dy' => 162.5,
  'Ho' => 164.93,
  'Er' => 167.259,
  'Tm' => 168.934,
  'Yb' => 173.054,
  'Lu' => 174.967,
  'Hf' => 178.49,
  'Ta' => 180.948,
  'W' => 183.84,
  'Re' => 186.207,
  'Os' => 190.23,
  'Ir' => 192.217,
  'Pt' => 195.084,
  'Au' => 196.967,
  'Hg' => 200.592,
  'Tl' => 204.38,
  'Pb' => 207.2,
  'Bi' => 208.98,
  'Po' => 209.0,
  'At' => 210.0,
  'Rn' => 222.0,
  'Fr' => 223.0,
  'Ra' => 226.0,
  'Ac' => 227.0,
  'Th' => 232.038,
  'Pa' => 231.036,
  'U' => 238.029,
  'Np' => 237.0,
  'Pu' => 244.0,
  'Am' => 243.0,
  'Cm' => 247.0,
  'Bk' => 247.0,
  'Cf' => 251.0,
  'Es' => 252.0,
  'Fm' => 257.0,
  'Md' => 258.0,
  'No' => 259.0,
  'Lr' => 262.0,
  'Rf' => 267.0,
  'Db' => 270.0,
  'Sg' => 271.0,
  'Bh' => 270.0,
  'Hs' => 277.0,
  'Mt' => 276.0,
  'Ds' => 281.0,
  'Rg' => 282.0,
  'Cn' => 285.0,
  'Uut' => 285.0,
  'Fl' => 289.0,
  'Uup' => 2889.0,
  'Lv' => 293.0,
  'Uus' => 294.0,
  'Uuo' => 294.0
);

sub is_int {
  my ($val) = @_;
  return ($val =~ m/^\d+$/);
}

sub is_compound {
  my ($cmp) = @_;
  return ($cmp =~ /[a-z]|[A-Z]/);
}

sub parse {
  my ($string) = @_;
  my @stack = [];
  my @a = [];
  push @stack, @a;
  for my $c (split //, $string) {
    if ($c eq '(') {
      my @arr = [];
      push @stack, @arr;
    } elsif ($c eq ')') {
      my $temp = pop @stack;
      push $stack[-1], $temp;
    } elsif (is_int($c)) {
      if (is_int($stack[-1][-1])) {
        $stack[-1][-1] = $stack[-1][-1] * 10 + $c;
      } else {
        push $stack[-1], $c;
      }
    } elsif ($c =~ /[a-z]/) {
      $stack[-1][-1] = $stack[-1][-1] . $c;
    } else {
      push $stack[-1], $c;
    }
  }
  return $stack[-1];
}

sub calculate_mass {
  my @arr = @{$_[0]};
  my $arr_len = scalar(@arr);
  my $mass = 0;
  for my $i (0..$arr_len - 1) {
    if ($i == $arr_len - 1) {
      $mass = $mass + calculate_mass($arr[$i]) if ref($arr[$i]) eq 'ARRAY';
      $mass = $mass + $masses{$arr[$i]} if exists $masses{$arr[$i]}
    } elsif (ref($arr[$i]) eq 'ARRAY' && is_int($arr[$i+1])) {
      $mass += calculate_mass($arr[$i]) * $arr[$i+1];
    } elsif (ref($arr[$i]) eq 'ARRAY') {
      $mass += calculate_mass($arr[$i]);
    } elsif (is_compound($arr[$i]) && is_int($arr[$i+1])) {
      $mass += $masses{$arr[$i]} * $arr[$i+1] if exists $masses{$arr[$i]};
    } elsif (exists $masses{$arr[$i]}) {
      $mass += $masses{$arr[$i]};
    }
  }
  return $mass;
}

sub molar_mass {
  my ($str) = @_;
  return calculate_mass(parse($str));
}

1;

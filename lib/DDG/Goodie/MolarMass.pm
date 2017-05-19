package DDG::Goodie::MolarMass;
# ABSTRACT: Calculates the molar mass of a chemical compound from its formula

# TODO: Sanatize input
#       Increase Mass Accuracy from a better source
#       Write Tests

use DDG::Goodie;
use strict;
use warnings;
use Math::Round

zci answer_type => 'molar_mass';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers start => 'molar mass of', 'atomic mass of';


# Handle statement
handle remainder => sub {

    my $remainder = $_;

    return unless $remainder;

    my $mass = molar_mass($remainder);

    return if $mass == -1;

    return "The molar mass of $remainder is $mass g/mol.",
        structured_answer => {

            data => {
                title    => "$mass g/mol",
                subtitle => "$remainder"
            },

            templates => {
                group => 'text'
            }
        };
};

# Masses taken from http://www.csudh.edu/oliver/chemdata/atmass.htm, superheavy 
#       elements added manually with alternate names
my %masses = (
    'Ac' => 227.028,
    'Al' => 26.9815395,
    'Am' => 243.0,
    'Sb' => 121.757,
    'Ar' => 39.9481,
    'As' => 74.921592,
    'At' => 210.0,
    'Ba' => 137.3277,
    'Bk' => 247.0,
    'Be' => 9.0121823,
    'Bi' => 208.980373,
    'Bh' => 262.0,
    'B' => 10.8115,
    'Br' => 79.904,
    'Cd' => 112.4118,
    'Ca' => 40.0789,
    'Cf' => 251.0,
    'C' => 12.0111,
    'Ce' => 140.1154,
    'Cs' => 132.905435,
    'Cl' => 35.45279,
    'Cr' => 51.99616,
    'Co' => 58.933201,
    'Cu' => 63.5463,
    'Cm' => 247.0,
    'Db' => 262.0,
    'Dy' => 162.503,
    'Es' => 252.0,
    'Er' => 167.263,
    'Eu' => 151.9659,
    'Fm' => 257.0,
    'F' => 18.99840329,
    'Fr' => 223.0,
    'Gd' => 157.253,
    'Ga' => 69.7231,
    'Ge' => 72.612,
    'Au' => 196.966543,
    'Hf' => 178.492,
    'Hs' => 265.0,
    'He' => 4.0026022,
    'Ho' => 164.930323,
    'H' => 1.007947,
    'In' => 114.821,
    'I' => 126.904473,
    'Ir' => 192.223,
    'Fe' => 55.8473,
    'Kr' => 83.801,
    'La' => 138.90552,
    'Lr' => 262.0,
    'Pb' => 207.21,
    'Li' => 6.9412,
    'Lu' => 174.9671,
    'Mg' => 24.30506,
    'Mn' => 54.938051,
    'Mt' => 266.0,
    'Md' => 258.0,
    'Hg' => 200.593,
    'Mo' => 95.941,
    'Nd' => 144.243,
    'Ne' => 20.17976,
    'Np' => 237.048,
    'Ni' => 58.6934,
    'Nb' => 92.906382,
    'N' => 14.006747,
    'No' => 259.0,
    'Os' => 190.21,
    'O' => 15.99943,
    'Pd' => 106.421,
    'P' => 30.9737624,
    'Pt' => 195.083,
    'Pu' => 244.0,
    'Po' => 209.0,
    'K' => 39.09831,
    'Pr' => 140.907653,
    'Pm' => 145.0,
    'Pa' => 231.0359,
    'Ra' => 226.025,
    'Rn' => 222.0,
    'Re' => 186.2071,
    'Rh' => 102.905503,
    'Rb' => 85.46783,
    'Ru' => 101.072,
    'Rf' => 261.0,
    'Sm' => 150.363,
    'Sc' => 44.9559109,
    'Sg' => 263.0,
    'Se' => 78.963,
    'Si' => 28.08553,
    'Ag' => 107.86822,
    'Na' => 22.9897686,
    'Sr' => 87.621,
    'S' => 32.0666,
    'Ta' => 180.94791,
    'Tc' => 98.0,
    'Te' => 127.603,
    'Tb' => 158.925343,
    'Tl' => 204.38332,
    'Th' => 232.03811,
    'Tm' => 168.934213,
    'Sn' => 118.7107,
    'Ti' => 47.883,
    'W' => 183.853,
    'U' => 238.02891,
    'V' => 50.94151,
    'Xe' => 131.292,
    'Yb' => 173.043,
    'Y' => 88.905852,
    'Zn' => 65.392,
    'Zr' => 91.2242,
    'Ds' => 281.0,
    'Rg' => 282.0,
    'Uub' => 285.0,
    'Uut' => 286.0,
    'Uuq' => 289.0,
    'Uup' => 290.0,
    'Uuh' => 293.0,
    'Uus' => 294.0,
    'Uuo' => 294.0,
    'Cn' => 285.0,
    'Nh' => 286.0,
    'Fl' => 289.0,
    'Mc' => 290.0,
    'Lv' => 293.0,
    'Ts' => 294.0,
    'Og' => 294.0
);

# returns true if input only comprised of numbers
sub is_int {
    my ($val) = @_;
    return ($val =~ m/^\d+$/);
}

# returns true if input only comprised of letters
sub is_compound {
    my ($cmp) = @_;
    return ($cmp =~ /^([a-z]|[A-Z])+$/);
}

# sanatize verifies that the input is suitable for processing.
# Sanatization Strategy:
#   - Check that formula is only comprised of alphanumerics and parentheses.
#   - Check number of right parens never exceeds number of left parens
#   - Check each number preceded by a letter, right parentheses, or another number.
#   - Check each lowercase char preceded by another lowercase char or an uppercase char.
# Returns -1 if any of these checks fail.
sub sanatize {
    my ($string) = @_;
    
    if (!($string =~ /^([a-z]|[A-Z]|[0-9]|["("]|[")"])+$/)) {
        return -1;
    }

    my $paren_count = 0;
    for my $c (split //, $string) {
        if ($c eq "(") {
            $paren_count += 1;
        } elsif ($c eq ")") {
            $paren_count -= 1;
        }
        if ($paren_count < 0) {
            return -1;
        }
    }

    my $prev = "NULL";
    for my $c2 (split //, $string) {
        if ($c2 =~ /[a-z]/ 
            && (!(is_compound($prev)) || ($prev eq "NULL"))) {
            return -1;
        } elsif (is_int($c2) 
            && !((is_compound($prev) && !($prev eq "NULL")) || $prev eq ")" || is_int($prev))) {
            return -1;
        }
        $prev = $c2;
    }

    return 0;
}

# verify_compounds verifies that every compound in the array is in the 
#   table of masses, returns -1 otherwise.
sub verify_compounds {
    my @arr = @{$_[0]};
    my $arr_len = scalar(@arr);
    for my $i (0..$arr_len - 1) {
        if (ref($arr[$i]) eq 'ARRAY') {
            return -1 if (verify_compounds($arr[$i]) == -1);
        } elsif (is_compound($arr[$i])) {
            return -1 if !(exists $masses{$arr[$i]});
        }
    }
    return 0;
}

# parse turns a string such as "Al2(SO4)3" into a nested array that looks
#   like ["Al",2,["S","O",4],3].
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
                # joins integer digits together if 
                #   $c is a digit of a larger integer
                $stack[-1][-1] = $stack[-1][-1] * 10 + $c;
            } else {
                push $stack[-1], $c;
            }
        } elsif ($c =~ /[a-z]/) {
            # joins lowercase letters to the last character before it
            # will not fail as long as input is sanitized.
            $stack[-1][-1] = $stack[-1][-1] . $c;
        } else {
            # this should be reached by capitalized characters
            push $stack[-1], $c;
        }
    }
    return $stack[-1];
}

# calc_mass calculates the molar mass of a nested array produced by parse.
sub calc_mass {
    my @arr = @{$_[0]};
    my $arr_len = scalar(@arr);
    my $mass = 0;
    for my $i (0..$arr_len - 1) {
        # Pseudocode:
        # First, check if $i is the last index of the array, because the rest
        #   of the algorithm depends on being able to check the i+1 th element.
        # 3 cases for the ith element: 
        #   1. it is a standalone element represented by a string
        #   2. it is a multi-element molecule that is represented by an array
        #   3. it is an integer, but we will handle integers in cases 1 and 2 
        #       so we can ignore $i if it is an integer.
        #  For cases 1 and 2, we need to check if the i+1th element is an 
        #       integer, if it is, we multiply by the i+1th integer

        if ($i == $arr_len - 1) {
            # Special handler for last index.
            $mass = $mass + calc_mass($arr[$i]) if ref($arr[$i]) eq 'ARRAY';
            $mass = $mass + $masses{$arr[$i]} if exists $masses{$arr[$i]}
        } elsif (ref($arr[$i]) eq 'ARRAY' && is_int($arr[$i+1])) {
            $mass += calc_mass($arr[$i]) * $arr[$i+1];
        } elsif (ref($arr[$i]) eq 'ARRAY') {
            $mass += calc_mass($arr[$i]);
        } elsif (is_compound($arr[$i]) && is_int($arr[$i+1])) {
            $mass += $masses{$arr[$i]}*$arr[$i+1] if exists $masses{$arr[$i]};
        } elsif (exists $masses{$arr[$i]}) {
            $mass += $masses{$arr[$i]};
        } # Other cases are ignored.
    }
    return $mass;
}

# returns the molar mass of the string passed to it
# returns -1 if some mass is not found, or if there is invalid input
sub molar_mass {
    # Note: sanatize and verify_compounds return -1 if given invalid input.
    my ($str) = @_;
    my $sanatize_result = sanatize($str);
    return -1 if ($sanatize_result == -1);
    my @temp_arr = parse($str);
    my $verified_result = verify_compounds(@temp_arr);
    return -1 if ($verified_result == -1);
    return nearest(0.0001, calc_mass(@temp_arr));
}

1;

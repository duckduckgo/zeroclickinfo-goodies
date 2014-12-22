package DDG::GoodieRole::Fraction;
# ABSTRACT: a Fraction object that represents a fraction containing a numerator and a denominator

use Moo::Role;

with 'DDG::GoodieRole::MathUtil';

sub new {
    my ($class, $num, $den) = @_;
    my $self = bless { numerator => $num, denominator => $den}, $class;
}

# function that adds a Fraction to this Fraction and returns a new Fraction representing the result of the addition
sub add {
    my $self = shift;
    my $new_num = $self->{numerator} * $_[0]->{denominator} + $self->{denominator} * $_[0]->{numerator};
    my $new_den = $self->{denominator} * $_[0]->{denominator};
    my $common = gcd($new_num, $new_den);
    my $common_result = DDG::GoodieRole::Fraction->new($new_num/$common, $new_den/$common);
    return $common_result;
}

# function that swaps the numerator and the denominator
sub inverse {
    my $self = shift;
    my $num = $self->{numerator};
    my $den = $self->{denominator};
    $self->{numerator} = $den;
    $self->{denominator} = $num;
}

sub to_string {
    my $self = shift;
    return "$self->{numerator}/$self->{denominator}\n";
}

1;

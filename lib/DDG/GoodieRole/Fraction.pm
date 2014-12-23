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
    my ($self, $other_fraction) = @_;
    my $new_num = $self->{numerator} * $other_fraction->{denominator} + $self->{denominator} * $other_fraction->{numerator};
    my $new_den = $self->{denominator} * $other_fraction->{denominator};
    my $common = greatest_common_divisor($new_num, $new_den);
    my $common_result = DDG::GoodieRole::Fraction->new($new_num/$common, $new_den/$common);
    return $common_result;
}

# function that swaps the numerator and the denominator
sub inverse {
    my $self = shift;
    ($self->{numerator}, $self->{denominator}) = ($self->{denominator}, $self->{numerator});
}

sub to_string {
    my $self = shift;
    return "$self->{numerator}/$self->{denominator}\n";
}

1;

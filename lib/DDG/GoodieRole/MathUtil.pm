package DDG::GoodieRole::MathUtil;
# ABSTRACT: a utility module containing math procedures

use Moo::Role;

with 'DDG::GoodieRole::Fraction';

# iterative euclid algorithm to compute the greatest common divisor of two numbers
# expects to integers as input
sub gcd($$) {
    my ($u, $v) = @_;
    while ($v) {
        ($u, $v) = ($v, $u % $v);
    }
    return abs($u);
}

# contains the terms produced by compute_terms_iter
# (a0, a1, a2,...,an)
my @terms;

# implements the continued fraction algorithm to compute the terms for the given number
sub compute_terms_iter {
    my ($number) = @_;
    while (1) {
        my $int_value = int($number);
        push @terms, $int_value;
        my $fraction_value = $number - $int_value;
        if ($number - $int_value < 1e-3) {
            last;
        }
        $number = 1/$fraction_value;
    }
}

# used in tandem with the compute_terms_iter function
# uses the continued fraction algorithm but works backwards using the terms to produce the final fraction result
sub compute_fraction {
    my @term_stack;
    my $f1 = DDG::GoodieRole::Fraction->new(1, pop @terms);
    my $f2 = DDG::GoodieRole::Fraction->new(pop @terms, 1);
    push @term_stack, $f1;
    push @term_stack, $f2;
    while (@term_stack) {
        $f1 = pop @term_stack;
        $f2 = pop @term_stack;
        my $result = $f1->add($f2);
        if (! @terms) {
            return $result->to_string();
        }
        $result->inverse();
        push @term_stack, $result;
        push @term_stack, DDG::GoodieRole::Fraction->new(pop @terms, 1);
    }
}

sub solve {
    my ($decimal_val) = @_;
    my $fraction_value = $decimal_val - int($decimal_val);
    if ($fraction_value == 0 || $fraction_value < 0.001) {
        return "";
    }
    compute_terms_iter($decimal_val);
    return compute_fraction();
}

1;

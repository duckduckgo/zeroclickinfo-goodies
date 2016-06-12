package DDG::Goodie::Calculator::Result;
# Defines the result form used by the Calculator Goodie to
# allow for more detailed and curated results.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(new_result
                     wrap_exact wrap_approx
                     produces_angle);
}

use Math::BigRat try => 'GMP';
use Math::Cephes qw(:explog);
use Math::Cephes qw(:trigs);
use Math::Round;
use Math::Trig qw(rad2deg);
use Moose;
use Moose::Util::TypeConstraints;
use utf8;
use List::Util qw(any);

use overload
    '""'    => 'to_string',
    # Basic arithmetic
    '+'     => 'add_results',
    '-'     => 'subtract_results',
    '*'     => 'multiply_results',
    '/'     => 'divide_results',
    '%'     => 'modulo_results',
    '**'    => 'exponent_results',
    # Comparisons
    '<=>'   => 'num_compare_results',
    # Trig
    'atan2' => 'atan2_results',
    # Misc functions
    'exp'   => 'exp_result',
    'log'   => 'log_result',
    'sqrt'  => 'sqrt_result',
    'int'   => 'int_result';

# If an irrational (or ungodly) number was produced, so a fraction
# should not be displayed.
has 'tainted' => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

# The wrapped value.
has 'value' => (
    is => 'rw',
);

subtype 'DDG::Goodie::Calculator::Angle',
    as 'Str',
    where { $_ =~ /^radian|degree$/ };

has 'angle_type' => (
    is      => 'ro',
    isa     => 'Maybe[DDG::Goodie::Calculator::Angle]',
    default => undef,
);

# Will want a more robust solution than this. Allows checking if user
# specified /explicitly/ that an angle was in radians.
has 'declared' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

sub is_degrees {
    my $self = shift;
    ($self->angle_type // '') eq 'degree'
};

sub is_radians {
    my $self = shift;
    ($self->angle_type // '') eq 'radian'
};

sub taint {
    my $self = shift;
    $self->{'tainted'} = 1;
}

sub untaint {
    my $self = shift;
    $self->{'value'} = to_rat($self->{'value'});
    $self->{'tainted'} = 0;
}

sub exact {
    my $num = shift;
    if ($num =~ /\.|e-|\//) {
        return Math::BigRat->new($num);
    } else {
        return Math::BigInt->new($num);
    }
}

sub wrap_exact {
    return new_result(value => exact(@_));
}

sub approx {
    my $num = shift;
    return Math::BigFloat->new($num);
}

sub wrap_approx {
    return new_result(value => approx(@_));
}

sub new_result { DDG::Goodie::Calculator::Result->new(@_) };

sub wrap_result {
    my $result = shift;
    return $result if ref $result eq 'DDG::Goodie::Calculator::Result';
    return wrap_exact($result);
}

# Ensure result is wrapped in a Calc::Result
sub with_wrap {
    my $sub = shift;
    sub { wrap_result($sub->(@_)) };
}

sub produces_angle {
    my $sub = shift;
    return sub {
        my $result = $sub->(@_);
        my $copy = $result->declare('angle');
        return $copy;
    };
}

sub to_string {
    my $self = shift;
    my $res = $self->value();
    return "$res" if defined $res;
}

# Tell the Calculator that the value is an angle in degrees.
sub make_degrees {
    my $self = shift;
    my $copy = $self->copy;
    $copy->{angle_type} = 'degree';
    return $copy;
}

sub make_angle {
    my ($self, $angle) = @_;
    my $copy = $self->copy;
    $copy->{angle_type} = $angle;
    return ($copy->declare('angle'))->declare($angle);
}

sub make_radians {
    my $self = shift;
    $self->make_angle('radian');
}
sub copy {
    my $self = shift;
    return new_result {
        tainted    => $self->tainted,
        value      => $self->value,
        angle_type => $self->angle_type,
        declared   => $self->declared,
    };
}

# Combine two Results using the given operation. Preserves appropriate
# attributes.
sub combine_results {
    my $sub = shift;
    return sub {
        my ($self, $other) = @_;
        my $tainted = $self->tainted || $other->tainted;
        my $angle = $self->angle_type;
        return unless ($self->angle_type // '') eq ($other->angle_type // '');
        my $first_val = $self->value();
        my $declared = $self->declared // $other->declared;
        my $second_val = $other->value();
        my $res = $sub->($first_val, $second_val);
        return new_result {
            tainted    => $tainted,
            value      => $res,
            angle_type => $angle,
            declared   => $declared,
        };
    };
}

sub upon_result {
    my $sub = shift;
    return with_wrap sub {
        my $self = shift;
        my $value = $self->value();
        my $res = $sub->($value);
        return $res;
    }
}

sub on_result { (upon_result($_[1]))->($_[0]) };

*on_decimal = with_wrap sub {
    my ($self, $sub) = @_;
    my $res = $sub->($self->as_decimal());
    return $res;
};

*add_results = combine_results(sub { $_[0] + $_[1] });
*subtract_results = combine_results(sub { $_[0] - $_[1] });
*multiply_results = combine_results(sub { $_[0] * $_[1] });
*divide_results = combine_results(sub { $_[0] / $_[1] });
*modulo_results = combine_results(sub { $_[0] % $_[1] });

sub num_compare_results {
    my ($self, $other) = @_;
    return $self->value()  <=> $other->value();
}

sub from_big {
    my $to_convert = shift;
    return $to_convert->numify() if ref $to_convert eq 'Math::BigRat';
    return $to_convert->bstr() if ref $to_convert eq 'Math::BigFloat';
    return $to_convert;
}

sub to_rat {
    my $num = shift;
    return $num if ref $num eq 'Math::BigRat';
    return Math::BigRat->new($num);
}

# Unwrap the arguments from Big{Float,Rat} for operations such as sine
# and log.
sub with_unwrap {
    my $sub = shift;
    return sub {
        my @args = @_;
        return $sub->(map { from_big($_) } @args);
    };
}

sub wrap_unwrap {
    my $sub = shift;
    return sub {
        return to_rat(with_unwrap($sub)->(@_));
    };
}

# ~~Little bit hacky for exponents because of the way Number::Fraction
# handles them. Basically have to deal with the case when the base and
# exponent are valid fractions, and the exponent is negative - other cases
# are handled fine by Number::Fraction.~~
#
# Issues with GMP and highly-precise fractions; this works
# around that but does mean certain queries are not as
# informative (though not incorrect).
#
# TODO: Make this work *fully* with *all* inputs.
sub exponentiate_fraction {
    return Math::BigRat->new(
        Math::BigFloat->new($_[0])->numify
        ** Math::BigFloat->new($_[1])->numify
    );
}

*exponent_results = combine_results \&exponentiate_fraction;
*atan2_results = combine_results \&atan2;
*exp_result = upon_result sub { exp $_[0] };
*log_result = upon_result sub { "@{[nearest(1e-15, log $_[0])]}" };
*sqrt_result = upon_result sub {
    my $val = shift;
    return sqrt ($val->as_float);
};
*int_result = upon_result sub { int $_[0] };

# logY(X)
*logbase = combine_results sub { floatify($_[0])->blog($_[1]) };

sub is_float {
    my $self = shift;
    return ref $self->value eq 'Math::BigFloat';
}

sub as_float {
    my $self = shift;
    if ($self->is_fraction) {
        return $self->value->as_float();
    } elsif ($self->is_float) {
        return $self->value->copy();
    } else {
        return Math::BigFloat->new($self->value);
    }
}

my $PI = Math::BigFloat->bpi();
sub deg2rad {
    my $to_convert = shift;
    return ($PI * $to_convert) / 180;
}

sub to_radians {
    my $self = shift;
    if ($self->is_degrees) {
        my $res = $self->on_decimal(\&deg2rad);
        return $res->make_radians();
    };
    $self->make_radians();
};

sub to_degrees {
    my $self = shift;
    my $is_radians = $self->is_radians();
    return $self if $self->is_degrees();
    if ($self->is_radians || $self->declares('angle')) {
        my $res = $self->on_decimal(\&rad2deg);
        return $res->make_degrees();
    };
    $self->make_degrees();
};

sub with_radians {
    my $sub = shift;
    return sub {
        my $self = shift;
        my $rads = $self->to_radians();
        return ($rads->on_result($sub))->rounded(1e-15);
    };
}

*rsin = with_radians(\&sin);
*rcos = with_radians(\&cos);

sub as_fraction_string {
    my $self = shift;
    my $show = "$self";
    my $value = $self->value();
    return "$value";
}

sub is_integer {
    my $self = shift;
    my $value = $self->value();
    return $value->is_int() if ref $value eq 'Math::BigRat';
    return $value =~ /^\d+$/;
}

sub is_fraction {
    my $self = shift;
    return ref $self->value() eq 'Math::BigRat';
}

sub as_rounded_decimal {
    my $self = shift;
    my $decimal = $self->value();
    my ($nom, $expt) = split 'e', $decimal;
    my ($s, $e) = split 'e', sprintf('%0.13e', $decimal);
    return nearest(1e-12, $s) * 10 ** $e;
}

sub rounded_float {
    my ($self, $round_to) = @_;
    return $self->as_float->bround($round_to);
}

sub angle_symbol {
    my $self = shift;
    if ($self->is_degrees) {
        return '°';
    } elsif ($self->is_radians) {
        return ' ㎭' if $self->declares('radian');
    };
    return '';
}

sub declare {
    my ($self, $to_declare) = @_;
    my $copy = $self->copy();
    my @declared = (@{$copy->{declared}}, $to_declare);
    $copy->{declared} = \@declared;
    return $copy;
}
sub declares {
    my ($self, $to_check) = @_;
    return any { $_ eq $to_check } @{$self->declared};
}

sub as_decimal {
    my $self = shift;
    my $value = $self->value();
    return $value->as_float->bstr() if ref $value eq 'Math::BigRat';
    return $value->bstr() if ref $value eq 'Math::BigFloat';
    return $value;
}

*rounded = with_wrap sub {
    my ($self, $round_to) = @_;
    return to_rat("@{[nearest($round_to, $self->as_decimal())]}");
};

sub contains_bad_result {
    my $self = shift;
    return $self->value() =~ /(inf|nan)/i;
}

__PACKAGE__->meta->make_immutable;

1;

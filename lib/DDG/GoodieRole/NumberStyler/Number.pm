package DDG::GoodieRole::NumberStyler::Number;
# Provides additional formatting options for numbers parsed by NumberStyler

use strict;
use warnings;

use Moo;

has format => (
    is => 'ro',
    isa => sub { die 'not a DDG::GoodieRole::NumberStyler::Format'
                    unless ref $_[0] eq 'DDG::GoodieRole::NumberStyler::Format'
               },
    required => 1,
);

has [qw(raw fractional_part integer_part exponent sign)] => (
    is => 'ro',
);

sub precision {
    my ($self, $number_text) = @_;
    return length $self->fractional_part;
}

sub _sign_text {
    my $self = shift;
    my $sign = $self->sign;
    $sign //= '+';
    return $sign eq '+' ? '' : $sign;
}

sub for_computation {
    my $self = shift;
    my $number_text = $self->raw;
    my ($integer_part, $fractional_part, $exponent) = (
        $self->integer_part,
        $self->fractional_part,
        $self->exponent,
    );
    my $joined = $self->_sign_text() . ($integer_part // 0) . '.' .
                 ($fractional_part // 0) .
                 'e' . (defined $exponent ? $exponent->for_computation() : '0');
    return Math::BigFloat->new($joined)->bstr();
}

sub _integer_part_for_display {
    my $self = shift;
    my $integer_part = $self->integer_part;
    my $thousands = $self->format->group_sign;
    $integer_part //= 0;
    $integer_part =~ s/^0+(?=[^0])//;
    if (length $integer_part > 3) {
        $integer_part = reverse $integer_part;
        $integer_part =~ s/(\d{3})(?!$)/$1$thousands/g;
        $integer_part = reverse $integer_part;
    }
    return $self->_sign_text() . $integer_part;
}

sub _mantissa_for_display {
    my $self = shift;
    my $fractional_part = $self->fractional_part;
    my $format = $self->format;
    my $decimal = $self->format->decimal_sign;
    return $self->_integer_part_for_display() .
            (defined $fractional_part ? $decimal . $fractional_part : '');
}

sub for_display {
    my $self = shift;
    my $exponent = $self->exponent;
    my $format = $self->format;
    my $for_display = $self->_mantissa_for_display();
    if (defined $exponent) {
        my $exp = $exponent->for_display();
        $for_display .= ' * 10 ^ ' . $exp;
    }
    return $for_display;
}

sub for_html {
    my $self = shift;
    my $html = $self->_mantissa_for_display();
    if (defined $self->exponent) {
        $html .= ' * 10<sup>' . $self->exponent->for_html() . '</sup>';
    }
    return $html;
}

sub _has_decimal {
    my $self = shift;
    return 1 if $self->raw =~ quotemeta($self->format->decimal_sign);
    return 0;
}

# Like 'for_display', but keep things like leading/trailing decimal marks
sub formatted_raw {
    my $self = shift;
    my $out = '';
    $out .= $self->_integer_part_for_display()
        if defined $self->integer_part;
    $out .= $self->format->decimal_sign if $self->_has_decimal();
    $out .= ($self->fractional_part // '');
    if (defined $self->exponent) {
        my $exp = $self->exponent->for_display();
        $out .= ' * 10 ^ ' . $exp;
    }
    return $out;
}

1;

__END__

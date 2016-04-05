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

has [qw(raw fractional_part integer_part exponent)] => (
    is => 'ro',
);

sub precision {
    my ($self, $number_text) = @_;
    return length $self->fractional_part;
}

sub for_computation {
    my $self = shift;
    my $number_text = $self->raw;
    my ($integer_part, $fractional_part, $exponent) = (
        $self->integer_part,
        $self->fractional_part,
        $self->exponent,
    );
    my $joined = ($integer_part // 0) . '.' .
                 ($fractional_part // 0) .
                 'e' . (defined $exponent ? $exponent->for_computation() : '0');
    return Math::BigFloat->new($joined)->bstr();
}

sub _mantissa_for_display {
    my $self = shift;
    my ($integer_part, $fractional_part) = (
        $self->integer_part,
        $self->fractional_part,
    );
    my $format = $self->format;
    my ($decimal, $thousands) = (
        $format->decimal,
        $format->thousands,
    );
    if (length $integer_part > 3) {
        $integer_part = reverse $integer_part;
        $integer_part =~ s/(\d{3})/$1$thousands/g;
        $integer_part = reverse $integer_part;
    }
    return ($integer_part // 0) . (defined $fractional_part ? $decimal . $fractional_part : '');
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

1;

__END__

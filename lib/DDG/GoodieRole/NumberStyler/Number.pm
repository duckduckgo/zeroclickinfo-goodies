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

has [qw(raw fractional_part integer_part exponent sign formatter)] => (
    is => 'ro',
);

has rounding_increment => (
    is      => 'rw',
    default => 1e-9,
);

sub precision {
    my ($self, $number_text) = @_;
    return length $self->fractional_part;
}

sub _sign_text {
    my $self = shift;
    my $sign = $self->sign;
    $sign ||= '+';
    return $sign eq $self->format->_cldr_number->plus_sign ? '' : '-';
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
    my $thousands = $self->format->_cldr_number->group_sign;
    $integer_part //= 0;
    $integer_part =~ s/^0+(?=[^0])//;
    if (length $integer_part > 3) {
        $integer_part = reverse $integer_part;
        $integer_part =~ s/(\d{3})(?!$)/$1$thousands/g;
        $integer_part = reverse $integer_part;
    }
    return $self->_sign_text() . $integer_part;
}

sub for_display {
    my ($self, %options) = @_;
    $self->formatter->rounding_increment($options{rounding_increment} // $self->rounding_increment);
    my $formatted = $self->formatter->format($self->for_computation());
    # Sometimes formatting goes a bit weird (3e,-07) so we need to get rid
    # of the group symbol if present.
    my $group = $self->format->_cldr_number->group_sign;
    # Turn XeY into equivalent version of X * 10 ^ Y
    if ($formatted =~ /^(?<mantissa>.+?)e$group?(?<exponent>.+?)$/) {
        return $self->formatter->format($+{mantissa}) .
                ' * ' . $self->formatter->format(10) . ' ^ ' .
                $self->formatter->format($+{exponent});
    }
    return $formatted;
}

sub for_html {
    my $self = shift;
    my $text = $self->for_display();
    my $ten = $self->formatter->format(10);
    $text =~ s/ \* $ten \^ (.+)/ * $ten<sup>$1<\/sup>/;
    return $text;
}

sub _has_decimal {
    my $self = shift;
    return 1 if $self->raw =~ quotemeta($self->format->_cldr_number->decimal_sign);
    return 0;
}

# Like 'for_display', but keep things like leading/trailing decimal marks
sub formatted_raw {
    my $self = shift;
    my $out = '';
    $out .= $self->_sign_text() .
        $self->formatter->format($self->integer_part)
        if $self->integer_part ne '';
    $out .= $self->format->_cldr_number->decimal_sign
        if $self->_has_decimal();
    $out .= ($self->fractional_part // '');
    my $ten = $self->formatter->format(10);
    if (defined $self->exponent) {
        my $exp = $self->exponent->for_display();
        $out .= " * $ten ^ " . $exp;
    }
    return $out;
}

1;

__END__

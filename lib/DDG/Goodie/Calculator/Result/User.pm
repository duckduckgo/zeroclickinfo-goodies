package DDG::Goodie::Calculator::Result::User;
# Generate formatted results for display.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
}

use strict;
use utf8;
use DDG::Goodie::Calculator::Parser;

use Moose;

has 'raw_query' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'style' => (
    is       => 'ro',
    isa      => 'DDG::GoodieRole::NumberStyle',
    required => 1,
);

has 'grammar' => (
    is       => 'ro',
    required => 1,
);

has 'currency' => (
    is  => 'ro',
    isa => 'Maybe[Str]',
);

has 'formatted_input' => (
    is  => 'ro',
    isa => 'Str',
);

has 'result' => (
    is  => 'ro',
    isa => 'DDG::Goodie::Calculator::Result',
);

has 'to_compute' => (
    is  => 'ro',
    isa => 'Str',
);

sub BUILD {
    my $self = shift;
    my $to_compute = $self->raw_query =~ s/((?:[,.\d][\d,. _]*[,.\d]?))/$self->style->for_computation($1)/ger;
    my ($generated_input, $val_result) = eval { get_parse_results $self->grammar, $to_compute } or return;
    $generated_input =~ s/(\d+(?:\.\d+)?)/$self->style->for_display($1)/ge;
    $self->{formatted_input} = $generated_input;
    $self->{result} = $val_result;
    $self->{to_compute} = $to_compute;
    return $self;
};

# For prefix currencies that round to 2 decimal places.
sub build_currency_result {
    my $self = shift;
    my $text = sprintf('%0.2f', $self->result->as_decimal());
    $text = $self->style->for_display($text);
    return {
        decimal  => $text,
        currency => $self->currency,
    };
}

sub should_display_decimal {
    my $self = shift;
    if ($self->result->is_fraction) {
        return 1 if not decimal_strings_equal($self->to_compute, $self->result->as_decimal());
    } else {
        return 1;
    }
    return 0;
}

sub can_display_fraction {
    my $self = shift;
    return $self->result->is_fraction() && not $self->result->tainted();
}

sub should_display_fraction {
    my $self = shift;
    if ($self->can_display_fraction) {
        my ($numerator, $denominator) = $self->result->value->parts;
        return 0 if (length $numerator > 3) || (length $denominator > 3);
        my $no_whitespace_input = $self->to_compute =~ s/\s*//gr;
        return $no_whitespace_input ne $self->result->as_fraction_string;
    }
    return 0;
}

# Check if two strings represent the same decimal number.
sub decimal_strings_equal {
    my ($first, $second) = @_;
    $first =~ s/^\./0\./;
    $second =~ s/^\./0\./;
    return $first eq $second;
}

sub got_rounded {
    my ($original, $to_test) = @_;
    return $original->value() != $to_test;
}

sub build_integer_result {
    my $self = shift;
    my $number = $self->result->value;
    my $is_exact = 1;
    if ($number->length() > 30) {
        $number = $number->as_int->bround(20)->bsstr();
        $is_exact = 0;
    };
    my $result = $self->style->for_display($number);
    $result =~ s/\*/×/;
    return {
        angle_type => $self->result->angle_type,
        decimal    => $result,
        is_exact   => $is_exact,
        is_integer => 1,
    };
}

sub format_as_decimal {
    my $self = shift;
    return $self->style->for_display($self->result->as_rounded_decimal);
}

sub format_as_fraction {
    my $self = shift;
    return $self->style->for_display($self->result->value);
}

# Result is just another format of the input
sub result_not_informative {
    my $self = shift;
    if ($self->to_compute =~ /^(\d++)(\.?(\d++))?(e[+-]?\d++)?$/) {
        return 1 if sprintf('%.e', $self->to_compute) eq sprintf('%.e', $self->result->value);
    };
    return 0;
}

sub build_result_format {
    my $self = shift;
    return if $self->is_bad_result;
    return if $self->result_not_informative;
    return $self->build_currency_result() if defined $self->currency;
    if ($self->result->is_integer) {
        return $self->build_integer_result();
    }
    my %result;
    my ($fraction, $decimal);
    if ($self->can_display_fraction) {
        $fraction = $self->format_as_fraction();
        $result{is_rational} = 1;
        $result{fraction} = $fraction;
        $result{should_display_fraction} = 1
            if $self->should_display_fraction;
    };
    if ($self->should_display_decimal) {
        my $rounded_decimal = $self->result->as_rounded_decimal();
        $result{is_exact_decimal} = not got_rounded($self->result, $rounded_decimal);
        $decimal = $self->format_as_decimal;
        $decimal =~ s/\*/×/;
        $result{decimal} = $decimal;
    };
    return \%result;
}

sub is_bad_result {
    my $self = shift;
    return 1 unless defined $self->result;
    return $self->result->contains_bad_result();
}

__PACKAGE__->meta->make_immutable;

1;

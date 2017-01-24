package DDG::Goodie::Calculator::Result::User;
# Generate formatted results for display.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
}

use strict;
use warnings;
use utf8;
use DDG::Goodie::Calculator::Parser;

use Moo;

has raw_query => (
    is       => 'ro',
    required => 1,
);

has style => (
    is       => 'ro',
    isa      => sub {
        die "Not a NumberStyle"
            unless ref $_[0] eq 'DDG::GoodieRole::NumberStyle';
    },
    required => 1,
);

has grammar => (
    is       => 'ro',
    required => 1,
);

has currency => (
    is  => 'ro',
);

has formatted_input => (
    is  => 'ro',
);

has result => (
    is  => 'ro',
    isa => sub {
        die "Not a Calculator::Result" unless
            ref $_[0] eq 'DDG::Goodie::Calculator::Result';
    },
);

has to_compute => (
    is  => 'ro',
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
sub format_as_currency {
    my $self = shift;
    my $result = sprintf('%0.2f', $self->result->as_decimal());
    return $self->style->for_display($self->currency . $result);
}

sub should_display_decimal {
    my ($self, $displayed_fraction) = @_;
    return 1 if !$displayed_fraction;
    if ($self->result->is_fraction) {
        return 1 if not decimal_strings_equal($self->to_compute, $self->result->as_decimal());
    } else {
        return 1;
    }
    return 0;
}

sub should_display_fraction {
    my $self = shift;
    if ($self->result->is_fraction) {
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

sub format_as_integer {
    my $self = shift;
    my $result = '';
    my $number = $self->result->value;
    return if $self->result_not_informative;
    if ($number->length() > 15) {
        $result .= '≈ ';
        $number = $number->as_int->bround(15)->bsstr();
    };
    $result .= $self->style->for_display($number) . $self->result->angle_symbol;
    $result =~ s/\*/×/;
    return $result;
}

sub format_as_decimal {
    my $self = shift;
    return $self->style->for_display($self->result->as_rounded_decimal) . $self->result->angle_symbol;
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

sub format_for_display {
    my $self = shift;
    return unless defined $self->result;
    $self->result->finalize;
    return if $self->result->contains_bad_result();
    return $self->format_as_currency if defined $self->currency;
    return $self->format_as_integer if $self->result->is_integer;
    my $result;
    my $displayed_fraction;
    if ($self->should_display_fraction) {
        $result .= $self->format_as_fraction . ' ';
        $displayed_fraction = 1;
    };
    if ($self->should_display_decimal($displayed_fraction)) {
        return if $self->result_not_informative;
        my $decimal = $self->result->as_rounded_decimal();
        if (got_rounded($self->result, $decimal)) {
            $result .= '≈ ';
        } else {
            $result .= '= ' if $displayed_fraction;
        }
        $result .= $self->format_as_decimal;
    };
    $result =~ s/\s+$//;
    $result =~ s/\*/×/;
    return $result;
}

1;

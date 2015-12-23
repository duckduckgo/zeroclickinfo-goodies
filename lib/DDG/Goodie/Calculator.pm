package DDG::Goodie::Calculator::Result;
# Defines the result form used by the Calculator Goodie to
# allow for more detailed and curated results.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(pure new_tainted
                     taint_result_when taint_result_unless
                     untaint_when);
}

use Moo;

# If an irrational (or ungodly) number was produced, so a fraction
# should not be displayed.
has 'tainted' => (
    is => 'ro',
    isa => sub { die unless $_[0] =~ /^[01]$/ },
    default => 0,
);

# The wrapped value.
has 'value' => (
    is => 'rw',
);

sub taint {
    my $self = shift;
    $self->{'tainted'} = 1;
}

sub untaint {
    my $self = shift;
    $self->{'tainted'} = 0;
}

# Creates a new, untainted result.
sub pure {
    my $value = shift;
    return DDG::Goodie::Calculator::Result->new({ value => $value });
}

# Creates a new tainted result.
sub new_tainted {
    my $value = shift;
    return DDG::Goodie::Calculator::Result->new({
            tainted => 1,
            value   => $value,
        });
}

sub wrap_result {
    my $result = shift;
    return $result if ref $result eq 'DDG::Goodie::Calculator::Result';
    return pure($result);
}

# preserve_taintf SUB, COND, FUNC
# Expects SUB to produce a result to be wrapped,
# COND to determine whether FUNC should be run
# when passed the result from SUB as well as its
# arguments, and FUNC to modify the final result.
sub preserve_taintf {
    my ($sub, $taintf_cond, $taintf) = @_;
    return sub {
        my $res = $sub->(@_);
        my $should_taintf = $taintf_cond->($res, @_);
        my $result = wrap_result($res);
        $taintf->($result) if $should_taintf;
        return $result;
    };
}

# Modify the taint of the result if the inner-result returns true
# for the given condition.
sub modify_taint_when {
    my ($taintf, $condition, $sub) = @_;
    preserve_taintf(
        $sub,
        sub { $condition->($_[0]) if defined $_[0] },
        sub { $taintf->($_[0]) });
}

sub taint_result_when { modify_taint_when(\&taint, @_) }

sub taint_result_unless {
    my ($condition, $sub) = @_;
    taint_result_when(sub { not $condition->(@_) }, $sub);
}

sub untaint_when { modify_taint_when(\&untaint, @_) }

sub to_string {
    my $self = shift;
    my $res = $self->value();
    return "$res" if defined $res;
}

sub preserving_taint {
    my $sub = shift;
    preserve_taintf($sub, sub { shift; $_[0]->tainted() }, \&taint);
}

sub upon_result {
    my $sub = shift;
    return preserving_taint sub {
        my $self = shift;
        my $value = $self->value();
        my $res = $sub->($value) if defined $value;
        return $res;
    }
}

sub on_result { upon_result($_[1])->($_[0]) };


package DDG::Goodie::Calculator;
# ABSTRACT: perform simple arithmetical calculations

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';
use utf8;

use Marpa::R2;
use Math::Cephes qw(:constants);
use Math::Cephes qw(:trigs);
use Math::Cephes qw(exp);
use Math::Cephes qw(fac);
use Math::Round;
use Number::Fraction;
use DDG::Goodie::Calculator::Result;

zci answer_type => "calculation";
zci is_cached   => 1;

primary_example_queries '1 + 7', '5 squared', '8 / 4';
secondary_example_queries
    '$2 + $7',
    '60 divided by 15',
    '1 + (3 / cos(pi))';
description 'Perform arithmetical calculations';
name 'Calculator';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Calculator.pm';
category 'calculations';
topics 'math';
attribution github  => ['https://github.com/GuiltyDolphin', 'Ben Moon'];

my $decimal = qr/(-?\d++[,.]?\d*+)|([,.]\d++)/;
# Check for binary operations
triggers query_nowhitespace => qr/($decimal|\w+)(\W+|x)($decimal|\w+)/;
# Factorial
triggers query_nowhitespace => qr/\d+[!]/;
# Check for functions
triggers query_nowhitespace => qr/\w+\(.*\)/;
# Check for constants and named operations
triggers query_nowhitespace => qr/$decimal\W*\w+/;
# They might want to find out what fraction a decimal represents
triggers query_nowhitespace => qr/[,.]\d+/;

my $grammar_text = scalar share('grammar.txt')->slurp();
my $grammar = Marpa::R2::Scanless::G->new(
    {   bless_package => 'Calculator',
        source        => \$grammar_text,
    }
);


sub get_parse {
  my ($recce, $input) = @_;
  eval { $recce->read(\$input) } or return undef;
  return $recce->value();
};

my %phone_number_regexes = (
    'US' => qr/[0-9]{3}(?: |\-)[0-9]{3}\-[0-9]{4}/,
    'UK' => qr/0[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}/,
    'UK2' => qr/0[0-9]{4}[ -][0-9]{3}[ -][0-9]{3}/,
);

my $number_re = number_style_regex();
# Each octet should look like a number between 0 and 255.
my $ip4_octet = qr/([01]?\d\d?|2[0-4]\d|25[0-5])/;
# There should be 4 of them separated by 3 dots.
my $ip4_regex = qr/(?:$ip4_octet\.){3}$ip4_octet/;
# 0-32
my $up_to_32  = qr/([1-2]?[0-9]{1}|3[1-2])/;
# Looks like network notation, either CIDR or subnet mask
my $network   = qr#^$ip4_regex\s*/\s*(?:$up_to_32|$ip4_regex)\s*$#;
sub should_not_trigger {
    my $query = shift;
    # Probably are searching for a phone number, not making a calculation
    for my $phone_regex (%phone_number_regexes) {
        return 1 if $query =~ $phone_regex;
    };
    # Probably attempt to express a hexadecimal number, query_nowhitespace makes this overreach a bit.
    return 1 if ($query =~ /\b0\s*x/);
    # Probably want to talk about addresses, not calculations.
    return 1 if ($query =~ $network);
    return 0;
}

sub get_style {
    my $text = shift;
    my @numbers = grep { $_ =~ /^$number_re$/ } (split /[^\d,.]+/, $text);
    return number_style_for(@numbers);
}

sub is_fraction { ref shift eq 'Number::Fraction' }

sub is_integer { shift !~ /(\.|e\+|\/)/ }

sub to_decimal { is_fraction($_[0]) ? $_[0]->to_num() : $_[0] }

sub new_fraction { Number::Fraction->new(@_) };

# Attempt to generate a fraction, but just return a real number if that
# fails.
sub to_fraction_or_real {
    my $to_convert = shift;
    $to_convert =~ /(?<intpart>-?\d*)\.(?<fracpart>\d*)/;
    my $mant = $+{'intpart'} .  $+{'fracpart'};
    my $required_shift = length $+{'fracpart'};
    my $fraction = eval { new_fraction($mant, 10 ** $required_shift) };
    return defined $fraction ? $fraction : $to_convert;
}

sub get_currency {
    my $text = shift;
    # Add new currency symbols here.
    $text =~ /(?<currency>[\$])$decimal/;
    return $+{'currency'};
}

# For prefix currencies that round to 2 decimal places.
sub format_for_currency {
    my ($text, $currency) = @_;
    return $text unless defined $currency;
    my $result = sprintf('%0.2f', to_decimal($text));
    return $currency . $result;
}

sub format_currency_for_display {
    my ($style, $text, $currency) = @_;
    return $style->for_display(format_for_currency($text, $currency));
}

sub standardize_operator_symbols {
    my $text = shift;
    # Only replace x's surrounded by non-alpha characters so it
    # can occur in function names.
    $text =~ s/(?<![[:alpha:]])x(?![[:alpha:]])/*/g;
    $text =~ s/[∙⋅×]/*/g;
    $text =~ s#[÷]#/#g;
    $text =~ s/\*{2}/^/g;
    return $text;
}

sub get_results {
    my $to_compute = shift;
    my $recce = Marpa::R2::Scanless::R->new(
        { grammar => $grammar,
        } );
    my $parsed = get_parse($recce, $to_compute) or return;
    my $generated_input = ${$parsed}->show();
    my $val_result = ${$parsed}->doit();
    return ($generated_input, $val_result);
}

sub should_display_decimal {
    my ($to_compute, $result) = @_;
    if (is_fraction $result) {
        return 1 if not decimal_strings_equal($to_compute, to_decimal($result));
    } else {
        return 1 if $to_compute ne $result;
    }
    return 0;
}
sub no_whitespace { $_[0] =~ s/\s*//gr };

sub should_display_fraction {
    my ($to_compute, $result) = @_;
    is_fraction $result and no_whitespace $to_compute ne $result
}

# Check if two strings represent the same decimal number.
sub decimal_strings_equal {
    my ($first, $second) = @_;
    $first =~ s/^\./0\./;
    $second =~ s/^\./0\./;
    return $first eq $second;
}

# Round a decimal number to the correct number of
# decimal places for display.
sub round_decimal {
    my $decimal = shift;
    my ($nom, $expt) = split 'e', $decimal;
    if (defined $expt) {
        my $num = nearest(1e-12, $nom);
        return $num . 'e' . $expt;
    };
    my ($s, $e) = split 'e', sprintf('%0.13e', $decimal);
    return nearest(1e-12, $s) * 10 ** $e;
}

sub got_rounded {
    my ($original, $to_test) = @_;
    return 0 if $original == $to_test;
    my $formatted = to_fraction_or_real $to_test;
    return $original != $formatted;
}

sub format_number_for_display {
    my ($style, $number) = @_;
    return $style->for_display($number);
}

sub is_bad_result {
    my $result = shift;
    return 1 unless defined $result;
    return 1 if is_fraction($result) and denominator($result) == 0;
}

sub format_for_display {
    my ($style, $to_compute, $value, $currency) = @_;
    return format_currency_for_display $style, $value, $currency if defined $currency;
    return format_number_for_display $style, $value if is_integer $value;
    my $result;
    my $displayed_fraction;
    if (should_display_fraction($to_compute, $value)) {
        $result .= format_number_for_display($style, $value) . ' ';
        $displayed_fraction = 1;
    };
    if (should_display_decimal($to_compute, $value)) {
        my $decimal = round_decimal $value;
        if (got_rounded($value, $decimal)) {
            $result .= '≈ ';
        } else {
            $result .= '= ' if $displayed_fraction;
        }
        $result .= format_number_for_display($style, $decimal);
    };
    $result =~ s/\s+$//;
    return $result;
}

sub to_display {
    my $query = shift;
    my $currency = get_currency $query;
    $query = standardize_operator_symbols $query;
    my $style = get_style $query or return;
    my $to_compute = $query =~ s/((?:[,.\d][\d,. _]*[,.\d]?))/$style->for_computation($1)/ger;
    my ($generated_input, $val_result) = eval { get_results $to_compute } or return;
    return if is_bad_result $val_result;
    my $result = format_for_display $style, $to_compute, $val_result, $currency;
    $generated_input =~ s/(\d+(?:\.\d+)?)/$style->for_display($1)/ge;
    # Didn't come up with anything the user didn't already know.
    return if ($generated_input eq $result);
    return ($generated_input, $result);
}

handle query => sub {
    my $query = $_;

    return if should_not_trigger $query;
    $query =~ s/^\s*(?:what\s*is|calculate|solve|math)\s*//;
    my ($generated_input, $result) = to_display $query or return;
    return unless defined $result && defined $generated_input;
    return $result,
        structured_answer => {
            id         => 'calculator',
            name       => 'Answer',
            data       => {
                title => "$result",
                subtitle => "Calculate: $generated_input",
            },
            templates => {
              group => 'text',
              moreAt => '0',
            },
        };
};


# Functionality


sub doit {
    my ($name, $sub) = @_;
    my $full_name = 'Calculator::' . $name . '::doit';
    no strict 'refs';
    *$full_name = *{uc $full_name} = $sub;
}
sub show {
    my ($name, $sub) = @_;
    my $full_name = 'Calculator::' . $name . '::show';
    no strict 'refs';
    *$full_name = *{uc $full_name} = $sub;
}

# Usage: binary_doit NAME, SUB
# SUB should take 2 arguments and return the result of the doit
# action.
#
# A subroutine of the form Calculator::NAME::doit will be created
# in the global namespace.
sub binary_doit {
    my ($name, $sub) = @_;
    doit $name, sub {
        my $self = shift;
        return $sub->($self->[0]->doit(),
                      $self->[1]->doit());
    };
}
sub binary_show {
    my ($name, $sub) = @_;
    show $name, sub {
        my $self = shift;
        return $sub->($self->[0]->show(), $self->[1]->show());
    };
}
sub unary_doit {
    my ($name, $sub) = @_;
    no strict 'refs';
    doit $name, sub {
        my $self = shift;
        return $sub->($self->[0]->doit());
    };
}
sub unary_show {
    my ($name, $sub) = @_;
    show $name, sub {
        my $self = shift;
        return $sub->($self->[0]->show());
    };
}
unary_doit 'paren', sub { $_[0] };
unary_show 'paren', sub { '(' . $_[0] . ')' };
unary_doit 'primary', sub { $_[0] };
unary_show 'primary', sub { $_[0] };
sub unary_fun_show {
    my ($name, $fun_name) = @_;
    unary_show $name, sub { "$fun_name($_[0])" };
}
doit 'integer', sub {
    my $self = shift;
    return new_fraction($self->[0]->[2]);
};
show 'integer', sub { "$_[0]->[0]->[2]" };


doit 'decimal', sub {
    my $self = shift;
    return to_fraction_or_real($self->[0]->[2]);
};
show 'decimal', sub { "$_[0]->[0]->[2]" };

doit 'prefix_currency', sub { $_[0]->[1]->doit() };
show 'prefix_currency', sub {
    my $self = shift;
    # Things like $5.00, &pound.75
    return $self->[0] . sprintf('%0.2f', $self->[1]->show());
};

unary_doit 'square', sub { $_[0] * $_[0] };
unary_show 'square', sub { "$_[0] squared" };
binary_show 'exp', sub { "$_[0]e$_[1]" };


sub is_exact {
    my $to_check = shift;
    return (ref $to_check eq 'Number::Fraction');
}

sub Calculator::Calculator::doit {
    my $self = shift;
    my $result = $self->[0]->doit();
    return $result;
}

unary_show 'Calculator', sub { $_[0] };

binary_doit 'constant_coefficient', sub { $_[0] * $_[1] };
show 'constant_coefficient', sub {
    my $self = shift;
    return $self->[0]->show() . ' ' . $self->[1]->show();
};

# Usage: new_unary_function NAME, REP, SUB
# A subroutine of the form Calculator::NAME::doit and
# Calculator::NAME::show will be created in the global namespace.
#
# REP is the string that will be displayed as the function name
# in the formatted input (e.g, using 'sin' for the sine function,
# would display as 'sin(ARG)').
# SUB can either be a string or a routine.
# If SUB is a string, then it should represent a method of the
# Math::BigFloat package.
# If SUB is a routine, then it should take a single argument
# and return the result of applying the function.
sub new_unary_function {
    my ($name, $rep, $sub) = @_;
    if (ref $sub ne 'CODE') {
        unary_doit $name, sub { $_[0]->$sub() };
    } else {
        unary_doit $name, $sub;
    };
    unary_show $name, sub { "$rep($_[0])" };
}

# Trigonometric unary functions
                                        # sine seems to round weirdly
new_unary_function 'sine',   'sin', sub { "@{[nearest(1e-15, sin $_[0])]}" };
new_unary_function 'cosine', 'cos', sub { cos $_[0] };

new_unary_function 'secant', 'sec', sub { 1 / (cos $_[0]) };
new_unary_function 'cosec',  'csc', sub { 1 / (sin $_[0]) };
new_unary_function 'cotangent', 'cotan', sub { cot $_[0] };
new_unary_function 'tangent', 'tan', sub { tan $_[0] };

# Log functions
new_unary_function 'natural_logarithm', 'ln', sub { log $_[0] };
binary_doit 'logarithm', sub { (log $_[1]) / (log $_[0]) };
binary_show 'logarithm', sub { "log$_[0]($_[1])" };

# Misc functions
new_unary_function 'square_root', 'sqrt', sub { sqrt $_[0] };
new_unary_function 'factorial',   'factorial', sub { return fac($_[0]) };
new_unary_function 'exponential', 'exp', sub { exp($_[0]) };


# OPERATORS

# new_binary_operator NAME, SYMBOL, ROUTINE
# or
# new_binary_operator NAME, SYMBOL, METHOD
sub new_binary_operator {
    my ($name, $operator, $sub) = @_;
    if (ref $sub ne 'CODE') {
        binary_doit $name, sub { $_[0]->$sub($_[1]) };
    } else {
        binary_doit $name, $sub;
    };
    binary_show $name, sub { "$_[0] $operator $_[1]" };
}

sub fraction_parts {
    my $num = shift;
    my ($numerator, $denominator) = split '/', $num;
    return ($numerator, $denominator) if defined $numerator and defined $denominator;
    return ($num, 1);
}
sub denominator {
    my (undef, $denominator) = fraction_parts shift;
    return $denominator;
}
new_binary_operator 'subtract',     '-', sub { $_[0] - $_[1] };
new_binary_operator 'add',          '+', sub { $_[0] + $_[1] };
new_binary_operator 'multiply',     '*', sub { $_[0] * $_[1] };
new_binary_operator 'divide',       '/', sub { $_[0] / $_[1] };

# Little bit hacky for exponents because of the way Number::Fraction
# handles them. Basically have to deal with the case when the base and
# exponent are valid fractions, and the exponent is negative - other cases
# are handled fine by Number::Fraction.
sub exponentiate_fraction {
    if (is_fraction $_[0] and $_[1] < 0) {
        my ($numerator, $denominator) = fraction_parts $_[0];
        my (undef, $pow_denom)        = fraction_parts $_[1];
        my ($new_numerator, $new_denominator) = ($denominator ** abs($_[1]),
                                                 $numerator   ** abs($_[1]));
        return ($pow_denom != 1)
            ? new_fraction($new_numerator, $new_denominator)
            : $new_numerator / $new_denominator;
    };
    return $_[0] ** $_[1];
}

new_binary_operator 'exponentiate', '^', sub {
    return exponentiate_fraction($_[0], $_[1]);
};

binary_doit 'exp', sub {
    $_[0] * exponentiate_fraction(new_fraction(10), $_[1])
};

unary_doit 'factorial_operator', sub {
    return if $_[0] < 0 or $_[0] > 33;
    fac($_[0]);
};
unary_show 'factorial_operator', sub { $_[0] . '!' };

# new_constant NAME, VALUE
# will create a new constant that can be referred to through
# 'Calculator::const_NAME', will have the value VALUE and be
# represented in output by NAME.
#
# new_constant NAME, VALUE, REP
# will do the same as the previous form, but use REP to represent
# the constant in output.
sub new_constant {
    my ($name, $val, $print_name) = @_;
    $print_name = $name unless defined $print_name;
    my $const_name = "const_$name";
    doit $const_name, sub { $val };
    show $const_name, sub { $print_name };
}

my $big_pi = $PI;
my $big_e = exp(1);

# Constants go here.
new_constant 'pi',    $big_pi, 'pi';
new_constant 'dozen', 12;
new_constant 'euler', $big_e,  'e';
new_constant 'score', 20;

1;

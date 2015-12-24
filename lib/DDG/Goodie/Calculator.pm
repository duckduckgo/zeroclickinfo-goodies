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

use Math::BigRat try => 'GMP';
use Math::Cephes qw(:explog);
use Math::Cephes qw(:trigs);
use Math::Round;
use Moo;

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
    'cos'   => 'cos_result',
    'sin'   => 'sin_result',
    # Misc functions
    'exp'   => 'exp_result',
    'log'   => 'log_result',
    'sqrt'  => 'sqrt_result',
    'int'   => 'int_result';

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

# Combine two Results using the given operation. Preserves appropriate
# attributes.
sub combine_results {
    my ($sub, $swapsub) = @_;
    my $resf = sub {
        my ($self, $other, $swap) = @_;
        my $first_val = $self->value();
        my $second_val = $other->value();
        my $res = $sub->($first_val, $second_val)
            if (defined $first_val && defined $second_val);
        $res = $swapsub->($res)
            if (defined $swapsub && defined $res && $swap);
        return $res;
    };
    my $cond = sub { shift; $_[0]->tainted() || $_[1]->tainted() };
    return preserve_taintf($resf, $cond, \&taint);
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

*add_results = combine_results(sub { $_[0] + $_[1] });
*subtract_results = combine_results(sub { $_[0] - $_[1] });
*multiply_results = combine_results(sub { $_[0] * $_[1] });
*divide_results = combine_results(sub { $_[0] / $_[1] });
*modulo_results = combine_results(sub { $_[0] % $_[1] });

sub num_compare_results {
    my ($self, $other, $swap) = @_;
    return $other->value() <=> $self->value() if $swap;
    return $self->value()  <=> $other->value();
}

sub from_big {
    my $to_convert = shift;
    return $to_convert->numify() if ref $to_convert eq 'Math::BigRat';
    return $to_convert->bstr() if ref $to_convert eq 'Math::BigFloat';
    return $to_convert->bstr() if ref $to_convert eq 'Math::BigInt';
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

# Little bit hacky for exponents because of the way Number::Fraction
# handles them. Basically have to deal with the case when the base and
# exponent are valid fractions, and the exponent is negative - other cases
# are handled fine by Number::Fraction.
sub exponentiate_fraction {
    if ($_[1] < 0) {
        my $res = 1 / $_[0] ** abs($_[1]);
        return $res;
    };
    my $res = wrap_unwrap(sub { $_[0] ** $_[1] })->(@_);
    return $res;
}

*exponent_results = combine_results \&exponentiate_fraction;
*atan2_results = combine_results \&atan2;
*cos_result = upon_result sub { "@{[nearest(1e-15, cos $_[0])]}" };
*sin_result = upon_result sub { "@{[nearest(1e-15, sin $_[0])]}" };
*exp_result = upon_result sub { exp $_[0] };
*log_result = upon_result sub { "@{[nearest(1e-15, log $_[0])]}" };
*sqrt_result = upon_result sub { sqrt $_[0] };
*int_result = upon_result sub { int $_[0] };

sub as_fraction_string {
    my $self = shift;
    my $show = "$self";
    my $value = $self->value();
    if ($self->is_fraction()) {
        return "$value";
    }
}

sub is_integer {
    my $self = shift;
    my $tolerance = shift;
    my $value = $self->value();
    return pure($self->rounded($tolerance))->is_integer() if defined $tolerance;
    return $value->is_int() if ref $value eq 'Math::BigRat';
    return $value =~ /^\d+$/;
}

sub is_fraction {
    my $self = shift;
    my $value = $self->value();
    ref $value eq 'Math::BigRat' ? 1 : 0;
}

sub as_rounded_decimal {
    my $self = shift;
    my $decimal = $self->value();
    my ($nom, $expt) = split 'e', $decimal;
    if (defined $expt) {
        my $num = nearest(1e-12, $nom);
        return $num . 'e' . $expt;
    };
    my ($s, $e) = split 'e', sprintf('%0.13e', $decimal);
    return nearest(1e-12, $s) * 10 ** $e;
}

sub as_decimal {
    my $self = shift;
    my $value = $self->value();
    return $value->as_float->bstr() if ref $value eq 'Math::BigRat';
    return $value->bstr() if ref $value eq 'Math::BigFloat';
    return $value;
}

*rounded = preserving_taint sub {
    my ($self, $round_to) = @_;
    return to_rat("@{[nearest($round_to, $self->as_decimal())]}");
};

sub contains_bad_result {
    my $self = shift;
    return 1 unless defined $self->value();
    return 1 if $self->is_fraction() && $self->value->denominator() == 0;
    return $self->value() =~ /(inf|nan)/i;
}


package DDG::Goodie::Calculator::Parser;
# Contains the grammar and parsing actions used by the Calculator Goodie.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(get_parse_results
                     generate_grammar);
}

use strict;
use utf8;

use Marpa::R2;
use Math::Cephes qw(exp);
use DDG::Goodie::Calculator::Result;
use Moo;

# Generate a pretty grammar!
sub generate_sub_grammar {
    my ($grammar_name, $definitions) = @_;
    my $str_grammar = "$grammar_name ::= \n";
    my ($first_term, @terms) = keys $definitions;
    my ($first_refer, $first_refer_def) = generate_alternate_forms($first_term, $definitions->{$first_term});
    my @alternate_forms = ($first_refer_def) if defined $first_refer_def;
    $str_grammar .= generate_grammar_line(["($first_refer)", 'Argument'], $first_term, 1);
    foreach my $function_name (@terms) {
        my ($refer, $refer_def) = generate_alternate_forms($function_name, $definitions->{$function_name});
        push @alternate_forms, $refer_def if defined $refer_def;
        $str_grammar .= generate_grammar_line(["($refer)", 'Argument'], $function_name, 0);
    };
    foreach my $alternate_form (@alternate_forms) {
        $str_grammar .= "\n$alternate_form\n";
    };
    return $str_grammar;
}
sub generate_sub_grammar_gen {
    my ($grammar_name, $grammar_specf) = @_;
    return sub {
        my $definitions = shift;
        my $str_grammar = "$grammar_name ::= \n";
        my ($first_term, @terms) = keys $definitions;
        my ($first_refer, $first_refer_def) = generate_alternate_forms($first_term, $definitions->{$first_term});
        my @alternate_forms = ($first_refer_def) if defined $first_refer_def;
        $str_grammar .= generate_grammar_line($grammar_specf->($first_refer), $first_term, 1);
        foreach my $function_name (@terms) {
            my ($refer, $refer_def) = generate_alternate_forms($function_name, $definitions->{$function_name});
            push @alternate_forms, $refer_def if defined $refer_def;
            $str_grammar .= generate_grammar_line($grammar_specf->($refer), $function_name, 0);
        };
        foreach my $alternate_form (@alternate_forms) {
            $str_grammar .= "\n$alternate_form\n";
        };
        return $str_grammar;
    };
}

sub generate_grammar_line {
    my ($rhs, $blessf, $is_first) = @_;
    my $start = '    ' . ($is_first ? '  ' : '| ');
    my $components = join ' ', @$rhs;
    my $bless = " bless => $blessf";
    return $start . $components . $bless . "\n";
}

sub generate_alternate_forms {
    my $name = shift;
    my $forms = shift;
    my ($refer_to, $refer_definition);
    if (ref $forms eq 'ARRAY') {
        $refer_to = "<gen @{[$name =~ s/[^[:alnum:]]/ /gr]} forms>";
        $refer_definition = $refer_to . ' ~ ' . join(' | ', map { "'$_'" } @$forms);
    } else {
        $refer_to = "'$forms'";
    };
    return ($refer_to, $refer_definition);
}

my %unary_function_grammar;
my %word_constant_grammar;
my %symbol_constant_grammar;

*generate_unary_function_grammar = generate_sub_grammar_gen(
    "GenUnaryFunction", sub { ["($_[0])", 'Argument'] });

*generate_word_constant_grammar = generate_sub_grammar_gen(
    "WordConstant", sub { ["($_[0]:i)"] });

*generate_symbol_constant_grammar = generate_sub_grammar_gen(
    "SymbolConstant", sub { ["($_[0]:i)"] });

sub new_fraction { Math::BigRat->new(@_) };


sub doit {
    my ($name, $sub) = @_;
    my $full_name = 'DDG::Goodie::Calculator::Parser::' . $name . '::doit';
    no strict 'refs';
    *$full_name = *{uc $full_name} = $sub;
}

sub show {
    my ($name, $sub) = @_;
    my $full_name = 'DDG::Goodie::Calculator::Parser::' . $name . '::show';
    no strict 'refs';
    *$full_name = *{uc $full_name} = $sub;
}

# Usage: binary_doit NAME, SUB
# SUB should take 2 arguments and return the result of the action.
sub binary_doit {
    my ($name, $sub) = @_;
    doit $name, sub {
        my $self = shift;
        my $new_sub = untaint_when(sub { length $_[0]->rounded(1e-15) < 10 }, $sub);
        return $new_sub->($self->[0]->doit(), $self->[1]->doit());
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
        my $new_sub = untaint_when sub { $_[0] =~ /^\d+$/ }, $sub;
        return $new_sub->($self->[0]->doit());
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

# Integers, decimals etc...
sub new_base_value {
    my ($name, $val_sub, $show) = @_;
    doit $name, sub { $val_sub->($_[0]->[0]->[2]) };
    my $showf = defined $show
        ? sub { $show->($_[0]->[0]->[2]) }
        : sub {        "$_[0]->[0]->[2]" };
    show $name, $showf;
}

new_base_value 'integer', sub { pure(new_fraction($_[0])) };
new_base_value 'decimal', sub { pure(new_fraction($_[0])) };

doit 'prefix_currency', sub { $_[0]->[1]->doit() };
show 'prefix_currency', sub {
    my $self = shift;
    # Things like $5.00, &pound.75
    return $self->[0] . sprintf('%0.2f', $self->[1]->show());
};

unary_doit 'square', taint_when_longer_than(10, sub { $_[0] * $_[0] });
unary_show 'square', sub { "$_[0] squared" };
binary_show 'exp', sub { "$_[0]e$_[1]" };


unary_doit 'Calculator', sub { $_[0] };
unary_show 'Calculator', sub { $_[0] };

binary_doit 'factored_word_constant', sub { $_[0] * $_[1] };
binary_show 'factored_word_constant', sub { "$_[0] $_[1]" };
binary_doit 'factored_symbol_constant', sub { $_[0] * $_[1] };
binary_show 'factored_symbol_constant', sub { "$_[0]$_[1]" };

# Usage: new_unary_function NAME, REP, SUB
#
# REP is the string that will be displayed as the function name
# in the formatted input (e.g, using 'sin' for the sine function,
# would display as 'sin(ARG)').
# If REP is an ARRAY reference, then the first element will be used
# for generating the formatted input, but all of the forms will be
# allowed in the grammar.
# SUB should take a single argument and return the result of applying the
# function.
sub new_unary_function {
    my ($name, $reps, $sub) = @_;
    unary_doit $name, $sub;
    my $rep;
    if (ref $reps eq 'ARRAY') {
        $rep = $reps->[0];
    } else {
        $rep = $reps;
    };
    unary_show $name, sub { "$rep($_[0])" };
    $unary_function_grammar{$name} = $reps;
}

# Result should not be displayed as a fraction if result a long decimal.
sub new_unary_bounded {
    my ($name, $rep, $sub) = @_;
    new_unary_function $name, $rep, untaint_when(
        sub { length $_[0]->rounded(1e-15) < 15 },
        taint_when_longer_than(10, $sub));
}

new_unary_bounded 'sine', 'sin',        sub { sin $_[0] };
new_unary_bounded 'cosine', 'cos',      sub { cos $_[0] };
new_unary_bounded 'secant', 'sec',      sub { pure(1) / (cos $_[0]) };
new_unary_bounded 'cosec', 'csc',       sub { pure(1) / (sin $_[0]) };
new_unary_bounded 'cotangent', 'cotan', sub { (cos $_[0]) / (sin $_[0]) };
new_unary_bounded 'tangent', 'tan',     sub { (sin $_[0]) / (cos $_[0]) };

# Log functions
new_unary_function 'natural_logarithm', ['ln', 'log'],
    taint_when_longer_than(10, sub { log $_[0] });
binary_doit 'logarithm', taint_when_longer_than(10,
    sub { (log $_[1]) / (log $_[0]) });
binary_show 'logarithm', sub { "log$_[0]($_[1])" };

# Misc functions
new_unary_bounded 'square_root', 'sqrt', sub { sqrt $_[0] };

sub calculate_factorial {
    return if $_[0] > pure(1000); # Much larger than this and I start
                                  # to notice a delay.
    return $_[0]->on_result(sub { $_[0]->bfac() });
}

new_unary_function 'factorial', ['factorial', 'fact'], \&calculate_factorial;
new_unary_function 'exponential', 'exp', taint_result_unless(
    sub { $_[0] =~ /^\d+$/ }, \&exp );


# OPERATORS

# new_binary_operator NAME, SYMBOL, ROUTINE
sub new_binary_operator {
    my ($name, $operator, $sub) = @_;
    binary_doit $name, $sub;
    binary_show $name, sub { "$_[0] $operator $_[1]" };
}

new_binary_operator 'subtract',     '-', sub { $_[0] - $_[1] };
new_binary_operator 'add',          '+', sub { $_[0] + $_[1] };
new_binary_operator 'multiply',     '*', sub { $_[0] * $_[1] };
new_binary_operator 'divide',       '/', sub { $_[0] / $_[1] };

sub taint_when_longer_than {
    my ($amount, $sub) = @_;
    return taint_result_when sub { length $_[0] > $amount }, $sub;
}

new_binary_operator 'exponentiate', '^', taint_when_longer_than(10,
    sub { $_[0] ** $_[1] });

binary_doit 'exp', sub { $_[0] * pure(10) ** $_[1] };

unary_doit 'factorial_operator', \&calculate_factorial;
unary_show 'factorial_operator', sub { $_[0] . '!' };

# new_constant NAME, VALUE
# will create a new constant that has the value `VALUE`
# and will be displayed as `NAME`.
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

sub new_symbol_constant {
    my ($name, $val, $rep, $show) = @_;
    new_constant $name, $val, ($show or $rep);
    $symbol_constant_grammar{"const_$name"} = $rep;
}
sub new_word_constant {
    my ($name, $val) = @_;
    new_constant $name, $val, $name;
    $word_constant_grammar{"const_$name"} = $name;
}

my $big_pi = Math::BigRat->new(Math::BigFloat->bpi());
my $big_e =  Math::BigRat->new(1)->bexp();

# If any constants cannot be displayed as a fraction, wrap them with this
sub irrational { new_tainted(@_) };

# Constants go here.
new_symbol_constant 'pi',    irrational($big_pi), 'pi', 'π';
new_word_constant 'dozen', pure(12);
new_symbol_constant 'euler', irrational($big_e),  'e';
new_word_constant 'score', pure(20);

sub generate_grammar {
    my $initial_grammar_text = shift;
    my $generated_unary_function_grammar =
        generate_unary_function_grammar(\%unary_function_grammar);
    my $generated_word_constant_grammar =
        generate_word_constant_grammar(\%word_constant_grammar);
    my $generated_symbol_constant_grammar =
        generate_symbol_constant_grammar(\%symbol_constant_grammar);
    my $grammar_text = join "\n",
        ($initial_grammar_text,
         $generated_unary_function_grammar,
         $generated_word_constant_grammar,
         $generated_symbol_constant_grammar);
    my $grammar = Marpa::R2::Scanless::G->new(
        {   bless_package => 'DDG::Goodie::Calculator::Parser',
            source        => \$grammar_text,
        }
    );
}

sub get_parse {
  my ($recce, $input) = @_;
  eval { $recce->read(\$input) } or return undef;
  return $recce->value();
}


sub get_parse_results {
    my ($grammar, $to_compute) = @_;
    my $recce = Marpa::R2::Scanless::R->new(
        { grammar => $grammar,
        } );
    my $parsed = get_parse($recce, $to_compute) or return;
    my $generated_input = ${$parsed}->show();
    my $val_result = ${$parsed}->doit();
    return unless defined $val_result->value();
    return ($generated_input, $val_result);
}



package DDG::Goodie::Calculator;
# ABSTRACT: perform simple arithmetical calculations

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';
use utf8;

use DDG::Goodie::Calculator::Parser;

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
    my $result = sprintf('%0.2f', $text->as_decimal());
    return $currency . $result;
}

sub format_currency_for_display {
    my ($style, $text, $currency) = @_;
    return $style->for_display(format_for_currency($text, $currency));
}

sub standardize_symbols {
    my $text = shift;
    # Only replace x's surrounded by non-alpha characters so it
    # can occur in function names.
    $text =~ s/(?<![[:alpha:]])x(?![[:alpha:]])/*/g;
    $text =~ s/[∙⋅×]/*/g;
    $text =~ s#[÷]#/#g;
    $text =~ s/\*{2}/^/g;
    $text =~ s/π/pi/g;
    return $text;
}

sub should_display_decimal {
    my ($to_compute, $result) = @_;
    if ($result->is_fraction()) {
        return 1 if not decimal_strings_equal($to_compute, $result->as_decimal());
    } else {
        return 1 if $to_compute ne $result->value();
    }
    return 0;
}

sub should_display_fraction {
    my ($to_compute, $result) = @_;
    if ($result->is_fraction()) {
        my $tainted = $result->tainted();
        return 0 if $result->tainted();
        my $no_whitespace_input = $to_compute =~ s/\s*//gr;
        return $no_whitespace_input ne $result->as_fraction_string;
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

sub format_number_for_display {
    my ($style, $number) = @_;
    return $style->for_display($number);
}

sub format_for_display {
    my ($style, $to_compute, $value, $currency) = @_;
    return format_currency_for_display $style, $value, $currency if defined $currency;
    return format_number_for_display $style, $value if $value->is_integer();
    my $result;
    my $displayed_fraction;
    if (should_display_fraction($to_compute, $value)) {
        $result .= format_number_for_display($style, $value) . ' ';
        $displayed_fraction = 1;
    };
    if (should_display_decimal($to_compute, $value)) {
        my $decimal = $value->as_rounded_decimal();
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

sub is_bad_result {
    my $result = shift;
    return 1 unless defined $result;
    return $result->contains_bad_result();
}

my $grammar_text = scalar share('grammar.txt')->slurp();
my $grammar = generate_grammar($grammar_text);
sub to_display {
    my $query = shift;
    my $currency = get_currency $query;
    $query = standardize_symbols $query;
    my $style = get_style $query or return;
    my $to_compute = $query =~ s/((?:[,.\d][\d,. _]*[,.\d]?))/$style->for_computation($1)/ger;
    my ($generated_input, $val_result) = eval { get_parse_results $grammar, $to_compute } or return;
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

1;

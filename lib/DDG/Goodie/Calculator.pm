package DDG::Goodie::Calculator;
# ABSTRACT: do simple arthimetical calculations

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use Marpa::R2;
use List::Util qw( max );
use Math::Trig;
use Math::BigInt;
use Math::BigFloat;
use utf8;

zci answer_type => "calc";
zci is_cached   => 1;

primary_example_queries '$3.43+$34.45';
secondary_example_queries '64*343';
description 'Basic calculations';
name 'Calculator';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Calculator.pm';
category 'calculations';
topics 'math';
attribution github  => ['https://github.com/GuiltyDolphin', 'Ben Moon'],
            github  => ['https://github.com/duckduckgo', 'duckduckgo'],
            github  => ['https://github.com/phylum', 'Daniel Smith'];

triggers query_nowhitespace => qr<
        ^
       ( what is | calculate | solve | math )?

        [\( \) x X × ∙ ⋅ * % + ÷ / \^ \$ -]*

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c | squared | score |)
        [\( \) x X × ∙ ⋅ * % + ÷ / \^ 0-9 \. , _ \$ -]*

        (?(1) (?: -? [0-9 \. , _ ]+ |) |)
        (?: [\( \) x X × ∙ ⋅ * % + ÷ / \^ \$ -] | times | divided by | plus | minus | fact | factorial | cos | sin | tan | cotan | log | ln | log[_]?\d{1,3} | exp | tanh | sec | csc | squared | sqrt | pi | e )+

        (?: [0-9 \. ,]* )
        (?: gross | dozen | pi | e | c | squared | score |)

        [\( \) x X × ∙ ⋅ * % + ÷ / \^ 0-9 \. , _ \$ -]* =?

        $
        >xi;

my $grammar = Marpa::R2::Scanless::G->new(
    {   bless_package => 'Calculator',
        source        => \(<<'END_OF_SOURCE'),
:default ::= action => [value] bless => ::lhs
lexeme default = action => [ start, length, value ]
    bless => ::name latm => 1

:start ::= Calculator

Calculator ::= Expression

Expression ::=
     Term                        bless => primary
    || ExprOp                     bless => primary

Factor ::=
    NumTerm bless => primary
    || NumTerm ('e':i) NumTerm bless => exp

Term ::=
    Function bless => primary
    | ('(') Expression (')') bless => paren assoc => group
    | Factor bless => primary
    || TermOp bless => primary

TermOp ::=
    Expression ('^') Expression bless => exponentiate assoc => right
    || Factor ('squared') bless => square
    || Expression ('*') Expression bless => multiply
    | Expression ('/') Expression bless => divide
    | Term ('divided') ('by') Factor bless => divide

ExprOp ::=
    Expression ('+') Term bless => add
    | Expression ('-') Term bless => subtract

NumTerm ::=
       Number Constant bless => constant_coefficient
    || Constant        bless => primary
    |  Number          bless => primary

Constant ::=
      pi    bless => const_pi
    | euler bless => const_euler
    | dozen bless => const_dozen
    | score bless => const_score

Function ::=
      ('sqrt' ) Argument bless => square_root
    | ('sin'  ) Argument bless => sine
    | ('cos'  ) Argument bless => cosine
    | ('tan'  ) Argument bless => tangent
    | ('csc'  ) Argument bless => cosec
    | ('sec'  ) Argument bless => secant
    | ('cotan') Argument bless => cotangent
    | ('log_' ) NumTerm Argument bless => logarithm
    | ('log'  ) NumTerm Argument bless => logarithm
    | ('ln'   ) Argument bless => natural_logarithm
    | ('log'  ) Argument bless => natural_logarithm
    | ('fact' ) Argument bless => factorial
    | ('factorial') Argument bless => factorial

# Argument for a unary function.
Argument ::= ('(') Expression (')') bless => primary

pi ~ 'pi':i
euler ~ 'e':i
dozen ~ 'dozen':i
score ~ 'score':i

Number ::=
    [$] BaseNumber bless => prefix_currency
    | BaseNumber bless => primary

BaseNumber ::=
    Integer   bless => integer
    | Decimal bless => decimal

Integer ~ '-' digits | digits
Decimal ~ '-' digits '.' digits | digits '.' digits
           | '.' digits | digits '.'
digits ~ [\d]+
:discard ~ whitespace
whitespace ~ [\s]+
END_OF_SOURCE
    }
);


my $number_re = number_style_regex();

my $ip4_octet = qr/([01]?\d\d?|2[0-4]\d|25[0-5])/;                          # Each octet should look like a number between 0 and 255.
my $ip4_regex = qr/(?:$ip4_octet\.){3}$ip4_octet/;                          # There should be 4 of them separated by 3 dots.
my $up_to_32  = qr/([1-2]?[0-9]{1}|3[1-2])/;                                # 0-32
my $network   = qr#^$ip4_regex\s*/\s*(?:$up_to_32|$ip4_regex)\s*$#;         # Looks like network notation, either CIDR or subnet mask


sub get_parse {
  my ($recce, $input) = @_;
  eval { $recce->read(\$input) } or return undef;
  my $value_ref = $recce->value();
  return $value_ref;
};

Math::BigFloat->round_mode('+inf');

my %phone_number_regexes = (
    'US' => qr/[0-9]{3}(?: |\-)[0-9]{3}\-[0-9]{4}/,
    'UK' => qr/0[0-9]{3}[ -][0-9]{3}[ -][0-9]{4}/,
    'UK2' => qr/0[0-9]{4}[ -][0-9]{3}[ -][0-9]{3}/,
);
sub should_not_trigger {
    my $query = $_;
    return 1 if $query =~ /^\$\d+(?:\.\d+)?$/;
    # Probably are searching for a phone number, not making a calculation
    for my $phone_regex (%phone_number_regexes) {
        return 1 if $query =~ $phone_regex;
    };
    return 1 if $query =~ /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/;
    # Probably attempt to express a hexadecimal number, query_nowhitespace makes this overreach a bit.
    return 1 if ($query =~ /\b0x/);
    # Probably want to talk about addresses, not calculations.
    return 1 if ($query =~ $network);
    return 0;
}

sub get_style {
    my $text = $_;
    my @numbers = grep { $_ =~ /^$number_re$/ } (split /[^\d,.]+/, $text);
    return number_style_for(@numbers);
}
handle query_nowhitespace => sub {
    my $query = $_;

    return if should_not_trigger $query;
    my $has_dollars = $query =~ /\$/;
    $query =~ s/^(?:whatis|calculate|solve|math)//;
    # FIXME: Currently just replacing 'x', might occur in functions!
    $query =~ s/[∙⋅×x]/*/g;
    $query =~ s#[÷]#/#g;
    my $style = get_style $query or return;
    my $recce = Marpa::R2::Scanless::R->new(
        { grammar => $grammar,
            # trace_terminals => 1,
        } );
    my $to_compute = $style->for_computation($query);
    my $parsed = get_parse($recce, $to_compute) or return;
    my $generated_input = ${$parsed}->show();
    my $val_result = ${$parsed}->doit();
    return if ($val_result eq 'inf');
    $val_result =~ s/^\((.*)\)$/$1/;
    $val_result = sprintf('%0.2f', $val_result) if $has_dollars;
    my $result = $style->for_display($val_result);
    $result = '$' . $result if $has_dollars;
    $generated_input =~ s/(\d+(?:\.\d+)?)/$style->for_display($1)/ge;
    return if ($generated_input eq $result);
    return $result,
        structured_answer => {
            id         => 'calculator',
            name       => 'Answer',
            data       => {
                title => "$result",
                subtitle => $generated_input . ' = ' . $result,
            },
            templates => {
              group => "text",
              moreAt => 0,
            },
        };
};

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
sub binary_doit {
    my ($name, $sub) = @_;
    doit $name, sub {
        my $self = shift;
        return $sub->($self->[0]->doit->copy(), $self->[1]->doit->copy());
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
        return $sub->($self->[0]->doit->copy());
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
doit 'integer', sub { Math::BigFloat->new($_[0]->[0]->[2]) };
show 'integer', sub { "$_[0]->[0]->[2]" };
doit 'decimal', sub { Math::BigFloat->new($_[0]->[0]->[2]) };
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


sub Calculator::Calculator::doit {
    my $self = shift;
    my $result = $self->[0]->doit();
    $result = Math::BigFloat->new($result)->bround(15);
    my $to_report = sprintf('%0.30f', $result) == 0 ? 0 : $result;
    $to_report  = sprintf('%0.15g', $to_report);
}

unary_show 'Calculator', sub { $_[0] };

binary_doit 'constant_coefficient', sub { $_[0] * $_[1] };
show 'constant_coefficient', sub {
    my $self = shift;
    return $self->[0]->show() . ' ' . $self->[1]->show();
};

sub new_unary_function {
    my ($name, $rep, $sub) = @_;
    if (ref $sub ne 'CODE') {
        unary_doit $name, sub { $_[0]->$sub() };
    } else {
        unary_doit $name, $sub;
    };
    unary_show $name, sub { "$rep($_[0])" };
}

new_unary_function 'square_root',   'sqrt', 'bsqrt';
new_unary_function 'sine',   'sin',   'bsin';
new_unary_function 'cosine', 'cos', 'bcos';
new_unary_function 'secant', 'sec', sub { 1 / $_[0]->bcos() };
new_unary_function 'cosec',  'csc', sub { 1 / $_[0]->bsin() };
new_unary_function 'cotangent', 'cotan', sub {
    return $_[0]->copy->bcos() / $_[0]->copy->bsin();
};
new_unary_function 'tangent', 'tan', sub {
    return $_[0]->copy->bsin() / $_[0]->copy->bcos();
};
new_unary_function 'natural_logarithm', 'ln', 'blog';
new_unary_function 'factorial', 'factorial', 'bfac';

binary_doit 'logarithm', sub { $_[1]->blog($_[0]) };
binary_show 'logarithm', sub { "log$_[0]($_[1])" };


###############
#  Operators  #
###############

# new_binary_operator NAME, SYMBOL, ROUTINE
sub new_binary_operator {
    my ($name, $operator, $sub) = @_;
    no strict 'refs';
    binary_doit $name, $sub;
    binary_show $name, sub {
        "$_[0] $operator $_[1]";
    };
}
new_binary_operator 'subtract', '-',     sub { $_[0] - $_[1] };
new_binary_operator 'add', '+',          sub { $_[0] + $_[1] };
new_binary_operator 'multiply', '*',     sub { $_[0] * $_[1] };
new_binary_operator 'divide', '/',       sub { $_[0] / $_[1] };
new_binary_operator 'exponentiate', '^', sub { $_[0] ** $_[1] };
binary_doit 'exp',                       sub { $_[0] * 10 ** $_[1] };

sub new_constant {
    my ($name, $val, $print_name) = @_;
    $print_name = $name unless defined $print_name;
    my $const_name = "const_$name";
    doit $const_name, sub { Math::BigFloat->new($val) };
    show $const_name, sub { $print_name };
}

my $big_pi = Math::BigFloat->bpi();
my $big_e = Math::BigFloat->bexp(1);

# Constants go here.
new_constant 'pi', $big_pi, 'pi';
new_constant 'dozen', 12;
new_constant 'euler', $big_e, 'e';
new_constant 'score', 20;

1;

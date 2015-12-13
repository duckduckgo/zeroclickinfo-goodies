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
       Function                   bless => primary
    || Factor bless => primary
    # || NumTerm                    bless => primary
    # || NumTerm 'e':i NumTerm      bless => exp
    |  '(' Expression ')'         bless => paren assoc => group
    || ExprOp                     bless => primary
    | Term                        bless => primary
    # | Special                     bless => primary

Factor ::=
    NumTerm bless => primary
    || NumTerm 'e':i NumTerm bless => exp

# Operation ::=
#       Expression ('**') Expression bless => exponentiate assoc => right
#     | Expression ('^')  Expression bless => exponentiate assoc => right
#    || Expression ('*')  Expression bless => multiply
#     | Expression ('/')  Expression bless => divide
#    || Expression ('+')  Expression bless => add
#     | Expression ('-')  Expression bless => subtract

Term ::=
    TermOp bless => primary
    || Factor bless => primary

TermOp ::=
    Expression ('^') Term bless => exponentiate assoc => right
    || Factor ('squared') bless => square
    || Term ('*') Factor bless => multiply
    | Term ('/') Factor bless => divide
    | Term ('divided') ('by') Factor bless => divide

ExprOp ::=
    Expression ('+') Term bless => add
    | Expression ('-') Term bless => subtract


# Special ::=
#     Expression 'squared':i bless => square

NumTerm ::=
       Number Constant bless => constant_coefficent
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
    | ('tanh' ) Argument bless => hyperbolic_tangent
    | ('tan'  ) Argument bless => tangent
    | ('csc'  ) Argument bless => cosec
    | ('sec'  ) Argument bless => secant
    | ('cotan') Argument bless => cotangent
    | ('log'  ) NumTerm Argument bless => logarithm
    | ('ln'   ) Argument bless => natural_logarithm
    | ('log'  ) Argument bless => natural_logarithm

Argument ::= ('(') Expression (')') bless => primary

pi ~ 'pi':i
euler ~ 'e':i
dozen ~ 'dozen':i
score ~ 'score':i

Number ::=
    Integer   bless => init_integer
    | Decimal bless => init_decimal

Integer ~ '-' digits | digits
Decimal ~ '-' digits '.' digits | digits '.' digits
digits ~ [\d]+
:discard ~ whitespace
whitespace ~ [\s]+
END_OF_SOURCE
    }
);


# my $recce = Marpa::R2::Scanless::R->new(
#     { grammar => $grammar,
#       trace_terminals => 1,
#     } );


sub result_value {
  my $result_ref = $_;
  my $value_result = ${$result_ref}->doit();
  return $value_result;
}

sub result_show {
  my $result_ref = $_;
  my $show_result = ${$result_ref}->show();
  return $show_result;
}


my $number_re = number_style_regex();
my $funcy     = qr/[[a-z]+\(|log[_]?\d{1,3}\(|\^|\*|\/|squared|divided/;    # Stuff that looks like functions.

my %named_operations = (
    '\^'          => '**',
    'x'           => '*',
    '×'           => '*',
    '∙'           => '*',
    '⋅'           => '*',                                                   # Can be mistaken for dot operator
    'times'       => '*',
    'minus'       => '-',
    'plus'        => '+',
    'divided\sby' => '/',
    '÷'           => '/',
    'ln'          => 'log',                                                 # perl log() is natural log.
    'squared'     => '**2',
    'fact'        => 'Math::BigInt->new',
);

# my %named_constants = (
#     dozen => 12,
#     e     => 2.71828182845904523536028747135266249,                         # This should be computed.
#     pi    => pi,                                                            # pi constant from Math::Trig
#     gross => 144,
#     score => 20,
# );

# my $ored_constants = join('|', keys %named_constants);                      # For later substitutions

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

handle query_nowhitespace => sub {
    my $query = $_;
    $query =~ s/^(?:whatis|calculate|solve|math)//;
    $query =~ s/[∙⋅×]/*/g;
    $query =~ s#[÷]#/#g;
    my $recce = Marpa::R2::Scanless::R->new(
        { grammar => $grammar,
            # trace_terminals => 1,
        } );
    my $parsed = get_parse $recce, $query;
    return unless defined $parsed;
    my $str_result = ${$parsed}->show();
    my $val_result = ${$parsed}->doit();
    # my $vr = Math::BigFloat->new($val_result);
    # $vr->bfround(13);
    # $val_result = $vr->bstr();
    # $val_result = Math::BigFloat->new($val_result)->bfround(13)->bstr();
    $val_result = sprintf('%0.16g', $val_result);
    $val_result = Math::BigFloat->new($val_result)->bround(15)->bstr;
    $val_result = sprintf('%0.15g', $val_result);
    $val_result =~ s/(-?[0-9.]+)e(-?[\d.]+)/($1 * 10^$2)/g;
    $val_result =~ s/^\((.*)\)$/$1/;
    # my $str_result = result_show $$parsed;
    # my $val_result = result_value $parsed;
    my @numbers = grep { $_ =~ /^$number_re$/ } (split /\s+/, $val_result);
    my $style = number_style_for(@numbers);
    return unless $style;
    my $result = $style->for_display($val_result);
    # my $result = "$val_result";
    return $result,
        structured_answer => {
            id         => 'calculator',
            name       => 'Answer',
            # text       => $str_result . ' = ' . $result,
            data       => {
                title => "$result",
                subtitle => $str_result . ' = ' . $result,
            },
            # structured => {
            #     input     => [$str_result],
            #     operation => 'Calculate',
            #     result => html_enc($result),
            #     # result => "<a href='javascript:;' onclick='document.x.q.value=\"$result\";document.x.q.focus();'>" . $style->with_html($result) . "</a>"
            # },
            templates => {
              group => "text",
              moreAt => 0,
            },
        };
};
# handle query_nowhitespace => sub {
#     my $query = $_;
#
#     return if ($query =~ /\b0x/);      # Probably attempt to express a hexadecimal number, query_nowhitespace makes this overreach a bit.
#     return if ($query =~ $network);    # Probably want to talk about addresses, not calculations.
#     return if ($query =~ qr/(?:(?<pcnt>\d+)%(?<op>(\+|\-|\*|\/))(?<num>\d+)) | (?:(?<num>\d+)(?<op>(\+|\-|\*|\/))(?<pcnt>\d+)%)/);    # Probably want to calculate a percent ( will be used PercentOf )
#     return if ($query =~ /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$/); # Probably are searching for a phone number, not making a calculation
#
#     $query =~ s/^(?:whatis|calculate|solve|math)//;
#     $query =~ s/(factorial)/fact/;     #replace factorial with fact
#
#     # Grab expression.
#     my $tmp_expr = spacing($query, 1);
#
#
#     return if $tmp_expr eq $query;     # If it didn't get spaced out, there are no operations to be done.
#
#     # First replace named operations with their computable equivalents.
#     while (my ($name, $operation) = each %named_operations) {
#         $tmp_expr =~ s# $name # $operation #xig;
#         $query =~ s#$name#$operation#xig;    # We want these ones to show later.
#     }
#
#     $tmp_expr =~ s#log[_]?(\d{1,3})#(1/log($1))*log#xg;                # Arbitrary base logs.
#     $tmp_expr =~ s/ (\d+?)E(-?\d+)([^\d]|\b) /\($1 * 10**$2\)$3/ixg;   # E == *10^n
#     $tmp_expr =~ s/\$//g;                                              # Remove $s.
#     $tmp_expr =~ s/=$//;                                               # Drop =.
#     $tmp_expr =~ s/([0-9])\s*([a-zA-Z])([^0-9])/$1*$2$3/g;             # Support 0.5e or 0.5pi; but don't break 1e8
#     # Now sub in constants
#     while (my ($name, $constant) = each %named_constants) {
#         $tmp_expr =~ s# (\d+?)\s+$name # $1 * $constant #xig;
#         $tmp_expr =~ s#\b$name\b# $constant #ig;
#         $query =~ s#\b$name\b#($name)#ig;
#     }
#
#     my @numbers = grep { $_ =~ /^$number_re$/ } (split /\s+/, $tmp_expr);
#     my $style = number_style_for(@numbers);
#     return unless $style;
#
#     $tmp_expr = $style->for_computation($tmp_expr);
#     $tmp_expr =~ s/(Math::BigInt->new\((.*)\))/(Math::BigInt->new\($2\))->bfac()/g;    #correct expression for fact
#     # Using functions makes us want answers with more precision than our inputs indicate.
#     my $precision = ($query =~ $funcy) ? undef : ($query =~ /^\$/) ? 2 : max(map { $style->precision_of($_) } @numbers);
#     my $tmp_result;
#     eval {
#         # e.g. sin(100000)/100000 completely makes this go haywire.
#         alarm(1);
#         $tmp_result = eval($tmp_expr);
#         alarm(0);    # Assume the string processing will be "fast enough"
#     };
#
#     # Guard against non-result results
#     return unless (defined $tmp_result && $tmp_result ne 'inf' && $tmp_result ne '');
#     # Try to determine if the result is supposed to be 0, but isn't because of FP issues.
#     # If there's a defined precision, let sprintf worry about it.
#     # Otherwise, we'll say that smaller than 1e-14 was supposed to be zero.
#     # -14 selected to account for the result of sin(pi)
#     $tmp_result = 0 if (not defined $precision and ($tmp_result =~ /e\-(?<exp>\d+)$/ and $+{exp} > 14));
#     $tmp_result = sprintf('%0.' . $precision . 'f', $tmp_result) if ($precision);
#     # Dollars.
#     $tmp_result = '$' . $tmp_result if ($query =~ /^\$/);
#
#     my $results = prepare_for_display($query, $tmp_result, $style);
#
#     return if $results->{text} =~ /^\s/;
#     return $results->{text},
#       structured_answer => $results->{structured},
#       heading           => "Calculator";
# };
#
# sub prepare_for_display {
#     my ($query, $result, $style) = @_;
#
#     # Equals varies by output type.
#     $query =~ s/\=$//;
#     $query =~ s/(\d)[ _](\d)/$1$2/g;    # Squeeze out spaces and underscores.
#     # Show them how 'E' was interpreted. This should use the number styler, too.
#     $query =~ s/((?:\d+?|\s))E(-?\d+)/\($1 * 10^$2\)/i;
#     $query =~ s/\s*\*{2}\s*/^/g;    # Use prettier exponentiation.
#     $query =~ s/(Math::BigInt->new\((.*)\))/fact\($2\)/g;    #replace Math::BigInt->new( with fact(
#     $result = $style->for_display($result);
#     foreach my $name (keys %named_constants) {
#         $query =~ s#\($name\)#$name#xig;
#     }
#
#     return +{
#         text       => spacing($query) . ' = ' . $result,
#         structured => {
#             input     => [spacing($query)],
#             operation => 'Calculate',
#             result => "<a href='javascript:;' onclick='document.x.q.value=\"$result\";document.x.q.focus();'>" . $style->with_html($result) . "</a>"
#         },
#     };
# }

#separates symbols with a space
#spacing '1+1'  ->  '1 + 1'
# sub spacing {
#     my ($text, $space_for_parse) = @_;
#
#     $text =~ s/\s{2,}/ /g;
#     $text =~ s/(\s*(?<!<)(?:[\+\^xX×∙⋅\*\/÷\%]|(?<!\de)\-|times|plus|minus|dividedby)+\s*)/ $1 /ig;
#     $text =~ s/\s*dividedby\s*/ divided by /ig;
#     $text =~ s/(\d+?)((?:dozen|pi|gross|squared|score))/$1 $2/ig;
#     $text =~ s/([\(\)])/ $1 /g if ($space_for_parse);
#
#     return $text;
# }
package Calculator;

use Math::Trig;
use Math::BigFloat;

sub Calculator::primary::doit { return $_[0]->[0]->doit() }
sub Calculator::primary::show { return $_[0]->[0]->show() }
sub Calculator::Number::doit  { return $_[0]->[2] }
sub Calculator::Number::show  { return "$_[0]->[2]" };
sub Calculator::paren::doit   { my ($self) = @_; $self->[1]->doit() }
sub Calculator::paren::show   {
    my ($self) = @_;
    return '(' . $self->[1]->show() . ')'
}
sub Calculator::operation::doit { return $_[0]->[0]->doit() };
sub Calculator::operation::show { return $_[0]->[0]->show() };

sub Calculator::add::doit {
    my ($self) = @_;
    $self->[0]->doit() + $self->[1]->doit();
}


sub Calculator::subtract::doit {
    my ($self) = @_;
    $self->[0]->doit() - $self->[1]->doit();
}
sub Calculator::subtract::show {
    my ($self) = @_;
    return $self->[0]->show() . ' - ' . $self->[1]->show();
}


sub Calculator::multiply::doit {
    my ($self) = @_;
    $self->[0]->doit() * $self->[1]->doit();
}

sub singleton_doit {
  my ($name, $sub) = @_;
  my $full_name = 'Calculator::' . $name . '::doit';
  no strict 'refs';
  *$full_name = *{uc $full_name} = sub {
    my ($self) = @_;
    return $sub->($self->[0]->[2]);
  };
}
sub singleton_show {
  my ($name) = @_;
  my $full_name = 'Calculator::' . $name . '::show';
  no strict 'refs';
  *$full_name = *{uc $full_name} = sub {
    my ($self) = @_;
    return "$self->[0]->[2]";
  };
}

sub Calculator::init_integer::doit {
  my ($self) = @_;
  #return $self->[0]->[2];
  return Math::BigFloat->new($self->[0]->[2]);
}
sub Calculator::init_integer::show {
  my ($self) = @_;
  return "$self->[0]->[2]";
}
sub Calculator::init_decimal::doit {
  my ($self) = @_;
  # return $self->[0]->[2];
  return Math::BigFloat->new($self->[0]->[2]);
}
sub Calculator::init_decimal::show {
  my ($self) = @_;
  return "$self->[0]->[2]";
}
# singleton_doit qw(init_integer), (sub { return $_ });
# singleton_show qw(init_integer);

sub show_binary {
  my ($operation_name, $operation_symbol) = @_;
  my $full_name = 'Calculator::' . $operation_name . '::show';
  no strict 'refs';
  *$full_name = *{uc $full_name} = sub {
    my ($self) = @_;
    return $self->[0]->show() . " $operation_symbol " . $self->[1]->show();
  };
}

show_binary qw(multiply), '*';
show_binary qw(add), '+';
show_binary qw(divide), '/';


sub Calculator::divide::doit {
    my ($self) = @_;
    $self->[0]->doit() / $self->[1]->doit();
}

sub Calculator::exponentiate::doit {
    my ($self) = @_;
    $self->[0]->doit()**$self->[1]->doit();
}
sub Calculator::exponentiate::show {
    my ($self) = @_;
    return $self->[0]->show() . ' ^ ' . $self->[1]->show();
}

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
        my ($self) = @_;
        return $sub($self->[0]->doit(), $self->[1]->doit());
    };
}

doit qw(square), sub {
    my ($self) = @_;
    my $val = $self->[0]->doit();
    return $val * $val;
};

show qw(square), sub {
    my ($self) = @_;
    return $self->[0]->show() . ' squared';
};

sub Calculator::exp::doit {
  my ($self) = @_;
  return $self->[0]->doit() * (10 ** $self->[1]->doit());
}
sub Calculator::exp::show {
  my ($self) = @_;
  return $self->[0]->show() . 'e' . $self->[1]->show();
}

sub Calculator::Calculator::doit {
    my ($self) = @_;
    return join q{ }, map { $_->doit() } @{$self};
}

sub Calculator::Calculator::show {
  my ($self) = @_;
  return join q{ }, map { $_->show() } @{$self};
}

doit qw(square_root), sub {
    my ($self) = @_;
    return $self->[0]->doit->bsqrt();
};
show qw(square_root), sub {
    my ($self) = @_;
    return 'sqrt(' . $self->[0]->show() . ')';
};

doit 'constant_coefficent', sub {
    my ($self) = @_;
    return $self->[0]->doit() * $self->[1]->doit();
};
show 'constant_coefficent', sub {
    my ($self) = @_;
    return $self->[0]->show() . ' ' . $self->[1]->show();
};

doit 'sine', sub {
    my ($self) = @_;
    return $self->[0]->doit->bsin();
};
show 'sine', sub {
    my ($self) = @_;
    return 'sin(' . $self->[0]->show() . ')';
};
doit 'cosine', sub {
    my ($self) = @_;
    return $self->[0]->doit->bcos(30);
};
show 'cosine', sub {
    my ($self) = @_;
    return 'cos(' . $self->[0]->show() . ')';
};
doit 'cosec', sub { return csc($_[0]->[0]->doit()) };
show 'cosec', sub { return 'csc(' . $_[0]->[0]->show() . ')' };
doit 'secant', sub { return sec($_[0]->[0]->doit()) };
show 'secant', sub { return 'sec(' . $_[0]->[0]->show() . ')' };
doit 'cotangent', sub { return cot($_[0]->[0]->doit()) };
show 'cotangent', sub { return 'cotan(' . $_[0]->[0]->show() . ')' };
doit 'hyperbolic_tangent', sub { return tanh($_[0]->[0]->doit()) };
show 'hyperbolic_tangent', sub { return 'tanh(' . $_[0]->[0]->show() . ')' };
doit 'tangent', sub {
    my ($self) = @_;
    my $num = $self->[0]->doit();
    my $denom = cos($num);
    my $numer = sin($num);
    return $numer / $denom;
    # return Math::Trig->tan($self->[0]->doit());
};

show 'tangent', sub { return 'tan(' . $_[0]->[0]->show() . ')' };
# show 'tangent', sub {
#     my ($self) = @_;
#     return 'tan(' . $self->[0]->show() . ')';
# };

doit 'logarithm', sub {
    my ($self) = @_;
    my ($base, $num) = ($self->[0]->doit(), $self->[1]->doit());
    return $num->logbase($base);
};
show 'logarithm', sub {
    my ($self) = @_;
    my ($base, $num) = ($self->[0]->show(), $self->[1]->show());
    return "log$base($num)";
};
doit 'natural_logarithm', sub {
    my ($self) = @_;
    return log($self->[0]->doit());
};
show 'natural_logarithm', sub {
    my ($self) = @_;
    return 'ln(' . $self->[0]->show() . ')';
};

sub const_doit {
    my ($name, $val) = @_;
    my $full_name = 'Calculator::const_' . $name . '::doit';
    no strict 'refs';
    *$full_name = *{uc $full_name} = sub {
        return $val;
    };
}
sub const_show {
    my ($name, $rep) = @_;
    my $full_name = 'Calculator::const_' . $name . '::show';
    no strict 'refs';
    *$full_name = *{uc $full_name} = sub {
        return $rep;
    };
}
sub Calculator::const_pi::doit { return Math::BigFloat->bpi() }
sub Calculator::const_pi::show { return 'pi' };

const_doit qw(dozen), 12;
const_show qw(dozen), 'dozen';
const_doit qw(euler), Math::BigFloat->bexp(1);
const_show qw(euler), 'e';
const_doit qw(score), 20;
const_show qw(score), 'score';

1;


# (pi^4+pi^5)^(1/6)+1 is quite slow!

package DDG::Goodie::Calculator;
# ABSTRACT: do simple arthimetical calculations

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use Marpa::R2;
use List::Util qw( max );
use Math::Trig;
use Math::BigInt;
use utf8;

zci answer_type => "calc";
zci is_cached   => 1;

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
       NumTerm                    bless => primary
    || NumTerm 'e':i NumTerm      bless => exp
    |  '(' Expression ')'         bless => paren assoc => group
    || Operation                 bless => operation

Operation ::=
      Expression '**' Expression bless => exponentiate assoc => right
   || Expression '*'  Expression bless => multiply
    | Expression '/'  Expression bless => divide
   || Expression '+'  Expression bless => add
    | Expression '-'  Expression bless => subtract

NumTerm ::=
      Constant bless => primary
    | Number   bless => primary

Constant ::=
      pi    bless => const_pi
    | euler bless => const_euler

pi ~ 'pi':i
euler ~ 'e':i

Number ~ [\d]+
:discard ~ whitespace
whitespace ~ [\s]+
# allow comments
:discard ~ <hash comment>
<hash comment> ~ <terminated hash comment> | <unterminated
   final hash comment>
<terminated hash comment> ~ '#' <hash comment body> <vertical space char>
<unterminated final hash comment> ~ '#' <hash comment body>
<hash comment body> ~ <hash comment char>*
<vertical space char> ~ [\x{A}\x{B}\x{C}\x{D}\x{2028}\x{2029}]
<hash comment char> ~ [^\x{A}\x{B}\x{C}\x{D}\x{2028}\x{2029}]
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
  CORE::say "ref (in result_show): $result_ref";
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

my %named_constants = (
    dozen => 12,
    e     => 2.71828182845904523536028747135266249,                         # This should be computed.
    pi    => pi,                                                            # pi constant from Math::Trig
    gross => 144,
    score => 20,
);

my $ored_constants = join('|', keys %named_constants);                      # For later substitutions

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

handle query_nowhitespace => sub {
    my $query = $_;
    $query =~ s/^(?:whatis|calculate|solve|math)//;
    my $recce = Marpa::R2::Scanless::R->new(
        { grammar => $grammar,
          trace_terminals => 1,
        } );
    my $parsed = get_parse $recce, $query;
    return unless defined $parsed;
    my $str_result = ${$parsed}->show();
    my $val_result = ${$parsed}->doit();
    # my $str_result = result_show $$parsed;
    # my $val_result = result_value $parsed;
    my $result = "$val_result";
    return $result,
        structured_answer => {
            text       => $str_result . ' = ' . $result,
            structured => {
                input     => [$str_result],
                operation => 'Calculate',
                result => html_enc($result),
                # result => "<a href='javascript:;' onclick='document.x.q.value=\"$result\";document.x.q.focus();'>" . $style->with_html($result) . "</a>"
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

sub Calculator::primary::doit { return $_[0]->[0]->doit() }
sub Calculator::primary::show { return $_[0]->[0]->show() }
sub Calculator::Number::doit  { return $_[0]->[2] }
sub Calculator::Number::show  { return "$_[0]->[2]" };
sub Calculator::paren::doit   { my ($self) = @_; $self->[1]->doit() }
sub Calculator::paren::show   {
    my ($self) = @_;
    Data::Printer::p $self->[1];
    return '( ' . $self->[1]->show() . ' )'
}
sub Calculator::operation::doit { return $_[0]->[0]->doit() };
sub Calculator::operation::show { return $_[0]->[0]->show() };

sub Calculator::add::doit {
    my ($self) = @_;
    $self->[0]->doit() + $self->[2]->doit();
}


sub Calculator::subtract::doit {
    my ($self) = @_;
    $self->[0]->doit() - $self->[2]->doit();
}
sub Calculator::subtract::show {
    my ($self) = @_;
    return $self->[0]->show() . ' - ' . $self->[2]->show();
}

sub Calculator::multiply::doit {
    my ($self) = @_;
    $self->[0]->doit() * $self->[2]->doit();
}


sub show_binary {
  my ($operation_name, $operation_symbol) = @_;
  my $full_name = 'Calculator::' . $operation_name . '::show';
  no strict 'refs';
  *$full_name = *{uc $full_name} = sub {
    my ($self) = @_;
    return $self->[0]->show . " $operation_symbol " . $self->[2]->show();
  };
}

show_binary qw(multiply), '*';
show_binary qw(add), '+';


sub Calculator::divide::doit {
    my ($self) = @_;
    $self->[0]->doit() / $self->[2]->doit();
}

sub Calculator::exponentiate::doit {
    my ($self) = @_;
    $self->[0]->doit()**$self->[2]->doit();
}
sub Calculator::exponentiate::show {
    my ($self) = @_;
    return $self->[0]->show() . '^' . $self->[2]->show();
}

sub Calculator::exp::doit {
  my ($self) = @_;
  return $self->[0]->doit() * (10 ** $self->[2]->doit());
}
sub Calculator::exp::show {
  my ($self) = @_;
  return $self->[0]->show() . 'e' . $self->[2]->show();
}

sub Calculator::Calculator::doit {
    my ($self) = @_;
    return join q{ }, map { $_->doit() } @{$self};
}

sub Calculator::Calculator::show {
  my ($self) = @_;
  return join q{ }, map { $_->show() } @{$self};
}

sub Calculator::const_pi::doit { return Math::BigFloat->bpi() }
sub Calculator::const_pi::show { return 'pi' };

1;

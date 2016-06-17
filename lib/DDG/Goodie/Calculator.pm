package DDG::Goodie::Calculator;
# ABSTRACT: perform simple arithmetical calculations

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';
use utf8;

use DDG::Goodie::Calculator::Parser;
use DDG::Goodie::Calculator::Result::User;

zci answer_type => "calculation";
zci is_cached   => 1;

my $what = qr/^\s*(?:what\s*is|calculate|solve|math)\s*/;

my $decimal = qr/(-?\d++[,.]?\d*+)|([,.]\d++)/;
# Check for binary operations
triggers query_nowhitespace => qr/($decimal|\w+)(\W+|x)($decimal|\w+)/;
# Factorial
triggers query_nowhitespace => qr/\d+[!]/;
# Check for functions
triggers query_nowhitespace => qr/\w+\(.*\)/;
# Check for constants and named operations
triggers query_nowhitespace => qr/$decimal\W*\w+/;
triggers query_nowhitespace => qr/\W*[[:alpha:]]+$decimal/;
# They might want to find out what fraction a decimal represents
triggers query_nowhitespace => qr/[,.]\d+/;
# Misc checks for other words
triggers query_lc => qr/$what?.++(radian|degree|square|\b(pi|e)\b)/;

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

sub standardize_symbols {
    my $text = shift;
    # Only replace x's surrounded by non-alpha characters so it
    # can occur in function names.
    $text =~ s/(?<![[:alpha:]])x(?![[:alpha:]])/*/g;
    $text =~ s/[∙⋅×]/*/g;
    $text =~ s#[÷]#/#g;
    $text =~ s/\*{2}/^/g;
    $text =~ s/π/pi/g;
    $text =~ s/τ/tau/g;
    $text =~ s/°/degrees/g;
    $text =~ s/㎭/radians/g;
    return $text;
}

my $grammar_text = <<'END_OF_GRAMMAR';
:default ::= action => [value] bless => primary
lexeme default = action => [ start, length, value ]
    bless => ::name latm => 1

:start ::= Calculator

Calculator ::= Expression

Expression ::=
       ExprOp bless => primary
    || Term   bless => primary

Term ::=
       TermOp   bless => primary
    || Factor   bless => primary

TermOp ::= GenFactorTermOp | GenTermOp

ExprOp ::= GenExprOp

Factor ::=
       Function                 bless => primary
    || ('(') Expression (')')   bless => paren assoc => group
    || NumTerm                  bless => primary
    || NumTerm ('e':i) NumTerm  bless => exp
    || PostfixModifier

# Make postfix modifiers play well with both functions and
# factors. (e.g., with factorial(3) squared - without this it
# becomes factorial((3) squared) ).
FactorFun ::=
       Function bless => primary
    || Factor   bless => primary

PostfixModifier ::=
       GenPostfixFunctionModifier
    || GenPostfixFactorModifier

NumTerm ::=
       FactoredConstant bless => primary
    |  Number Function  bless => factored_function
    || Constant         bless => primary
    |  Number           bless => primary

FactoredConstant ::=
      Number WordConstant   bless => factored_word_constant
    | Number SymbolConstant bless => factored_symbol_constant

Constant ::=
      WordConstant
    | SymbolConstant

Function ::=
      GenUnaryFunction
    | UnaryFunction
    | GenBinaryFunction

UnaryFunction ::=
      ('log_' ) NumTerm Argument bless => logarithm
    | ('log'  ) NumTerm Argument bless => logarithm

# Argument for a unary function.
Argument ::= Term bless => primary

Number ::=
      [$] BaseNumber                  bless => prefix_currency
    |     BaseNumber                  bless => primary
    |     BaseNumber (<degree forms>) bless => angle_degrees
    |     BaseNumber (<radian forms>) bless => angle_radians

<degree forms> ~ 'degrees':i | 'degree':i | 'degs':i | 'deg':i

<radian forms> ~ 'radians':i | 'radian':i | 'rads':i | 'rad':i

BaseNumber ::=
      Integer
    | Decimal

Integer ::= integer bless => integer
Decimal ::= decimal bless => decimal
integer ~    '-' digits     | digits
decimal ~    '-' digits '.'   digits | digits '.' digits
           | '.' digits     | digits '.'
           | '-' digits '.'

digits     ~ [\d]+

:discard   ~ whitespace
whitespace ~ [\s]+
END_OF_GRAMMAR

my $grammar = generate_grammar($grammar_text);

sub to_display {
    my $query = shift;
    my $currency = get_currency $query;
    $query       = standardize_symbols $query;
    my $style    = get_style $query or return;
    my $user_result = DDG::Goodie::Calculator::Result::User->new({
        raw_query => $query,
        style     => $style,
        grammar   => $grammar,
        currency  => $currency,
    });
    my $formatted_input = $user_result->formatted_input;
    my $result = $user_result->format_for_display;
    return unless defined $result;
    # Didn't come up with anything the user didn't already know.
    return if ($formatted_input eq $result);
    return ($formatted_input, $result);
}



handle query => sub {
    my $query = $_;

    return if should_not_trigger $query;
    $query =~ s/$what//;
    my ($generated_input, $result) = to_display $query or return;
    return unless defined $result && defined $generated_input;
    return $result,
        structured_answer => {
            data => {
                title    => "$result",
                subtitle => "Calculate: $generated_input",
            },
            meta => {
                signal => 'high',
            },
            templates => {
                group  => 'text',
                moreAt => '0',
            },
        };
};

1;

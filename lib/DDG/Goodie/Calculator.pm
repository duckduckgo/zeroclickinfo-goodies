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
# Misc checks for other words
triggers query_lc => qr/(radian|degree|square|\b(pi|e)\b)/;

my $calculator_re = qr/^(interactive )?calculator$/i;
# Allow 'calculator' forms
triggers query_lc => $calculator_re;

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
    $text =~ s/°/degrees/g;
    $text =~ s/㎭/radians/g;
    return $text;
}

my $grammar_text = share('grammar.txt')->slurp();

my $grammar = generate_grammar($grammar_text);

sub angle_symbol_for {
    my $angle_type = shift // '';
    if ($angle_type eq 'degree') {
        return '°';
    } elsif ($angle_type eq 'radian') {
        return ' ㎭';
    };
    return '';
}

# Builds the 'text_result' for non-interactive displays.
sub format_for_display {
    my %result = @_;
    return $result{currency} . $result{decimal}
        if defined $result{currency};
    my $text = '';
    my $displayed_fraction = 0;
    if ($result{is_rational} && $result{should_display_fraction}) {
        $text .= $result{fraction};
        $displayed_fraction = 1;
    }
    if ($result{is_integer}) {
        $text .= '≈ ' unless $result{is_exact};
        return $text . $result{decimal} . angle_symbol_for($result{angle_type});
    }
    return $text unless defined $result{decimal};
    $text .= ' ' if $text;
    if ($result{is_exact_decimal}) {
        $text .= '= ' if $displayed_fraction;
    } else {
        $text .= '≈ ';
    }
    return $text . $result{decimal};
}

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
    my $result = $user_result->build_result_format();
    return unless defined $result;
    my $text_result = format_for_display(%{$result});
    return unless defined $formatted_input and defined $text_result;
    # Didn't come up with anything the user didn't already know.
    return if ($formatted_input eq $text_result);
    return {
        formatted_input => $formatted_input,
        text_result     => $text_result,
        fraction        => $result->{fraction},
        decimal         => $result->{decimal},
    };
}


my %operations = (
    trig_functions => [
        {
            name => 'FN_SIN',
            rep  => 'sin',
        },
        {
            name => 'FN_COS',
            rep  => 'cos',
        },
        {
            name => 'FN_TAN',
            rep  => 'tan',
        },
    ],
);

handle query => sub {
    my $query = $_;

    my ($decimal, $fraction, $generated_input, $result);
    if ($query =~ $calculator_re) {
        $decimal = 0;
        $generated_input = '0';
        $result = '0';
    } else {
        return if should_not_trigger $query;
        $query =~ s/^\s*(?:what\s*is|calculate|solve|math)\s*//;
        $result = to_display $query or return;
        $generated_input = $result->{formatted_input};
        $fraction = $result->{fraction};
        $decimal  = $result->{decimal};
        $result = $result->{text_result};
        return unless defined $result && defined $generated_input;
    }
    return $result,
        structured_answer => {
            id   => 'calculator',
            name => 'Calculator',
            data => {
                decimal      => $decimal,
                fraction     => $fraction,
                parsed_input => "$generated_input",
                text_result  => "$result",
                operations   => \%operations,
            },
            meta => {
                signal => 'high',
            },
            templates => {
                group   => 'base',
                options => {
                    content => 'DDH.calculator.calculator',
                },
                moreAt => '0',
            },
        };
};

1;

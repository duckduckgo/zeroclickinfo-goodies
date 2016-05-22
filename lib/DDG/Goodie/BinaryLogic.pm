package DDG::Goodie::BinaryLogic;
# ABSTRACT: bit-wise logical operations.

use strict;
use DDG::Goodie;
use utf8;

use Marpa::R2;

# Regexp triggers are used to find cases where the logical symbol
# for 'not' is at the beginning of the query (e.g. the case '¬1')
triggers query_raw => qr/.*\s+(and|or|xor)\s+.*/i;
triggers query_raw => qr/.*\s*(⊕|∧|∨)\s*.*/;
triggers query_raw => qr/not\s+.*/i;
triggers query_raw => qr/¬.*/;

zci is_cached => 1;
zci answer_type => "binary_logic";

my $rules = <<'END_OF_GRAMMAR';
:default ::= action => ::first
:start ::= Expression

Expression ::= Term

Term ::=
       ('(') Term (')') assoc => group action => ::first
     | Number
     | 'not' Term action => do_not
    || Term 'xor' Term action => do_xor
     | Term 'and' Term action => do_and
     | Term 'or' Term action => do_or

Number ::=
       HexNumber action => hex_number
     | BinaryNumber action => binary_number
     | DecimalNumber

HexNumber ~ '0x' HexDigits
BinaryNumber ~ '0b' BinaryDigits
HexDigits ~ [0-9A-Fa-f]+
BinaryDigits ~ [01]+
DecimalNumber ~ [0-9]+

:discard ~ whitespace
whitespace ~ [\s]+
END_OF_GRAMMAR

sub BinaryLogic_Actions::hex_number {
    my (undef, $t2) = @_;
    return hex(lc($t2));
}

sub BinaryLogic_Actions::binary_number {
    my (undef, $t2) = @_;
    return oct(lc($t2));
}

sub BinaryLogic_Actions::do_and {
    my (undef, $t1, undef, $t2) = @_;
    return int($t1) & int($t2);
}

sub BinaryLogic_Actions::do_or {
    my (undef, $t1, undef, $t2) = @_;
    return int($t1) | int($t2);
}

sub BinaryLogic_Actions::do_xor {
    my (undef, $t1, undef, $t2) = @_;
    return int($t1) ^ int($t2);
}

sub BinaryLogic_Actions::do_not {
    my (undef, undef, $t1) = @_;
    return ~int($t1);
}

handle query_lc => sub {
    my $input = $_;

    my $testError = $input;
    $testError =~ s/(?:0x|0b|[\d\s]|and|or|xor|not|\(|\)|⊕|∧|∨|¬)//ig;
    return if length $testError != 0;

    my $grammar = Marpa::R2::Scanless::G->new({ source => \$rules });
    my $recce = Marpa::R2::Scanless::R->new({
        grammar => $grammar,
        semantics_package => 'BinaryLogic_Actions'
    });

    # Substitute the unicode characters. The parser does not seem to
    # like unicode.
    $input =~ s/\s?⊕\s?/ xor /;
    $input =~ s/\s?∧\s?/ and /;
    $input =~ s/\s?∨\s?/ or /;
    $input =~ s/¬\s?/not /;

    my $subtitle = "Bitwise Operation: ".uc($input);
    my @numbers = $subtitle =~ /\b((?:0x|0b)?[\da-f]+)\b/gi;

    # using eval to catch possible errors with $@
    eval { $recce->read( \$input ) };
    return if ( $@ );

    my $value_ref = $recce->value();
    return if not defined $value_ref;
    my $text_output = "${$value_ref}";

    my $numInBin;
    foreach my $number (@numbers) {
        if ($number =~ /^0x/i) {
            $numInBin = sprintf "%b", hex($number);
        } elsif ($number =~ /^0b/i) {
            $numInBin = $number;
            $numInBin =~ s/^0b//i;
        } else {
            $numInBin = sprintf "%b", $number;
        }
        $subtitle =~ s/\b$number\b/$numInBin/g;
    }

    return $text_output, structured_answer => {
        data => {
            title => $text_output,
            subtitle => $subtitle
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    }
};

1;

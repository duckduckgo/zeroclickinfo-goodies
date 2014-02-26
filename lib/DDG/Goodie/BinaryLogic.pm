# -*- coding: utf-8 -*-

package DDG::Goodie::BinaryLogic;

use DDG::Goodie;
use utf8;

use Marpa::R2;

# Regexp triggers are used to find cases where the logical symbol
# for 'not' is at the beginning of the query (e.g. the case '¬1')
triggers query_raw => qr/.*\s+(and|or|xor|⊕|∧|∨)\s+.*/;
triggers query_raw => qr/not\s+.*/;
triggers query_raw => qr/¬.*/;

# zci is_cached => 1;
zci answer_type => "binary_logic"; 

attribution
    github => ['https://github.com/MithrandirAgain', 'MithrandirAgain'],
    github => ['https://github.com/bpaschen', 'Bjoern Paschen'],
    twitter => ['https://twitter.com/Prypjat', 'Bjoern Paschen'];

primary_example_queries '4 xor 5', '3 and 2', '1 or 1234';
secondary_example_queries 
    '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985', 
    '10 and 12',
    '34 or 100',
    '10 and (30 or 128)',
    '0x01 or not 0X100';
description 'take two numbers and do bitwise logical operations (exclusive-or, or, and, not) on them';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/BinaryLogic.pm';
category 'calculations';
topics 'math';

# TODO: - add binary numbers. 
#         the parser callback is already available but the 
#         lexer grammar did not work.
#         (BinaryLogic_Actions::bin_number)
my $rules = <<'END_OF_GRAMMAR';
:default ::= action => ::first
:start ::= Expression

Expression ::= Term

Term ::=
       ('(') Term (')') assoc => group action => ::first
     | Number
    || Term 'xor' Term action => do_xor
     | Term 'and' Term action => do_and
     | Term 'or' Term action => do_or
     | 'not' Term action => do_not

Number ::= 
       '0x' HexDigits action => hex_number
     | '0X' HexDigits action => hex_number
     | DecimalDigits

DecimalDigits ~ [\d]+
HexDigits ~ [\dA-Fa-f]+

:discard ~ whitespace
whitespace ~ [\s]+
END_OF_GRAMMAR

sub BinaryLogic_Actions::hex_number {
    my (undef, undef, $t2) = @_;
    return hex($t2);
}

sub BinaryLogic_Actions::bin_number {
    my (undef, undef, $t2) = @_;
    return oct "0b$t2";
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

handle query_raw => sub {
    my $grammar = Marpa::R2::Scanless::G->new( { source => \$rules } );
    my $recce = Marpa::R2::Scanless::R->new( 
        { grammar => $grammar,
          semantics_package => 'BinaryLogic_Actions' } );
    
    my $input = $_;
    
    # Substitute the unicode characters. The parser does not seem to 
    # like unicode.
    $input =~ s/⊕/ xor /;
    $input =~ s/∧/ and /;
    $input =~ s/∨/ or /;
    $input =~ s/¬/ not /;

    # using eval to catch possible errors with $@
    eval { $recce->read( \$input ) };

    if ( $@ ) { 
        return; 
    }
    
    my $value_ref = $recce->value();

    return if not defined $value_ref;
    
    my $text_output = ${$value_ref};
    my $html_output = "<div>Result: <b>" . ${$value_ref} . "</b></div>";
    my $heading = "Binary Logic: '" . $_ . "'";
    
    return answer => $text_output, html => $html_output, heading => $heading;
};

1;

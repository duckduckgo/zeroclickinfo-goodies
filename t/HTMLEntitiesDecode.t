#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'html_entity';

ddg_goodie_test(
    [qw(DDG::Goodie::HTMLEntitiesDecode)],

    # Simple decimal test 
    'html decode &#33;' => test_zci("Decoded HTML Entity: !, Decimal: 33, Hexadecimal: 0021", html => qr/&#33;/),
    # Simple text test 
    'html entity &amp;' => test_zci("Decoded HTML Entity: &, Decimal: 38, Hexadecimal: 0026", html => qr/&amp;/),
    # Another simple text test
    'decode html for &gt;' => test_zci("Decoded HTML Entity: >, Decimal: 62, Hexadecimal: 003e", html => qr/&gt;/),
    # Simple hex test 
    '&#x21 htmlentity' => test_zci("Decoded HTML Entity: !, Decimal: 33, Hexadecimal: 0021", html => qr/&#x21;/),

    # No "&" and ";" in decimal input
    '#36 html decode' => test_zci("Decoded HTML Entity: \$, Decimal: 36, Hexadecimal: 0024", html => qr/&#36;/),
    # Variety in hex queries
    '&#X22 decodehtml' => test_zci("Decoded HTML Entity: \", Decimal: 34, Hexadecimal: 0022", html => qr/&#X22;/),
    # More variety in hex queries
    'htmlentity for #x3c' => test_zci("Decoded HTML Entity: <, Decimal: 60, Hexadecimal: 003c", html => qr/&#x3c;/),

    # "&cent;" succeeds
    'html decode &cent;' => test_zci(qr/ Decimal: 162, Hexadecimal: 00a2/, html => qr/&cent;/),
    # "&cent" also succeeds (missing back ";" is OK)
    'html decode &cent' => test_zci(qr/ Decimal: 162, Hexadecimal: 00a2/, html => qr/&cent;/),
    # "cent" fails during the regex match because of the missing front "&" (stricter for text to eliminate false positive encoding hits)
    'html decode cent' => undef,
    # "cent;" fails during the regex match for the same reasons as above
    'html decode cent;' => undef,   

    # "&#20;" has no visual representation
    'html entity of &#20;' => test_zci("Decoded HTML Entity: Unicode control character (no visual representation), Decimal: 20, Hexadecimal: 0014", html => qr/Unicode control character/),
    
    # Querying for "&bunnyrabbit;" should fail
    'html decode &bunnyrabbit;' => undef,
    # Trying to decode "&" should fail (this is an encoding job)
    'html decode &' => undef,
    # Trying to decode apostrophe should fail (decode_entities() unsuccessful)
    'html decode apostrophe' => undef,

    # natural querying
    'What is the decoded html entity for &#960;?' => test_zci(qr/ Decimal: 960, Hexadecimal: 03c0/, html => qr/&#960;/),
    # natural querying
    'what is decoded html entity for #960 ?' => test_zci(qr/ Decimal: 960, Hexadecimal: 03c0/, html => qr/&#960;/),
    # no "html" in query
    'the decoded entity for &#333; is?' => test_zci(qr/ Decimal: 333, Hexadecimal: 014d/, html => qr/&#333;/),
);

done_testing;

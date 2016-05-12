#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'html_entity';
zci is_cached   => 1;

sub build_structured_answer {
    my ($title, $subtitle) = @_;
	return {
	    data => {
	        title => $title,
	        subtitle => $subtitle,
	    },
	    templates => {
	        group => 'text',
	        options => {
	            content => 'DDH.html_entity.content'
	        }
	    }
	};
}

sub build_test {
	my($text, $title, $subtitle) = @_;
	return test_zci($text, structured_answer => build_structured_answer($title, $subtitle));
}

ddg_goodie_test(
    [qw(DDG::Goodie::HTMLEntitiesDecode)],

    # Simple decimal test
    'html decode &#33;' => build_test("Decoded HTML Entity: !", "!", "HTML Entity Decode: &amp;#33;"),
    # Simple text test
    'html entity &amp;' => build_test("Decoded HTML Entity: &", "&amp;","HTML Entity Decode: &amp;amp;"),
    # Another simple text test
    'decode html for &gt;' => build_test("Decoded HTML Entity: >", "&gt;","HTML Entity Decode: &amp;gt;"),
    # Simple hex test
    '&#x21 htmlentity' => build_test("Decoded HTML Entity: !", "!","HTML Entity Decode: &amp;#x21"),

    # No "&" and ";" in decimal input
    '#36 html decode' => build_test('Decoded HTML Entity: $', '$',"HTML Entity Decode: #36"),
    # Variety in hex queries
    '&#X22 decodehtml' => build_test('Decoded HTML Entity: "', '&quot;',"HTML Entity Decode: &amp;#X22"),
    # More variety in hex queries
    'htmlentity for #x3c' => build_test("Decoded HTML Entity: <", "&lt;","HTML Entity Decode: #x3c"),

    # "&cent;" succeeds
    'html decode &cent;' => build_test(qr/.*/, "&cent;","HTML Entity Decode: &amp;cent;"),
    # "&cent" also succeeds (missing back ";" is OK)
    'html decode &cent' => build_test(qr/.*/, "&cent;","HTML Entity Decode: &amp;cent"),
    # "cent" fails during the regex match because of the missing front "&" (stricter for text to eliminate false positive encoding hits)
    'html decode cent' => undef,
    # "cent;" fails during the regex match for the same reasons as above
    'html decode cent;' => undef,

    # "&#20;" has no visual representation
    'html entity of &#20;' => build_test("Decoded HTML Entity: Unicode control character (no visual representation)", "Unicode control character (no visual representation)","HTML Entity Decode: &amp;#20;"),

    # Querying for "&bunnyrabbit;" should fail
    'html decode &bunnyrabbit;' => undef,
    # Trying to decode "&" should fail (this is an encoding job)
    'html decode &' => undef,
    # Trying to decode apostrophe should fail (decode_entities() unsuccessful)
    'html decode apostrophe' => undef,

    # natural querying
    'What is the decoded html entity for &#960;?' => build_test("Decoded HTML Entity: π", "&pi;","HTML Entity Decode: &amp;#960;"),
    
    # natural querying
    'what is decoded html entity for #960 ?' => build_test("Decoded HTML Entity: π", "&pi;","HTML Entity Decode: #960"),
    # no "html" in query
    'the decoded entity for &#333; is?' => build_test("Decoded HTML Entity: ō", "&#x14D;","HTML Entity Decode: &amp;#333;"),
);

done_testing;

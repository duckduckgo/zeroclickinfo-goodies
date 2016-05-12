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

ddg_goodie_test(
    [qw(DDG::Goodie::HTMLEntitiesDecode)],

    # Simple decimal test
    'html decode &#33;' => test_zci("Decoded HTML Entity: !", structured_answer => build_structured_answer("!", "HTML Entity Decode: &amp;#33;")),
    # Simple text test
    'html entity &amp;' => test_zci("Decoded HTML Entity: &", structured_answer => build_structured_answer("&amp;","HTML Entity Decode: &amp;amp;")),
    # Another simple text test
    'decode html for &gt;' => test_zci("Decoded HTML Entity: >", structured_answer => build_structured_answer("&gt;","HTML Entity Decode: &amp;gt;")),
    # Simple hex test
    '&#x21 htmlentity' => test_zci("Decoded HTML Entity: !", structured_answer => build_structured_answer("!","HTML Entity Decode: &amp;#x21")),

    # No "&" and ";" in decimal input
    '#36 html decode' => test_zci('Decoded HTML Entity: $', structured_answer => build_structured_answer('$',"HTML Entity Decode: #36")),
    # Variety in hex queries
    '&#X22 decodehtml' => test_zci('Decoded HTML Entity: "', structured_answer => build_structured_answer('&quot;',"HTML Entity Decode: &amp;#X22")),
    # More variety in hex queries
    'htmlentity for #x3c' => test_zci("Decoded HTML Entity: <", structured_answer => build_structured_answer("&lt;","HTML Entity Decode: #x3c")),

    # "&cent;" succeeds
    'html decode &cent;' => test_zci(qr/.*/, structured_answer => build_structured_answer("&cent;","HTML Entity Decode: &amp;cent;")),
    # "&cent" also succeeds (missing back ";" is OK)
    'html decode &cent' => test_zci(qr/.*/, structured_answer => build_structured_answer("&cent;","HTML Entity Decode: &amp;cent")),
    # "cent" fails during the regex match because of the missing front "&" (stricter for text to eliminate false positive encoding hits)
    'html decode cent' => undef,
    # "cent;" fails during the regex match for the same reasons as above
    'html decode cent;' => undef,

    # "&#20;" has no visual representation
    'html entity of &#20;' => test_zci("Decoded HTML Entity: Unicode control character (no visual representation)", structured_answer => build_structured_answer("Unicode control character (no visual representation)","HTML Entity Decode: &amp;#20;")),

    # Querying for "&bunnyrabbit;" should fail
    'html decode &bunnyrabbit;' => undef,
    # Trying to decode "&" should fail (this is an encoding job)
    'html decode &' => undef,
    # Trying to decode apostrophe should fail (decode_entities() unsuccessful)
    'html decode apostrophe' => undef,

    # natural querying
    'What is the decoded html entity for &#960;?' => test_zci("Decoded HTML Entity: π", structured_answer => build_structured_answer("&pi;","HTML Entity Decode: &amp;#960;")),
    
    # natural querying
    'what is decoded html entity for #960 ?' => test_zci("Decoded HTML Entity: π", structured_answer => build_structured_answer("&pi;","HTML Entity Decode: #960")),
    # no "html" in query
    'the decoded entity for &#333; is?' => test_zci("Decoded HTML Entity: ō", structured_answer => build_structured_answer("&#x14D;","HTML Entity Decode: &amp;#333;")),
);

done_testing;

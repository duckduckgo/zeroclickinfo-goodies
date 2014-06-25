#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'html_entity';

ddg_goodie_test(
    [qw(DDG::Goodie::HTMLEntitiesEncode)],

    # A simple test
    'html code em dash' => test_zci("Encoded HTML Entity: &mdash;", html => qr/mdash/),

    # Hyphens in-between don't matter
    'html code em-dash' => test_zci("Encoded HTML Entity: &mdash;", html => qr/mdash/),

    # Quotes don't matter
    'html encode "em-dash"' => test_zci("Encoded HTML Entity: &mdash;", html => qr/mdash/),

    # Variety in querying accented chars #1
    'html entity A-acute' => test_zci("Encoded HTML Entity: &Aacute;",html => qr/Aacute/),

    # Variety in querying accented chars #2
    'html entity for E Grave' => test_zci("Encoded HTML Entity: &Egrave;", html => qr/Egrave/),

    # Query is a single typed-in character to encode
    'html escape &' => test_zci("Encoded HTML Entity: &amp;", html => qr/amp/),

    # Single typed-in character query with (ignored) 'sign' 
    '$ sign htmlentity' => test_zci("Encoded HTML Entity: &#36;", html => qr/#36/),

    # Return two matching entities for ambiguous query
    'pound symbol html encode ' => test_zci("Encoded HTML Entity: &pound;\nEncoded HTML Entity: &#35;", html => qr/pound.*#35|#35.*pound/),

    # Ignore both 'of' and 'sign'
    'html code of pilcrow sign' => test_zci("Encoded HTML Entity: &#182;", html => qr/#182/),

    # Ignore 'symbol'
    'html escape greater than symbol' => test_zci("Encoded HTML Entity: &gt;", html => qr/gt/),

    # Handle extra space
    'space    html character code' => test_zci("Encoded HTML Entity: &nbsp;", html => qr/nbsp/),

    # Mixed cases in query
    'ApoSTrophe escapehtml' => test_zci("Encoded HTML Entity: &#39;", html => qr/#39/),

    # 'right angle brackets' should work even though the defined key contains the singular 'bracket'
    'right angle brackets htmlencode' => test_zci("Encoded HTML Entity: &rsaquo;\nEncoded HTML Entity: &raquo;", html => qr/rsaquo.*raquo|raquo.*rsaquo/),

    # 'double quotes' should work even though the defined key contains the singular 'quote'
    'double quotes htmlescape' => test_zci("Encoded HTML Entity: &quot;", html => qr/quot/),

    # Should not work (would make sense to decode the query though!)
    'html encode &#43;' => undef,

    # Should not work (would make sense to decode the query though!)
    'html entity &amp;' => undef,

    # Should not work
    'html encode is it magic' => undef,
);

done_testing;

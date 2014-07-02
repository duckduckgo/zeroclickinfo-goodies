#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'html_entity';

ddg_goodie_test(
    [qw(DDG::Goodie::HTMLEntitiesEncode)],

    # Simple tests
    'html code em dash' => test_zci("Encoded HTML Entity: &mdash;", html => qr/mdash/),
    'html em dash' => test_zci("Encoded HTML Entity: &mdash;", html => qr/mdash/),
    'em-dash html' => test_zci("Encoded HTML Entity: &mdash;", html => qr/mdash/), # hyphens ignored
    'html encode "em-dash"' => test_zci("Encoded HTML Entity: &mdash;", html => qr/mdash/), # quotes ignored
    'ApoSTrophe escapehtml' => test_zci("Encoded HTML Entity: &#39;", html => qr/#39/), # mixed cases in query

    # Basic varieties in querying accented chars
    'html entity A-acute' => test_zci("Encoded HTML Entity: &Aacute;",html => qr/Aacute/),
    'html entity for E Grave' => test_zci("Encoded HTML Entity: &Egrave;", html => qr/Egrave/),
    'html Ograve' => test_zci("Encoded HTML Entity: &Ograve;", html => qr/Ograve/),

    # Single typed-in character queries
    'html escape &' => test_zci("Encoded HTML Entity: &amp;", html => qr/amp/), # &
    'html escape "' => test_zci("Encoded HTML Entity: &quot;", html => qr/quot/), # "
    'how to html escape &?' => test_zci("Encoded HTML Entity: &amp;", html => qr/amp/), # ?
    'how to html escape "&"?' => test_zci("Encoded HTML Entity: &amp;", html => qr/amp/), # &
    'how to html escape ??' => test_zci("Encoded HTML Entity: &#63;", html => qr/#63/), # ?
    'how do you html escape a "?"?' => test_zci("Encoded HTML Entity: &#63;", html => qr/#63/), # ?
    'html escape """' => test_zci("Encoded HTML Entity: &quot;", html => qr/quot/), # "
    '$ sign htmlentity' => test_zci("Encoded HTML Entity: &#36;", html => qr/#36/), # $

    # Return two matching entities for ambiguous query
    'pound symbol html encode ' => test_zci("Encoded HTML Entity: &pound;\nEncoded HTML Entity: &#35;", html => qr/pound.*#35|#35.*pound/),

    # Ignore words and whitespace
    'html code of pilcrow sign' => test_zci("Encoded HTML Entity: &#182;", html => qr/#182/), # of, sign
    'html escape greater than symbol' => test_zci("Encoded HTML Entity: &gt;", html => qr/gt/), # symbol
    'space    html character code' => test_zci("Encoded HTML Entity: &nbsp;", html => qr/nbsp/), # Ignore extra whitespace

    # Better hash hits substitutions
    # 'right angle brackets' should work even though the defined key contains the singular 'bracket'
    'right angle brackets htmlencode' => test_zci("Encoded HTML Entity: &rsaquo;\nEncoded HTML Entity: &raquo;", html => qr/rsaquo.*raquo|raquo.*rsaquo/),
    # 'double quotes' should work even though the defined key contains the singular 'quote'
    'double quotes htmlescape' => test_zci("Encoded HTML Entity: &quot;", html => qr/quot/),

    # Should not work (would make sense to decode theese queries though!)
    'html encode &#43;' => undef,
    'html entity &amp;' => undef,
    # Should also not work
    'html encode is it magic' => undef, # most certainly, it is

    # Natural querying
    'What is the html character code for pi' => test_zci("Encoded HTML Entity: &#960;", html => qr/#960/),
    'whatis html entity for en-dash' => test_zci("Encoded HTML Entity: &ndash;", html => qr/ndash/), # whatis spelling
    'how do I escape the greater-than symbol html' => test_zci("Encoded HTML Entity: &gt;", html => qr/gt/),

    # the "a/A" belonging to "acute" matters, but the "a" immediately after "character" is removed
    'How to get a a acute character in html code' => test_zci("Encoded HTML Entity: &aacute;", html => qr/aacute/),
    'how to get a a-acute character in html code' => test_zci("Encoded HTML Entity: &aacute;", html => qr/aacute/),
    'how to get a aacute character in html code' => test_zci("Encoded HTML Entity: &aacute;", html => qr/aacute/),
    'how to get a A acute character in html code' => test_zci("Encoded HTML Entity: &Aacute;", html => qr/Aacute/),    
    'how to get a A-acute character in html code' => test_zci("Encoded HTML Entity: &Aacute;", html => qr/Aacute/),
    'how to get a Aacute character in html code' => test_zci("Encoded HTML Entity: &Aacute;", html => qr/Aacute/),

    # Question marks ignored
    'the encoded html entity of apostrophe is?' => test_zci("Encoded HTML Entity: &#39;", html => qr/#39/),
    'how to encode an apostrophe in html ? ' => test_zci("Encoded HTML Entity: &#39;", html => qr/#39/), # spaces around the end

    # Question mark matters
    'how to encode "?" in html' => test_zci("Encoded HTML Entity: &#63;", html => qr/#63/),
);

done_testing;

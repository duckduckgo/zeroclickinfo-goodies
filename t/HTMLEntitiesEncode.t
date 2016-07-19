#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'html_entity';
zci is_cached   => 1;

sub make_structured_answer {
    my ($qr) = @_;
    return {
            input       => ignore(),
            operation   => "HTML Entity Encode",
            result      => $qr,
    };
}

sub make_record_answer {
    my ($data, $keys, $question) = @_;
    return {
            templates => {
                group => 'list',
                options => {
                    content => 'record',
                }
            },
            data => {
                title => "$question",
                subtitle => "HTML Entity Encode",
                record_data => $data,
                record_keys => $keys,
            }
        };
}

ddg_goodie_test(
    [qw(DDG::Goodie::HTMLEntitiesEncode)],

    # Simple tests
    'html code em dash' => test_zci("Encoded HTML Entity: &mdash;", structured_answer => make_structured_answer(re(qr/mdash/))),
    'html em dash' => test_zci("Encoded HTML Entity: &mdash;", structured_answer => make_structured_answer(re(qr/mdash/))),
    'em-dash html' => test_zci("Encoded HTML Entity: &mdash;", structured_answer => make_structured_answer(re(qr/mdash/))), # hyphens ignored
    'html encode "em-dash"' => test_zci("Encoded HTML Entity: &mdash;", structured_answer => make_structured_answer(re(qr/mdash/))), # quotes ignored
    'ApoSTrophe escapehtml' => test_zci("Encoded HTML Entity: &#39;", structured_answer => make_structured_answer(re(qr/#39/))), # mixed cases in query

    # Basic varieties in querying accented chars
    'html entity A-acute' => test_zci("Encoded HTML Entity: &Aacute;",structured_answer => make_structured_answer(re(qr/Aacute/))),
    'html entity for E Grave' => test_zci("Encoded HTML Entity: &Egrave;", structured_answer => make_structured_answer(re(qr/Egrave/))),
    'html Ograve' => test_zci("Encoded HTML Entity: &Ograve;", structured_answer => make_structured_answer(re(qr/Ograve/))),

    # Single typed-in character queries
    'html escape &' => test_zci("Encoded HTML Entity: &amp;", structured_answer => make_structured_answer(re(qr/amp/))), # &
    'html escape "' => test_zci("Encoded HTML Entity: &quot;", structured_answer => make_structured_answer(re(qr/quot/))), # "
    'how to html escape &?' => test_zci("Encoded HTML Entity: &amp;", structured_answer => make_structured_answer(re(qr/amp/))), # ?
    'how to html escape "&"?' => test_zci("Encoded HTML Entity: &amp;", structured_answer => make_structured_answer(re(qr/amp/))), # &
    'how to html escape ??' => test_zci("Encoded HTML Entity: &#63;", structured_answer => make_structured_answer(re(qr/#63/))), # ?
    'how do you html escape a "?"?' => test_zci("Encoded HTML Entity: &#63;", structured_answer => make_structured_answer(re(qr/#63/))), # ?
    'html escape """' => test_zci("Encoded HTML Entity: &quot;", structured_answer => make_structured_answer(re(qr/quot/))), # "
    '$ sign htmlentity' => test_zci("Encoded HTML Entity: &#36;", structured_answer => make_structured_answer(re(qr/#36/))), # $

    # Return two matching entities for ambiguous query
    'pound symbol html encode ' => test_zci(
        "Encoded HTML Entity: &pound;\nEncoded HTML Entity: &#35;",
        structured_answer => make_record_answer({
            "British Pound Sterling (£)" => "&pound;",
            "Number sign (#)"             => "&#35;"
        }, ["British Pound Sterling (£)", "Number sign (#)"], "pound")
    ),

    # Ignore words and whitespace
    'html code of pilcrow sign' => test_zci("Encoded HTML Entity: &#182;", structured_answer => make_structured_answer(re(qr/#182/))), # of, sign
    'html escape greater than symbol' => test_zci("Encoded HTML Entity: &gt;", structured_answer => make_structured_answer(re(qr/gt/))), # symbol
    'space    html character code' => test_zci("Encoded HTML Entity: &nbsp;", structured_answer => make_structured_answer(re(qr/nbsp/))), # Ignore extra whitespace

    # Better hash hits substitutions
    # 'right angle brackets' should work even though the defined key contains the singular 'bracket'
    'right angle brackets htmlencode' => test_zci(
        "Encoded HTML Entity: &rsaquo;\nEncoded HTML Entity: &raquo;", 
        structured_answer => make_record_answer({
            "Single right pointing angle quote (›)" => "&rsaquo;",
            "Double right pointing angle quote (»)" => "&raquo;"
        }, ["Single right pointing angle quote (›)", "Double right pointing angle quote (»)"], "right angle brackets")
    ),
    # 'double quotes' should work even though the defined key contains the singular 'quote'
    'double quotes htmlescape' => test_zci("Encoded HTML Entity: &quot;", structured_answer => make_structured_answer(re(qr/quot/))),

    # Should not work
    'html encode &#43;' => undef,
    'html entity &amp;' => undef,
    'html encode is it magic' => undef, 

    # Natural querying
    'What is the html character code for pi' => test_zci("Encoded HTML Entity: &#960;", structured_answer => make_structured_answer(re(qr/#960/))),
    'whatis html entity for en-dash' => test_zci("Encoded HTML Entity: &ndash;", structured_answer => make_structured_answer(re(qr/ndash/))), # whatis spelling
    'how do I escape the greater-than symbol html' => test_zci("Encoded HTML Entity: &gt;", structured_answer => make_structured_answer(re(qr/gt/))),

    # the "a/A" belonging to "acute" matters, but the "a" immediately after "character" is removed
    'How to get a a acute character in html code' => test_zci("Encoded HTML Entity: &aacute;", structured_answer => make_structured_answer(re(qr/aacute/))),
    'how to get a a-acute character in html code' => test_zci("Encoded HTML Entity: &aacute;", structured_answer => make_structured_answer(re(qr/aacute/))),
    'how to get a aacute character in html code' => test_zci("Encoded HTML Entity: &aacute;", structured_answer => make_structured_answer(re(qr/aacute/))),
    'how to get a A acute character in html code' => test_zci("Encoded HTML Entity: &Aacute;", structured_answer => make_structured_answer(re(qr/Aacute/))),
    'how to get a A-acute character in html code' => test_zci("Encoded HTML Entity: &Aacute;", structured_answer => make_structured_answer(re(qr/Aacute/))),
    'how to get a Aacute character in html code' => test_zci("Encoded HTML Entity: &Aacute;", structured_answer => make_structured_answer(re(qr/Aacute/))),

    # Question marks ignored
    'the encoded html entity of apostrophe is?' => test_zci("Encoded HTML Entity: &#39;", structured_answer => make_structured_answer(re(qr/#39/))),
    'how to encode an apostrophe in html ? ' => test_zci("Encoded HTML Entity: &#39;", structured_answer => make_structured_answer(re(qr/#39/))), # spaces around the end

    # Question mark matters
    'how to encode "?" in html' => test_zci("Encoded HTML Entity: &#63;", structured_answer => make_structured_answer(re(qr/#63/))),
);

done_testing;

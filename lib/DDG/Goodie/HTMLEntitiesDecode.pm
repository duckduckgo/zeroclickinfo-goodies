package DDG::Goodie::HTMLEntitiesDecode;
# ABSTRACT: Decode HTML Entities.
# HTML Entity Encoding has been moved to a separate module

use DDG::Goodie;
use HTML::Entities 'decode_entities';
use Unicode::UCD 'charinfo';
use warnings;
use strict;

zci answer_type =>          'html_entity';
zci is_cached   =>          1;
triggers any =>             'html', 'entity', 'htmldecode', 'decodehtml', 'htmlentity';
primary_example_queries     'html decode &#33;', 'html decode &amp';
secondary_example_queries   'html entity &#x21' , '#36 decode html', 'what is the decoded html entity of &#36;';
description                 'Decode HTML entities';
name                        'HTMLEntitiesDecode';
code_url                    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HTMLEntitiesDecode.pm';
category                    'computing_tools';
topics                      'programming';
attribution twitter => ['crazedpsyc','crazedpsyc'],
            cpan    => ['CRZEDPSYC','crazedpsyc'],
            twitter =>      ['https://twitter.com/nshanmugham', 'Nishanth Shanmugham'],
            web     =>      ['http://nishanths.github.io', 'Nishanth Shanmugham'],
            github  =>      ['https://github.com/nishanths', 'Nishanth Shanmugham'];

handle remainder => sub {
    $_ =~ s/^\s+|\s+$//g; # remove front and back whitespace
    $_ =~ s/(\bwhat\s*is\s*(the)?)//ig; # remove "what is the" (optional: the)
    $_ =~ s/\b(the|for|of|is|entity|decode|decoded|code|character)\b//ig; # remove filler words
    $_ =~ s/^\s+|\s+$//g; # remove front and back whitespace that existed in between that may show up after removing the filler words
    $_ =~ s/\s*\?$//g; # remove ending question mark
    return unless ((/^(&?#(?:[0-9]+(?!_))+;?)$/) || (/^(&(?:[a-zA-Z]+(?!_))+;?)$/) || (/^(&?#[xX](?:[0-9A-Fa-f]+(?!_))+;?)$/)); # decimal (&#39;) || text with no underscores (&cent;) || hex (&#x27;)
                                                                                                                                # "&" optional for all
                                                                                                                                # ";" optional except in text type
                                                                                                                                # "?" optional: question-like queries

    # Standardize the query so it works well with library decoding functions
    my $entity = $1;
    $entity =~ s/^&?/&/; # append '&' at the front
    $entity =~ s/;?$/;/; # append ';' at the back

    # Attempt to decode, exit if unsuccessful
    my $decoded = decode_entities($entity); # decode_entities() returns the input if unsuccesful
    my $decimal = ord($decoded);
    my $hex = sprintf("%04x", $decimal);
    return if (lc $entity eq lc $decoded); # safety net -- makes trying to decode something not real like "&enchantedbunny;" fail

    # If invisible character, provide link instead of displaying it
    my $info = charinfo($decimal); # charinfo() returns undef if input is not a "real" character
    return unless (defined $info); # another safety net
    if ($$info{name} eq '<control>') {
        $decoded = "Unicode control character (no visual representation)";
        $entity = "<a href='https://en.wikipedia.org/wiki/Unicode_control_characters'>Unicode control character</a> (no visual representation)";
    } elsif(substr($$info{category},0,1) eq 'C') {
        $decoded = "Special character (no visual representation)";
        $entity = "<a href='https://en.wikipedia.org/wiki/Special_characters'>Special character (no visual representation)";
    }

    # Make answer
    return "Decoded HTML Entity: $decoded, Decimal: $decimal, Hexadecimal: $hex",
           html => qq(<div class="zci--htmlentitiesdecode"><div class="large"><span class="text--secondary">Decoded HTML Entity: </span><span class="text--primary">$entity</span></div><div class="small"><span class="text--secondary">Decimal: <span class="text--primary">$decimal</span>, Hexadecimal: <span class="text--primary">$hex</span></div></div></div>);
};

1;

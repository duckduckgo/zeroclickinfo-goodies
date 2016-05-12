package DDG::Goodie::HTMLEntitiesDecode;
# ABSTRACT: Decode HTML Entities.
# HTML Entity Encoding has been moved to a separate module

use strict;
use DDG::Goodie;
use HTML::Entities 'decode_entities';
use Unicode::UCD 'charinfo';
use Text::Trim;
use warnings;
use strict;

zci answer_type =>          'html_entity';
zci is_cached   =>          1;
triggers any =>             'html', 'entity', 'htmldecode', 'decodehtml', 'htmlentity';

handle remainder => sub {
    $_ = trim $_; # remove front and back whitespace
    $_ =~ s/(\bwhat\s*is\s*(the)?)//ig; # remove "what is the" (optional: the)
    $_ =~ s/\b(the|for|of|is|entity|decode|decoded|code|character)\b//ig; # remove filler words
    $_ = trim $_; # remove front and back whitespace that existed in between that may show up after removing the filler words
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
    return if (lc $entity eq lc $decoded); # safety net -- makes trying to decode something not real like "&enchantedbunny;" fail

    # If invisible character, provide link instead of displaying it
    my $info = charinfo($decimal); # charinfo() returns undef if input is not a "real" character
    return unless (defined $info); # another safety net
    if ($$info{name} eq '<control>') {
        $decoded = "Unicode control character (no visual representation)";
    } elsif(substr($$info{category},0,1) eq 'C') {
        $decoded = "Special character (no visual representation)";
    }

    return "Decoded HTML Entity: $decoded",
        structured_answer => {
            data => {
                title => html_enc($decoded),
                subtitle => 'HTML Entity Decode: '.html_enc($_)                
            },
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.html_entity.content'
                }
            }
        };
};

1;

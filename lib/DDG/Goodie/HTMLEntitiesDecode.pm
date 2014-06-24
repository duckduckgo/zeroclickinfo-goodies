package DDG::Goodie::HTMLEntitiesDecode;
# ABSTRACT: Decode HTML Entities.
# HTML Entity Encoding has been moved to a separate module

use DDG::Goodie;
use HTML::Entities 'decode_entities';
use Unicode::UCD 'charinfo';
use warnings;
use strict;

zci answer_type =>          'html_entity';
triggers startend =>        'html decode', 'decode html', 'html entity',
                            'htmldecode', 'decodehtml', 'htmlentity';
primary_example_queries     'html decode &#33;', 'html decode &amp';
secondary_example_queries   'html entity &#x21' , '#36 decode html';
description                 'Decode HTML entities';
name                        'HTMLEntitiesDecode';
code_url                    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HTMLEntitiesDecode.pm';
category                    'computing_tools';
topics                      'programming';
attribution twitter =>      'crazedpsyc',
            cpan    =>      'CRZEDPSYC' ,
            twitter =>      ['https://twitter.com/nshanmugham', 'Nishanth Shanmugham'],
            web     =>      ['http://nishanths.github.io', 'Nishanth Shanmugham'],
            github  =>      ['https://github.com/nishanths', 'Nishanth Shanmugham'];

my $css = share("style.css")->slurp();
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
};

handle remainder => sub {
    $_ =~ s/^\s*//g; # remove front whitespace
    $_ =~ s/^(for|of)\s+//g; # remove filler words at the start
    $_ =~ s/\s*$//g; # remove back whitespace
    return unless ((/^(&?#(?:[0-9]+(?!_))+;?)$/) || (/^(&(?:[a-zA-Z]+(?!_))+;?)$/) || (/^(&?#[xX](?:[0-9A-Fa-f]+(?!_))+;?)$/)); # decimal (&#39;) || text with no underscores (&cent;) || hex (&#x27;)
                                                                                                                                # "&" optional for all
                                                                                                                                # ";" optional except in text type

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
    return "Decoded HTML Entity: $decoded, decimal: $decimal, hexadecimal: $hex",
           html => append_css(qq(<div class="zci--htmlentitiesdecode"><span class="line">Decoded HTML Entity: <span class="entity">$entity</span>, decimal: <span class="entity">$decimal</span>, hexadecimal: <span class="entity">$hex</span></span></div>));
};

1;

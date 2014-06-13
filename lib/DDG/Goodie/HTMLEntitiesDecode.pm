package DDG::Goodie::HTMLEntitiesDecode;
# ABSTRACT: Decode HTML Entities.

use DDG::Goodie;
use HTML::Entities 'decode_entities';
use Unicode::UCD 'charinfo';
use warnings;
use strict;

zci answer_type => 'html_entity';
primary_example_queries 'html decode &#33;', 'html decode &amp';
secondary_example_queries 'html decode &#x21' , '#36 html entity';
description 'Decode HTML entities';
name 'HTMLEntitiesDecode';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HTMLEntitiesDecode.pm';
category 'computing_tools';
topics 'programming';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ,
            twitter => ['nshanmugham', 'Nishanth Shanmugham'],
            web => ['http://nishanths.github.io', 'Nishanth Shanmugham'],
            github => ['https://github.com/nishanths', 'Nishanth Shanmugham'];

triggers startend => 'html decode', 'decode html', 'html entity';

my $label = "Decoded HTML Entity: ";
handle remainder => sub {
    $_ =~ s/^\s*//g; # remove front whitespace
    $_ =~ s/^(for|of)\s+//g; # remove filler words at the start
    $_ =~ s/\s*$//g; # remove back whitespace.
    return unless $_; # guard against (now) empty string

    if ( (/^(&?#?(?:[0-9]+(?!_))+;?)$/) || (/^(&?(?:[a-zA-Z]+(?!_))+;?)$/) || (/^(&?#?(?:0)?[xX](?:[0-9A-Fa-f]+(?!_))+;?)$/) ) { # Regex guard - capture if there is only one entity (examples: &#8271; , &bsol;, but NOT: &#54h;) in the query, otherwise our ia may be a false positive
    	my $entity = $1; 
        $entity =~ s/^&?/&/; # append an ampersand in front (better decode_entities results and more freedom in input)
    	$entity =~ s/;?$/;/; # append a semicolon (some entities like &mdash do not work without one) (also better decode_entities results and more freedom in input)
        
        # decode_entities will return the input if it cannot be decoded
        my $decoded = decode_entities($entity);
        my $decimal = ord($decoded);
        my $hex = sprintf("%04x", $decimal);

        # $decoded is used in text output, $entity is used in html output

        my $info = charinfo($decimal); # charinfo() returns undef if input is not a "real" character
        return unless (defined $info);

        # Check if $decoded is an invisible character, and if it is, then provide a link instead of printing it on screen 
        if ($$info{name} eq '<control>') { 
            $decoded = "Unicode control character (no visual representation)";
            $entity = "<a href='https://en.wikipedia.org/wiki/Unicode_control_characters'>Unicode control character</a> (no visual representation)";
        }

        elsif(substr($$info{category},0,1) eq 'C') {
            $decoded = "Special character (no visual representation)";
            $entity = "<a href='https://en.wikipedia.org/wiki/Special_characters'>Special character (no visual representation)";
        }

        return $label . "$decoded, decimal: $decimal, hexadecimal: $hex",
               html => "<div>" . $label . $entity . ", decimal: $decimal, hexadecimal: <a href=\"/?q=U%2B$hex\">$hex</a></div>" unless (lc $entity eq lc $decoded);
    }

    return;
};

1;

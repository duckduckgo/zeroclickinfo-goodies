package DDG::Goodie::HTMLEntitiesDecode;
# ABSTRACT: Decode HTML Entities.

use DDG::Goodie;
use HTML::Entities 'decode_entities';
use Unicode::UCD 'charinfo';
use warnings;
use strict;

zci answer_type => 'html_entity';
primary_example_queries 'html decode &#33;', 'html decode &amp';
secondary_example_queries 'html decode &#x21' , '#36 html decode';
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

triggers startend => 'html decode', 'decode html';

my $label = "Decoded HTML Entity: ";
handle remainder => sub {
    $_ =~ s/^\s*//g; # remove front whitespace
    $_ =~ s/^(for|of)\s+//g; # remove filler words at the start
    $_ =~ s/\s*$//g; # remove back whitespace.
    return unless $_; # guard against (now) empty string

    if ( (/^(&?#?(?:[0-9]+(?!_))+;?)$/) || (/^(&?(?:[a-zA-Z]+(?!_))+;?)$/) || (/^(&?#?x{1}(?:[0-9A-Fa-f]+(?!_))+;?)$/) ) { # Regex guard - capture if there is only one entity (examples: &#8271; , &bsol;, but NOT: &#54h;) in the query, otherwise our ia may be a false positive
    	my $entity = $1; # &#8271; # INPUT
        $entity =~ s/^&?/&/; # append an ampersand in front (better decode_entities results and more freedom in input)
    	$entity =~ s/;?$/;/; # append a semicolon (some entities like &mdash do not work without one) (also better decode_entities results and more freedom in input)
        my $decoded = decode_entities($entity); # decode_entities will return the input if it cannot be decoded
        my $decimal = ord($decoded);
        my $hex = sprintf("%04x", $decimal);

        my $info = charinfo($decimal);
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
               html => $label . $entity . ", decimal: $decimal, hexadecimal: <a href=\"/?q=U%2B$hex\">$hex</a>" unless $entity eq $decoded;
    }

    return;
};

1;

package DDG::Goodie::HTMLEntities;
# ABSTRACT: Decode HTML Entities.

use DDG::Goodie;
use HTML::Entities;
use Unicode::UCD 'charinfo';

zci answer_type => 'html_entity';

zci is_cached => 1;

triggers query_nowhitespace => qr/^(?:html|entity|htmlentity)?(&#?\w+;?)$/i;

primary_example_queries '&#33;';
secondary_example_queries 'html entity &amp;';
description 'decode HTML entities';
name 'HTMLEntities';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HTMLEntities.pm';
category 'computing_tools';
topics 'programming';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

handle matches => sub {
    my $entity = $_[0];
    $entity =~ s/;?$/;/; # append a semicolon (some entities like &mdash do not work without one)
    my $decoded = decode_entities($entity);
    my $decoded_html = $decoded;
    my $decimal = ord($decoded);

    my $info = charinfo($decimal);
    if( $$info{name} eq '<control>' ) {
        $decoded_html = "<a href='https://en.wikipedia.org/wiki/Unicode_control_characters'>Unicode control character</a> (no visual representation)";
        $decoded = "Unicode control character (no visual representation)";
    }
    

    my $hex = sprintf("%04x", $decimal);
    return "Decoded HTML Entity: $decoded, decimal: $decimal, hexadecimal: $hex", 
           html => "Decoded HTML Entity: $decoded_html, decimal: $decimal, hexadecimal: <a href=\"/?q=U%2B$hex\">$hex</a>" unless $entity eq $decoded; # decode_entities will return the input if it cannot be decoded
    return;
};

1;

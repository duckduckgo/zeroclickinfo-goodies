package DDG::Goodie::HTMLEntities;
# ABSTRACT: Decode HTML Entities.

use DDG::Goodie;
use HTML::Entities;
use Unicode::UCD 'charinfo';

zci answer_type => 'html_entity';

zci is_cached => 1;

triggers query_nowhitespace => qr/^(?:
    (?:html|entity|htmlentity|htmldecode)?(&\#?\w+;?) |
    html(?:entity|encode)?(.{1,50})
    )$/ix;

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
    my ($entity, $decoded) = @_;
    my $html;
    my $decimal;
    my $encoding = 0;
    if (defined $entity) { # decoding
        $entity =~ s/;?$/;/; # append a semicolon (some entities like &mdash do not work without one)
        $decoded = decode_entities($entity);
        $html = $entity;
    } else { # encoding
        $encoding = 1;
        $entity = encode_entities($decoded);
        $html = encode_entities($entity);
    }

    $decimal = ord($decoded);
    my $info = charinfo($decimal);
    if( $$info{name} eq '<control>' ) {
        $html = "<a href='https://en.wikipedia.org/wiki/Unicode_control_characters'>Unicode control character</a> (no visual representation)";
        $decoded = "Unicode control character (no visual representation)";
    } 
    elsif(substr($$info{category},0,1) eq 'C') {
        $decoded = "Special character (no visual representation)";
        $html = "Special character (no visual representation)";
    }
    

    my $hex = sprintf("%04x", $decimal);
    my $label = $encoding ? "Encoded HTML: " : "Decoded HTML Entity: ";
    # decode_entities will return the input if it cannot be decoded
    return $label . ($encoding  ? "$entity" : "$decoded, decimal: $decimal, hexadecimal: $hex"),
           html => $label.$html.($encoding ? "" : ", decimal: $decimal, hexadecimal: <a href=\"/?q=U%2B$hex\">$hex</a>") unless $entity eq $decoded;
    return;
};

1;

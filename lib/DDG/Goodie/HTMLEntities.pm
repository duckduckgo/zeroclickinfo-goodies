package DDG::Goodie::HTMLEntities;
# ABSTRACT: Decode HTML Entities.

use DDG::Goodie;
use HTML::Entities;

zci answer_type => 'html_entity';

zci is_cached => 1;

triggers query_nowhitespace => qr/^(?:html|entity|htmlentity)?&#?\w+;?$/i;

handle query_nowhitespace => sub {
    s/^(?:html)?(?:entity)?//i;
    s/;?$/;/; # append a semicolon (some entities like &mdash do not work without one)
    my $decoded = decode_entities($_);
    return "Decoded HTML Entity: " . $decoded . ", decimal: " . ord($decoded) unless $_ eq $decoded; # decode_entities will return the input if it cannot be decoded
    return;
};
1;

package DDG::Goodie::IDN;
# ABSTRACT: Convert domain names from/to Punycode.

use strict;
use DDG::Goodie;
use Net::IDN::Encode ':all';
use utf8;

triggers startend => (
    'idn',
    'international domain',
    'internationalize domain',
    'internationalized domain'
);

handle query_lc => sub {
    return unless s/(international(?:ized?)? domain(?: name)?|idn) //;
    my $idn = ($1 eq "idn" ? uc $1 : $1) . ": ";
    $idn = 'internationalized domain: ' if $1 eq 'internationalize domain';
    return unless m/\.(ac|ad|ae|aero|af|ag|ai|al|am|an|ao|aq|ar|arpa|as|asia|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|biz|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cat|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|com|coop|cr|cu|cv|cw|cx|cy|cz|de|dj|dk|dm|do|dz|ec|edu|ee|eg|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gov|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|info|int|io|iq|ir|is|it|je|jm|jo|jobs|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|local|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mil|mk|ml|mm|mn|mo|mobi|mp|mq|mr|ms|mt|mu|museum|mv|mw|mx|my|mz|na|name|nc|ne|net|nf|ng|ni|nl|no|np|nr|nu|nz|om|org|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|pro|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sx|sy|sz|tc|td|tel|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|travel|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|xxx|ye|yt|za|zm|zw)$/i;

    my $string_answer = (/^xn--/ ? 'Decoded ' . $idn . domain_to_unicode($_) : 'Encoded ' . $idn . domain_to_ascii($_));
    my $title = (/^xn--/ ? domain_to_unicode($_) : domain_to_ascii($_));
    my $subtitle = (/^xn--/ ? $_ . " decoded" : $_ . " encoded");

    return $string_answer, structured_answer => {
        data => {
            title => $title,
            subtitle => $subtitle,
        },
        templates => {
            group => 'text'
        }
    }
};

zci is_cached => 1;

1;

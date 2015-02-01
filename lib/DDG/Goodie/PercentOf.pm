package DDG::Goodie::PercentOf;
# Operations with percentuals

use DDG::Goodie;

zci answer_type => "percent_of";
zci is_cached   => 1;

name "PercentOf";
description "Makes Operations with percentuals";
primary_example_queries "4-50%", "349*16%";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PercentOf/PercentOf.pm";
attribution github => ["puskin94", "puskin"];

my $result;

triggers query_nowhitespace => qr/\d{1,3}\%$/;

handle query_nowhitespace => sub {

    my $input = $_;

    return unless $input =~ qr/(\d+\.?\d*)(\+|\*|\/|\-)(\d+\.?\d*)\%/;


    if ($2 eq '-') {
        $result = ( $1 - (($1 * $3) / 100) );
    } elsif ($2 eq '+') {
        $result = ( $1 + (($1 * $3) / 100) );
    } elsif ($2 eq '*') {
        $result = ( $1 * (($1 * $3) / 100) );
    } elsif ($2 eq '/') {
        $result = ( $1 / (($1 * $3) / 100) );
    }

    my $text = "Result: $result";
    return $text,
    structured_answer => {
        input => [$input],
        operation => 'Calculate',
        result => $result
    };
};

1;


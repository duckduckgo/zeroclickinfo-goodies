package DDG::Goodie::PercentOf;
# ABSTRACT: Operations with percentuals

use strict;
use DDG::Goodie;

zci answer_type => "percent_of";
zci is_cached   => 1;

my $result;

triggers query_nowhitespace => qr/\d{1,3}\%=?$/;

handle query_nowhitespace => sub {

    return unless $_ =~ qr/^(?:\p{Currency_Symbol})*\s*(\d+\.?\d*)\s*(\+|\*|\/|\-)\s*(\d+\.?\d*)\%\s*=?$/;

    my $partRes = ($1 * $3) / 100;

    if ($2 eq '-') {
        $result = ( $1 - ( $partRes ) );
    } elsif ($2 eq '+') {
        $result = ( $1 + ( $partRes ) );
    } elsif ($2 eq '*') {
        $result = ( $partRes );
    } elsif ($2 eq '/') {
        $result = ( $1 * ( 100 / $3 ) );
    }

    my $text = "Result: $result";

    return $text, structured_answer => {
        data => {
            title => $result,
            subtitle => "Calculate: $_"
        },
        templates => {
            group => 'text'
        }
    };
};

1;


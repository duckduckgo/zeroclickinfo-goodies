package DDG::Goodie::Pi;
# ABSTRACT: This Goodie returns 'pi' to a user-specified number of decimal places

use DDG::Goodie;
use utf8;

zci answer_type => "pi";
zci is_cached   => 1;

triggers startend => "pi","π";


my $PI = '3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679'.
        '8214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196'.
        '4428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273'.
        '724587006606315588174881520920962829254091715364367892590360011330530548820466521384146951941511609';

my $PI_max_digits = length($PI);

handle query_raw => sub {

    return unless $_ =~ /^(?:pi|π)?\s*(?:to|first)?\s*(?<decimal>\d+)\s*(?:(?:decimal|digit)s?)?\s*(?:of\s+(?:pi|π))?$/i && 
                        $+{decimal} > 0 && $+{decimal} < $PI_max_digits;

    my $answer = substr $PI, 0, ( $1 + 2 );
    return $answer, structured_answer => {
        data => {
            title => $answer,
            subtitle => "First $+{decimal} digits of Pi" 
        }, 
        templates => {
            group => 'text'
        }
    };

};

1;

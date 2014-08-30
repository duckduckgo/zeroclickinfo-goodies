package DDG::Goodie::RandomNumber;
# ABSTRACT: generate a random number in the requested range.

use DDG::Goodie;

primary_example_queries 'random number between 1 and 12', 'random number';
description 'generates a random number';
name 'RandomNumber';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodies/RandomNumber.pm';
category 'computing_tools';
topics 'cryptography';
attribution github => ['https://github.com/duckduckgo', 'duckduckgo'];

zci answer_type => 'rand';

triggers start => 'rand','random','number';

handle query_lc => sub {
    srand();
    # Random number.
    # q_check (as opposed to q_internal) Allows for decimals.
    if ( $_ =~ /^\!?(?:rand(?:om|)(?: num(?:ber|)|)(?: between|))( [\d\.]+|)(?: and|)( [\d\.]+|)$/i ) {

        # For debugging.
        #     warn qq($1\t$2);

        my $start = $1 || 0;
        my $end   = $2 || 0;

        # Messes up decimals.
        #     $start = int($start) if $start;
        #     $end= int($end) if $end;

        $start = 1000000000 if $start > 1000000000;
        $start = 0          if $start < 0;

        $end = 1000000000 if $end > 1000000000;
        $end = 0          if $end < 0;

        $end = $start if $end && $end < $start;

        # For debugging.
        #     warn qq($start\t$end);

        my $rand = rand;

        if ( $start && !$end ) {
            $rand *= $start;
            $rand = int($rand) + 1;

        }
        elsif ( $start && $end && $start == $end ) {
            $rand = $start;

        }
        elsif ( $start && $end ) {
            $rand *= ( $end - $start + 1 );
            $rand = int($rand) + $start;
        }

        # Add IP for display.
        return $rand ." (random number)";
    }
    return;
};

1;

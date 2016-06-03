package DDG::Goodie::RandomNumber;
# ABSTRACT: generate a random number in the requested range.

use strict;
use DDG::Goodie;

zci answer_type => 'rand';
zci is_cached   => 0;

triggers start => 'rand','random','number';

handle query_lc => sub {
    srand();
    # Random number.
    # q_check (as opposed to q_internal) Allows for decimals.
    
    # checks if only 'rand' or 'random' is entered
    return if ($_ =~ /^\!?(?:rand(?:om|))$/i);
    
    return unless ($_ =~ /^\!?(?:rand(?:om|)(?: num(?:ber|)|)(?: between|))( [\d\.]+|)(?: and|)( [\d\.]+|)$/i);

    my $start = $1 || 0;
    my $end   = $2 || 0;
    
    #makes sure user inputs two numbers
    return if ($start != $end) && ($end == 0);
    #or both numbers are zero
    return if ($start == $end) && ($end == 0);

    $start = 1000000000 if $start > 1000000000;
    $start = 0          if $start < 0;
    $start += 0;

    $end = 1000000000 if $end > 1000000000;
    $end = 0          if $end < 0;
    $end = 1          if !$end;
    $end += 0;

    ($end, $start) = ($start, $end) if ($start > $end);

    my $valDiff = $end - $start;
    
    #returns if both end and start are equal, and end has been changed by the user
    return if ($valDiff == 0) && ($end != 0);

    my $rand = rand;

    if ($start && $end || $valDiff > 1) {
        $rand *= ($valDiff + 1);
        $rand = int($rand) + $start;
    }

    return "$rand (random number)",
      structured_answer => {
        data => {
            title    => $rand,
            subtitle => "Random number between $start - $end"
        },
        templates => {
            group => "text",
        }
      };
};

1;

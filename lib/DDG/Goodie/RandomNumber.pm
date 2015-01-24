package DDG::Goodie::RandomNumber;
# ABSTRACT: generate a random number in the requested range.

use DDG::Goodie;

primary_example_queries 'random number between 1 and 12', 'random number';
description 'generates a random number';
name 'RandomNumber';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodies/RandomNumber.pm';
category 'computing_tools';
topics 'cryptography';
attribution github => ['duckduckgo', 'DuckDuckGo'];

zci answer_type => 'rand';
zci is_cached   => 0;

triggers start => 'rand','random','number';

handle query_lc => sub {
    srand();
    # Random number.
    # q_check (as opposed to q_internal) Allows for decimals.
    return unless ($_ =~ /^\!?(?:rand(?:om|)(?: num(?:ber|)|)(?: between|))( [\d\.]+|)(?: and|)( [\d\.]+|)$/i);

    my $start = $1 || 0;
    my $end   = $2 || 0;

    $start = 1000000000 if $start > 1000000000;
    $start = 0          if $start < 0;
    $start += 0;

    $end = 1000000000 if $end > 1000000000;
    $end = 0          if $end < 0;
    $end = 1          if !$end;
    $end += 0;

    ($end, $start) = ($start, $end) if ($start > $end);

    my $rand = rand;

    if ($start && $end) {
        $rand *= ($end - $start + 1);
        $rand = int($rand) + $start;
    }

    return $rand . " (random number)",
      structured_answer => {
        input     => [$start, $end],
        operation => 'Random number between',
        result    => $rand
      };
};

1;

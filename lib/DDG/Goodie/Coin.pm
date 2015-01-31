package DDG::Goodie::Coin;
# ABSTRACT: flip a (fair) coin.

use DDG::Goodie;

zci is_cached => 0;

triggers start => 'flip', 'toss', 'coin', 'heads';

primary_example_queries 'flip a coin', 'toss a coin';
secondary_example_queries 'flip 4 coins', 'heads or tails';

description 'flip a coin';
name 'Coin Flip';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Coin.pm';
topics 'trivia';
category 'random';
attribution github => [ 'http://github.com/mattlehning', 'mattlehning' ];

handle query_lc => sub {
    my $flips;
    if ($_ =~ /^(heads or tails[ ]?[\?]?)|((flip|toss) a coin)$/) {
        $flips = 1;
    } elsif ($_ =~ /^(?:flip|toss) (\d{0,2}) coins?$/) {
        $flips = $1;
    }

    return unless ($flips);

    # Ensure rand is seeded for each process
    srand();
    my @output;

    my @ht = ("heads", "tails");

    for (1 .. $flips) {
        my $flip = $ht[int rand @ht];
        push @output, $flip;
    }

    return unless @output;

    my $result = join(', ', @output);
    return (
        $result . ' (random)',
        structured_answer => {
            input     => [$flips],
            operation => 'Flip coin',
            result    => $result
        });
};

1;

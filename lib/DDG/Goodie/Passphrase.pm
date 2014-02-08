package DDG::Goodie::Passphrase;

use DDG::Goodie;

triggers start => "passphrase", "pass phrase";

primary_example_queries 'passphrase 3 words', 'pass phrase 4 words';
description 'generate a random passphrase';
name 'Passphrase';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Passphrase.pm';
category 'computing_tools';
topics 'cryptography';

attribution github => ['https://github.com/hunterlang', 'hunterlang'];

# Remove the line endings up front.
my @words = map { chomp $_; $_ } share('words.txt')->slurp;
# When we "floor" our random numbers with `int` we will end up with
# numbers in the range [0,$list_size - 1].. which just so happens
# to be perfect for an index into the array!
my $list_size = scalar @words;

handle remainder => sub {
    # Guard against queries we are unprepared to handle.
    return unless ($_ =~ /^(\d+) words?$/);
    my $word_count = $1;
    # Guard against silly request sizes.
    return unless ($word_count >= 1 && $word_count <= 10);

    my @chosen_words;
    while (scalar @chosen_words < $word_count) {
        # Pick random words from the slurped array until we have enough
        push @chosen_words, $words[int(rand $list_size)];
    }

    # Now stick them together with an indicator as to what it is
    return join ' ', ('random passphrase:', @chosen_words);
};

1;

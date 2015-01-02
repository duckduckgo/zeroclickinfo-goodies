package DDG::Goodie::Passphrase;
# ABSTRACT: Randomly generate a passphrase with the selected number of words.

use DDG::Goodie;

zci answer_type => 'random_passphrase';
zci is_cached   => 0;

primary_example_queries 'random passphrase', '4 word random passphrase', 'pass phrase 3 words';
description 'generate a random passphrase';
name 'Passphrase';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Passphrase.pm';
category 'computing_tools';
topics 'cryptography';

attribution github => ['https://github.com/hunterlang', 'hunterlang'];

triggers startend => 'passphrase', 'pass phrase', 'random passphrase', 'passphrase random', 'random pass phrase', 'pass phrase random';

# Remove the line endings up front.
my @word_list = map { chomp $_; $_ } share('words.txt')->slurp;
# When we "floor" our random numbers with `int` we will end up with
# numbers in the range [0,$list_size - 1].. which just so happens
# to be perfect for an index into the array!
my $list_size = scalar @word_list;

handle query_lc => sub {
    my $query = shift;
    my $word_count;
    $query =~ s/^(?:generate|create)\s+//g;    # Just in case they want to make a command of it.
    if ($query eq 'random passphrase') {
        # If this is our entire (remaining) query, we'll still handle it and
        # set the word count to 4 in honor of correct horse battery staple.
        $word_count = 4;
    } else {
        # Otherwise, we're going to need to poke around for what we need
        $query =~ s/random|pass\s?phrase//g;    # They can stick in these words however they like.
        $query =~ s/\s+/ /g;                    # We may have left whitespace litter
        return unless ($query =~ /^\s*(\d{1,2})\s*words?\s*$/);    # Only answer queries we understand.
        $word_count = $1;                                          # We should have captured the desired length
    }
    # Guard against empty or silly request sizes.
    return unless ($word_count && $word_count <= 10);

    my @chosen_words;
    while (scalar @chosen_words < $word_count) {
        # Pick random words from the slurped array until we have enough
        push @chosen_words, $word_list[int(rand $list_size)];
    }

    my $phrase = join(' ', @chosen_words);
    my $input_string = ($word_count == 1) ? '1 word' : $word_count . ' words';

    # Now stick them together with an indicator as to what it is
    return "random passphrase: $phrase",
      structured_answer => {
        input     => [$input_string],
        operation => 'random passphrase',
        result    => $phrase,
      };
};

1;

package DDG::Goodie::NLetterWords;
# ABSTRACT: find words of a certain length

use strict;
use DDG::Goodie;
use Lingua::EN::Numericalize;

triggers end => "words", "word";

zci is_cached => 0;

handle query_parts => sub {
    # Ensure rand is seeded for each process
    srand();

    my $numericalized = str2nbr($_);
    return unless $numericalized =~ /^(\d{1,50}) (letter|char|character) words?$/;

    my $length = $1;
    my @allwords = share('words.txt')->slurp;
    my @words;

    for (@allwords) {
        chomp($_);
        if (length($_) == $length) { push(@words, $_); }
    }
    return unless @words;

    my @randomwords;
    if (scalar(@words) > 30) {
        while (scalar(@randomwords) < 30) {
            my $rand = int(rand(scalar(@words)));
            if ($words[$rand]) {
                push(@randomwords, $words[$rand]);
                $words[$rand] = 0;
            }
        }
        @words = @randomwords;
    }
    my $output = "Random $length letter words: " . join ', ', @words;
    $output .= ".";

    return $output;
};

1;

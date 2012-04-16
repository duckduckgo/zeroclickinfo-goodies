package DDG::Goodie::NLetterWords;

use DDG::Goodie;

triggers end => "words", "word";
zci is_cached => 1;

handle query_parts => sub {
    return unless /^([0-9]{1,50}) (letter|char|character) words?$/;

    my $length = $1;
    my @allwords = share('words.txt')->slurp;
    my @words;

    foreach (@allwords) {
        chomp($_);
        if (length($_) == $length) { push(@words, $_); }
    }
    return unless scalar(@words) >= 1;

    my $output = "$length letter words: ";

    foreach (@words) {
        $output = $output . $_ . ", ";
    }

    chop($output);
    chop($output);

    return $output;
};

1;

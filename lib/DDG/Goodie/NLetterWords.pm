package DDG::Goodie::NLetterWords;

use DDG::Goodie;

triggers end => "words", "word";
zci is_cached => 0;

handle query_parts => sub {
    return unless /^([0-9]{1,50}) (letter|char|character) words?$/;

    my $length = $1;
    my @allwords = share('words.txt')->slurp;
    my @words;

    foreach (@allwords) {
        chomp($_);
        if (length($_) == $length) { push(@words, $_); }
    }
    return unless @words;

    my @randomwords;
    if (scalar(@words) > 30) {
        while (scalar(@randomwords) < 30) {
            $rand = int(rand(scalar(@words)));
            if ($words[$rand]) {
                push(@randomwords, $words[$rand]);
                $words[$rand] = 0;
            }
        }
        @words = @randomwords;
    }
    my $output = "$length letter words: " . join ', ', @words;

    return $output;
};

1;

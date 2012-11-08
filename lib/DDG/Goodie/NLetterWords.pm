package DDG::Goodie::NLetterWords;

use DDG::Goodie;
use Lingua::EN::Numericalize;

triggers end => "words", "word";

zci is_cached => 0;

primary_example_queries '5 letter words';
secondary_example_queries '12 character word';
description 'find words of a certain length';
name 'NLetterWords';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/NLetterWords.pm';
topics 'words_and_games';
category 'language';
attribution github => ['http://github.com/nospampleasemam', 'nospampleasemam'],
            web => ['http://dylansserver.com/', 'Dylan Lloyd'];

handle query_parts => sub {
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

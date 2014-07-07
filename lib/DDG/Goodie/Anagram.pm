package DDG::Goodie::Anagram;
# ABSTRACT: Returns an anagram based on the word and length of word supplied

use DDG::Goodie;
use List::Util 'shuffle';

triggers start => "anagram", "anagrams";

zci is_cached => 0;
zci answer_type => "anagram";

primary_example_queries "anagram of filter";
secondary_example_queries "anagram filter 5";
description "find the anagram(s) of your query";
name "Anagram";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Anagram.pm";
category "transformations";
topics "words_and_games";

attribution github => ["https://github.com/loganom", 'loganom'],
            github => ["https://github.com/beardlybread", "beardlybread"];

sub calc_freq {
    my ($str, $ref) = @_;
    for (split //, $str) {
        if ($ref->{$_}) {
            $ref->{$_} += 1;
        } else {
            $ref->{$_} = 1;
        }
    }
}

my @words = map { chomp; $_; } share('words')->slurp;

handle remainder => sub {

    my @output;

    s/^of\s+(.+)/$1/i;
    my $len;
    my $word;
    my $full_word = 1;
    my $multiple_words = 0;

    if (/^([a-zA-Z]+)\s*([0-9]+)?\s*$/) {
        $word = $1;
        $word =~ s/\s+$//;
        $len = length $word;
        # If looking for anagrams shorter than the word
        if ($2 && $2 < $len) {
            $len = $2;
            $full_word = 0;
        }
    }
    else {
        $word = $_;
        $multiple_words = 1;
    }

    # Return if there is no word
    return unless $word;

    # Calculate the frequency of the characters of the query
    my %query_freq;
    calc_freq $word, \%query_freq;

    unless ($multiple_words) {
        foreach (@words) {
            if (/^[$word]{$len}$/i) {
                my $w = lc;
                # Skip word if it's the same as the one in the query
                next if $w eq lc $word;

                # Calculate the frequency of the characters of a word from the list
                my %f;
                calc_freq lc, \%f;

                my $is_anagram = 1;
                for (keys %f) {
                    if ($f{$_} > $query_freq{$_}) {
                        # The frequency of the characters in a word must be equal or
                        # less (for shorter anagrams) than that of the same
                        # character in the query
                        $is_anagram = 0;
                        last;
                    }
                }
                push (@output, $_) if $is_anagram;
            }
        }
    }

    unless (@output) {
        # copied verbatim from Randagram.pm
        my @chars = split(//, $word);
        @chars = shuffle(@chars);
        return '"'.$word.'" scrambled: '.join('',@chars);
        # end Randagram.pm
    }

    if($full_word) {
        if(@output) {
            my $ana = "Anagram of \"$word\": ";
            $ana = "Anagrams of \"$word\": " if scalar(@output) > 1;
            return $ana.join(', ', @output);
        }
    }
    return "Anagrams of \"$word\" of size $len: ".join(', ', @output) if @output;
};

1;

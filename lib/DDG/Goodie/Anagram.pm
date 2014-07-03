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

my @words = share('words')->slurp;

handle remainder => sub {

    s/^of\s(.*)/$1/i;
    my $in = $_;
    my $n;
    my @output;
    my $full_word = 1;

    # when our input is "anagram word #"
    if(/^\s*([a-zA-Z]+)\s*([0-9]+)?\s*$/) {
        # convert the word to lowercase
        my $word = lc($1);
        $in = $word;
        $n = length $word;
        # when the # entered is less than the length of the word
        $n = $2 if ($2 && $2 <= $n && $2 > 0);
        # set a control var when we aren't using the full word for the anagram
        $full_word = 0 if $n != length($word);

        # split the word by character, counting frequency of each character
        my %freq;
        for (split //, $word) {
            if ($freq{$_}) {
                $freq{$_} += 1;
            } else {
                $freq{$_} = 1;
            }
        }

        foreach (@words) { # while we have more input
            # if $word has a value and the text input contains characters from our word and is the correct length
            if ($word and /^[$word]{$n}$/i) {
                chomp;
                # skip if the word we see is the original word
                next if lc eq lc($word);
                
                # split the word by character, counting frequency of each character
                # the words here come from the list of words file
                my %f;
                for (split //, lc) {
                    if ($f{$_}) {
                        $f{$_} += 1;
                    } else {
                        $f{$_} = 1;
                    }
                }

                # initialize it_works
                my $it_works = 1;
                for (keys %f) {
                    if ($f{$_} >  $freq{$_}) {
                    # if the frequency of a character in the lowercase word is greater than the original word
                    # then it did not work. We are comparing words to see if they are a valid combination of letters.
                        $it_works = 0;
                        last;
                    }
                }
                # if it works, push the output onto output array
                push(@output, $_) if $it_works;
            }
        }
    }

    # copied verbatim from Randagram.pm
    my @chars = split(//, $in);
    @chars = shuffle(@chars);
    my $garbledAnswer = '"'.$in.'" scrambled: '.join('',@chars);
    # end Randagram.pm

    if($full_word) {
        if(@output) {
            my $ana = "Anagram of \"$in\": ";
            $ana = "Anagrams of \"$in\": " if scalar(@output) > 1;
            return $ana.join(', ', @output);
        }
        return $garbledAnswer if $in;
    }
    return "Anagrams of \"$in\" of size $n: ".join(', ', @output) if @output;
    return $garbledAnswer if $in;

    return;
};

1;

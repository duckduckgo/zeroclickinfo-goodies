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
            github => ["https://github.com/beardlybread", "beardlybread"],
            github => ['https://github.com/gdrooid', 'gdrooid'],
            email  => ['gdrooid@openmailbox.org', 'gdrooid'];

my $css = share('style.css')->slurp;

# Wrap the response in html so that it can be styled with css
sub html_output {
    my ($str, $list) = @_;
    return "<style type='text/css'>$css</style>"
          ."<div class='zci--anagrams'>"
          ."<span class='text--secondary'>$str</span><br/>"
          ."<span class='text--primary'>$list</span>"
          ."</div>";
}

# Calculate the frequency of the characters in a string
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
    s/^"(.*)"$/$1/;
    my $len;
    my $word;
    my $full_word = 1;
    my $multiple_words = 0;

    # If the query is of type "word length", where 'length' is not required
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

    if (lc $word eq 'voldemort' and $full_word) {
        return 'Tom Riddle', html => html_output ("Anagrams of \"$word\"", 'Tom Riddle');
    }

    # Calculate the frequency of the characters of the query
    my %query_freq;
    calc_freq lc $word, \%query_freq;

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

    # If the query is multiple words long or there are no anagrams for its
    # single word, the query will be scrambled, as there is no other possible
    # response
    unless (@output) {
        my $w;
        do {
            my @chars = shuffle split (//, $word);
            $w = join '', @chars;
        } while ($w eq $word);
        return $word, html => html_output('Sorry, we found no anagrams for "'.html_enc($word).'". We scrambled it for you:', $w);
    }

    my $response = join ', ', @output;
    my $output_str = 'Anagrams of '.html_enc($word).'"';
    unless ($full_word) {
        $output_str .= " of length $len";
    }
    return $response, html => html_output($output_str, $response);
};

1;

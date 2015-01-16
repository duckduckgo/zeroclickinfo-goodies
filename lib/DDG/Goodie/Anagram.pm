package DDG::Goodie::Anagram;
# ABSTRACT: Returns an anagram based on the supplied query.

use DDG::Goodie;
use List::Util qw( shuffle );

my @keywords   = qw(anagram anagrams);
my @connectors = qw(of for);
my @commands   = qw(find show);

my @triggers;
foreach my $kw (@keywords) {
    foreach my $con (@connectors) {
        push @triggers, join(' ', $kw, $con);    # anagram for, anagrams of, etc.
        foreach my $com (@commands) {
            push @triggers, join(' ', $com, $kw, $con);    # find anagram of, show anagrams for, etc.
        }
    }
    push @triggers, $kw;                                   # Trigger order appears to matter, so the bare keywords after the others
}

triggers start => @triggers;

zci answer_type => "anagram";
zci is_cached   => 1;

primary_example_queries "anagram of filter";
secondary_example_queries "find anagram for partial men";
description "find the anagram(s) of your query";
name "Anagram";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Anagram.pm";
category "transformations";
topics "words_and_games";

attribution github => ["https://github.com/loganom",      'loganom'],
            github => ["https://github.com/beardlybread", "beardlybread"],
            github => ['https://github.com/gdrooid',      'gdrooid'],
            email  => ['gdrooid@openmailbox.org',         'gdrooid'];

# Calculate the frequency of the characters in a string
sub calc_freq {
    my ($str) = @_;
    my %freqs;

    for (split //, lc $str) {
        $freqs{$_} += 1;
    }

    return \%freqs;
}

my %words = map { chomp; ($_ => undef); } share('words')->slurp;    # This will cache letter frequencies as they get used.

my %easter_eggs = (voldemort => 'Tom Riddle');

handle remainder => sub {

    my $word = $_;
    $word =~ s/^"(.*)"$/$1/;

    return unless $word;    # Need a word.

    # Do some normalization to allow for multi-word matches.
    my $match_word = lc $word;
    $match_word =~ s/[^a-z]//g;
    return unless $match_word;    # Still need a word!

    my $len = length $match_word;

    my @output;
    if (my $egg = $easter_eggs{lc $word}) {
        push @output, $egg;
    }

    unless (@output) {
    my $query_freq = calc_freq($match_word);    # Calculate the letter-freq of the query

    foreach (keys %words) {
        if (/^[$match_word]{$len}$/i) {
            my $w = lc;
            next if $w eq $match_word;          # Skip word if it's the same as the query

            my $f = $words{$w} // calc_freq($w);    # Use cached word letter-freq or calculate new
            $words{$w} //= $f;                      # Cache word letter-freq if we didn't have it.

            my $is_anagram = 1;
            for (keys %$f) {
                if ($f->{$_} != $query_freq->{$_}) {
                    # The letter-freq in a dictionary word must equal that of the query
                    $is_anagram = 0;
                    last;
                }
            }
            push(@output, $_) if $is_anagram;
        }
    }
}

    my ($response, $operation);
    if (@output) {
        $response = join ', ', sort { $a cmp $b } @output;
        $operation = 'Anagrams of';
    } else {
        do {
            $response = join '', shuffle split(//, $word);
        } while (length($word) > 1 && $response eq $word);
        $operation = 'Scrambled letters of';
    }

    return $response,
      structured_answer => {
        input     => [html_enc($word)],
        operation => $operation,
        result    => html_enc($response)
      };
};

1;

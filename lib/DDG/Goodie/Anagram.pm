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

# Wrap the response in html
sub html_output {
    my ($str, $list) = @_;
    return "<div class='zci--anagrams'>" . "<span class='text--secondary'>$str</span><br/>" . "<span class='text--primary'>$list</span>" . "</div>";
}

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

handle remainder => sub {

    my $word = $_;
    $word =~ s/^"(.*)"$/$1/;

    return unless $word;    # Need a word.

    # Do some normalization to allow for multi-word matches.
    my $match_word = lc $word;
    $match_word =~ s/[^a-z]//g;
    return unless $match_word;    # Still need a word!

    my $len = length $match_word;

    if ($match_word eq 'voldemort') {
        return 'Tom Riddle', html => html_output("Anagrams of \"$word\"", 'Tom Riddle');
    }

    my $query_freq = calc_freq($match_word);    # Calculate the letter-freq of the query
    my @output;

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
    # Scramble when no anagram can be found.
    if (!@output) {
        my $w;
        do {
            $w = join '', shuffle split(//, $word);
        } while ($w eq $match_word);
        # Do not cache the scrambled versions since the shuffle is random.
        return $word,
          html      => html_output('Sorry, we found no anagrams for "' . html_enc($word) . '". We scrambled it for you:', html_enc($w)),
          is_cached => 0;
    }

    my $response = join ', ', sort { $a cmp $b } @output;
    my $output_str = 'Anagrams of "' . html_enc($word) . '"';

    return $response, html => html_output($output_str, $response);
};

1;

package DDG::Goodie::Scramble;
# ABSTRACT: Returns an scramble based on the supplied query.

use strict;
use DDG::Goodie;
use List::Util qw( shuffle );

my @keywords   = qw(scramble scrambles);
my @connectors = qw(of for);
my @commands   = qw(find show);

my @triggers;
foreach my $kw (@keywords) {
    foreach my $con (@connectors) {
        push @triggers, join(' ', $kw, $con);    # scramble for, scramble of, etc.
        foreach my $com (@commands) {
            push @triggers, join(' ', $com, $kw, $con);    # find scramble of, show scrambles for, etc.
        }
    }
    push @triggers, $kw;                                   # Trigger order appears to matter, so the bare keywords after the others
}

zci answer_type => 'scramble';
zci is_cached   => 1;

triggers start => @triggers;

primary_example_queries "scramble of filter";
secondary_example_queries "find scramble for partial men";
description "find the scramble(s) of your query";
name "Scramble";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Scramble.pm";
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

# Handle statement
handle remainder => sub {

    my $word = $_;
    $word =~ s/^"(.*)"$/$1/;

    return unless $word;    # Need a word.
    
    my $match_word = lc $word;
    $match_word =~ s/[^a-z]//g;
    return unless $match_word; 

    my $response;
    do {
        $response = join '', shuffle split(//, $match_word);
    } while (length($match_word) > 1 && $response eq $match_word);

    my $operation;
    if ($response) {
        $operation = 'Scramble of';
    } else {
        $response = '';
        $operation = 'There are no scrambles of';
    }

    return $operation . ' ' . $word,
        structured_answer => {

            id => 'scramble',
            name => 'Words & games',

            data => {
              title => $response,
              subtitle => $operation . ' ' . $word
            },

            templates => {
                group => "text"
            }
        };
};

1;

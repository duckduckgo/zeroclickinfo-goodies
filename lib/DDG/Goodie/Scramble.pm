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
zci is_cached   => 0;

triggers start => @triggers;

my $operation = 'Scramble of';            

# Handle statement
handle remainder_lc => sub {

    my $word = $_;
    $word =~ s/^"(.*)"$/$1/;

    return unless $word;    # Need a word.
    
    my $match_word = $word;
    $match_word =~ s/[^a-z]//g;
    return unless $match_word; 

    my $response;
    do {
        $response = join '', shuffle split(//, $match_word);
    } while (length($match_word) > 1 && $response eq $match_word);

    return unless $response;

    return "$operation $word", structured_answer => {
        data => {
            title => $response,
            subtitle => "$operation: $word"
        },
        templates => {
            group => 'text'
        }
    };
};

1;

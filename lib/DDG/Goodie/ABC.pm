package DDG::Goodie::ABC;
# ABSTRACT: Randomly pick one of several different choices delimited by "or"

use DDG::Goodie;
use List::AllUtils qw/none/;

triggers startend => qw/choose pick select/;

zci answer_type => "choice";
zci is_cached   => 0;

primary_example_queries 'choose yes or no';
secondary_example_queries 'choose heads or tails', 'pick this or that or none';
description 'make a random choice';
name 'ABC';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ABC.pm';
category 'random';
topics 'trivia';
attribution cpan    => ['CRZEDPSYC','crazedpsyc'],
            github  => ['kablamo', 'Eric Johnson'];

handle remainder => sub {

    my $query = $_;

    # split the query on whitespace and rm whitespace
    my @words = grep { length } split /\s+/, $query;

    return if query_is_malformed(@words);

    # rm every 'or' from the list
    my @choices = grep { lc $_ ne 'or' } @words;

    my $selection_type = 'Random';
    my $selection;
    # Easter egg. For queries like:
    #   'choose duckduckgo or google or bing or something'
    if (my @duck = grep { / \A (?: duck (?: duckgo )? | ddg ) \z /ix } @choices) {
        $selection_type = 'Non-random';
        $selection      = $duck[0];
    } else {
        # Ensure rand is seeded for each process
        srand();
        # Choose randomly
        $selection = $choices[int rand scalar @choices];
    }

    # Multi-inputs to single input.
    my $last          = pop @choices;
    my $choice_string = join(', ', @choices) . ' or ' . $last;
    my $operation     = $selection_type . ' selection from';

    return $selection . " (" . $selection_type . ")",
      structured_answer => {
        input     => [html_enc($choice_string)],
        operation => $operation,
        result    => html_enc($selection),
      };
};

# The query must look like
#   '<choice> or <choice> or <choice>'
#
# Note this method also prevents choices from being > 1 word long as this
# generates false positives for queries such as
#   'choose from a selection of products like venison, turkey, quail, or fish'
#
# Returns 0 if the query looks good
# Returns 1 if the query looks malformed
sub query_is_malformed {
    my @words = @_;

    return 1 if none { lc $_ eq 'or' } @words;  # ignore queries like 'i choose'
    return 1 if @words <= 1;                    # ignore queries like 'choose or'

    # Ensure every other element of @$words is 'or'
    foreach my $i (1..$#words) {
        next if $i % 2 == 0; # skip even indices
        return 1 if lc $words[$i] ne 'or';
    }

    return 0;
}

1;

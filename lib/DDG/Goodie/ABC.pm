package DDG::Goodie::ABC;
# ABSTRACT: Randomly pick one of several different choices delimited by "or"

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';
use List::AllUtils qw/none/;

triggers startend => qw/choose pick select/;

zci answer_type => "choice";
zci is_cached   => 0;

my $matcher = wi_custom(
    groups => ['imperative', 'prefix', 'postfix'],
    options => {
        command => qr/choose|pick|select/i,
        primary => qr/(\w+\s+or\s+)+\w+/i,
    },
);

handle query_raw => sub {

    my $query = shift;
    my $match = $matcher->full_match($query) or return;

    # split the query on whitespace and rm whitespace
    my @words = grep { length } split /\s+/, $match->{primary};

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
            data => {
                title => html_enc("$selection"),
                subtitle => html_enc("$operation: $choice_string")
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
        };
};

1;

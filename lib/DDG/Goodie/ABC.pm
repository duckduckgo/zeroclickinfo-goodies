package DDG::Goodie::ABC;
# ABSTRACT: Randomly pick one of several different choices delimited by "or"

use DDG::Goodie;

triggers startend => "choose", "pick";

zci answer_type => "rand";

primary_example_queries 'choose yes or no';
secondary_example_queries 'choose heads or tails', 'pick this or that or none';
description 'make a random choice';
name 'ABC';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ABC.pm';
category 'random';
topics 'trivia';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

handle query_parts => sub {
    my @query_parts = @_; # query split on word boundaries; includes triggers
    my $query       = $_; # the entire query

    # Remove the trigger word
    @query_parts = grep { 
        lc $_ ne 'choose' && 
        lc $_ ne 'pick' 
    } @query_parts;

    return if query_is_malformed(\@query_parts, $query);

    my @choices = grep { lc $_ ne 'or' } @query_parts;

    # Easter egg. For queries like:
    #   'choose duckduckgo or google or bing or something'
    if (my @duck = grep { / \A (?: duck (?: duckgo )? | ddg ) \z /ix } @choices) {
        return $duck[0]." (not random)", answer_type => 'egg';
    }

    # Choose randomly
    my $index = int rand scalar @choices;
    return $choices[$index]." (random)";
};

# The query -- minus the trigger word -- must look like 
#   '<choice> or <choice> or <choice>'
#
# Note this method also prevents choices from being > 1 word long as this
# generates false positives for queries such as
#   'choose from a selection of products like venison, turkey, quail, or fish'
#
# Returns 0 if the query looks good
# Returns 1 if the query looks malformed
sub query_is_malformed {
    my $query_parts = shift;
    my $query       = shift;

    return 1 unless $query =~ /or/i; # handle a query like 'i choose'
    return 1 if @$query_parts <= 1;  # handle a query like 'choose or'

    # Ensure every other element of @$query_parts is 'or'
    foreach my $i (1..$#$query_parts) {
        next if $i % 2 == 0; # skip even indices
        return 1 if lc $query_parts->[$i] ne 'or';
    }

    return 0;
}

1;

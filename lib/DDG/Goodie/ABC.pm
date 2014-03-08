package DDG::Goodie::ABC;
# ABSTRACT: Randomly pick one of several different choices delimited by "or"

use DDG::Goodie;

triggers startend => "choose";

zci answer_type => "rand";

primary_example_queries 'choose yes or no';
secondary_example_queries 'choose heads or tails', 'choose this or that or none';
description 'make a random choice';
name 'ABC';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ABC.pm';
category 'random';
topics 'trivia';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

handle query_parts => sub {
    my @parts = @_; # $query split on word boundaries; includes triggers
    my $query = $_; # the entire query

    return unless $query =~ /or/;

    my @choices;
    my @collected_parts;

    foreach my $part (@parts) {
        next if $part eq 'choose';

        if ( lc($part) eq 'or' ) {
            return unless @collected_parts;
            push @choices, join(' ', @collected_parts);
            my $length = @collected_parts;
            return if $length > 1;
            @collected_parts = ();
        } elsif ( $part ) {
            push @collected_parts, $part;
        }
    }

    push @choices, join(' ', @collected_parts) if @choices && @collected_parts;
    return if scalar(@choices) <= 1;
    my $choice = int(rand(@choices));

    if (my @duck = grep { / \A (?: duck (?: duckgo )? | ddg ) \z /ix } @choices) {
        return $duck[0]." (not random)", answer_type => 'egg';
    }

    return $choices[$choice]." (random)";
    return;
};

1;

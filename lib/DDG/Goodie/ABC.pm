package DDG::Goodie::ABC;
# ABSTRACT: Randomly pick one of different choices splitted by "or"

use DDG::Goodie;

triggers any => "or";

zci answer_type => "rand";

handle query_parts => sub { 
    my @choices;
    my @collected_parts;
    while (my $part = shift) {
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

package DDG::Goodie::Constants;
# ABSTRACT: Various Math and Physics constants.
use DDG::Goodie;
use YAML::XS qw( LoadFile );

zci answer_type => "constants";
zci is_cached   => 1;

my $constants = LoadFile(share("constants.yml"));

#loop through constants
foreach my $name (keys %$constants) {
    #obtain to constant with name $keyword
    my $constant = $constants->{$name};

    #add aliases as separate triggers
    foreach my $alias (@{$constant->{'aliases'}}) {
        $constants->{$alias} = $constant;
    }
}

my @triggers = keys %{$constants};
triggers startend => @triggers;

# Handle statement
handle query_lc => sub {
    my $constant = $constants->{$_};
    return unless my $val = $constant->{'value'};

    #fallback to plain answer if html is not present
    my $result = $val->{'html'} ? $val->{'html'} : $val->{'plain'};

    return $result, structured_answer => {
        input     => [],
        operation => $constant->{'name'},
        result    => $result
    };
};

1;

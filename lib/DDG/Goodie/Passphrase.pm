package DDG::Goodie::Passphrase;

use DDG::Goodie;

triggers start => "passphrase";

handle query_parts => sub {
    my $count = @_;
    return unless $count == 3;
    my ( $word_count, $descriptor ) = @_[ 1, 2 ]; 
    return if $word_count < 1;

    my @words = share('words.txt')->slurp;

    my $output = "random passphrase: ";
    for (1..$word_count) {
        my $word = splice @words, (int(rand @words)), 1;
        $output .= "$word ";
    }
    # Remove the trailing space
    chop $output;
    $output =~ s/\n//g;
    return $output;
};

1;

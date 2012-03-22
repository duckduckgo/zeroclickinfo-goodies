package DDG::Goodie::Passphrase;

use DDG::Goodie;
use File::ShareDir::ProjectDistDir;
use IO::All;

triggers start => "passphrase";
zci answer_type => "passphrase";
handle query_parts => sub {
    my $count = @_;
    return unless $count == 3;
    my ( $word_count, $descriptor ) = @_[ 1, 2 ]; 
    return if $word_count < 1;

    my $sharedir = dist_dir('DDG-GoodieBundle-OpenSourceDuckDuckGo');

    my @words = io("$sharedir/passphrase/words.txt")->slurp;

    my $output;
    for (my $count = 0; $count < $word_count; $count++) {
        my $word = splice @words, (int(rand @words)), 1;
        $output .= "$word ";
    }
    # Remove the trailing space
    chop $output;
    $output =~ s/\n//g;
    return "random passphrase: $output";
    return;
};

1;

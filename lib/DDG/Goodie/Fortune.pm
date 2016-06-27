package DDG::Goodie::Fortune;
# ABSTRACT: UNIX fortune quips.

use strict;
use DDG::Goodie;
use Fortune;

triggers startend => 'unix fortune', 'fortune cookie', 'random fortune';

zci answer_type => "fortune";
zci is_cached   => 0;

my $ffile = share('fortunes');
my $fortune_file = Fortune->new($ffile);
$fortune_file->read_header();

handle remainder => sub {
    my $output = $fortune_file->get_random_fortune();
    $output =~ s/\n/ /g;

    return $output, structured_answer => {
        data => {
            title => $output,
            subtitle => "Random Fortune"
        },
        templates => {
            group => 'text'
        }
    };
};

1;

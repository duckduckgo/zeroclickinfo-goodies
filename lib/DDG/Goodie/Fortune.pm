package DDG::Goodie::Fortune;

use DDG::Goodie;
use Fortune;

triggers any => 'unix fortune','unix fortune!','fortune cookie','fortune cookie!';

primary_example_queries 'unix fortune cookie';
name 'Fortune';
description 'get a random phrase from the original fortunes file';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Fortune.pm';
category 'random';
topics 'words_and_games';
attribution github => ['https://github.com/frncscgmz', 'frncscgmz'];

zci is_cached => 0;
zci answer_type => "fortune";

our $ffile = share('fortunes');
our $fortune_file = Fortune->new($ffile);
$fortune_file->read_header();

handle remainder => sub {
    my $output = $fortune_file->get_random_fortune();
    $output =~ s/\n//g;
    return $output;
};

1;

package DDG::Goodie::ChuckNorris;
# ABSTRACT: Fetches a random Chuck Norris fact.

use DDG::Goodie;
use Fortune;

triggers startend => 'chuck norris fact';

primary_example_queries 'chuck norris fact';
name 'Chuck Norris';
description 'get a random chuck norris fact from the fortunes file';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ChuckNorris.pm';
category 'random';
topics 'words_and_games';
attribution github => ['https://github.com/mougias', 'mougias'],
            twitter => 'gcmougias';
            

my $ffile = share('chucknorris');
my $fortune_file = Fortune->new($ffile);
$fortune_file->read_header();

handle remainder => sub {
    my $output = $fortune_file->get_random_fortune();
    $output =~ s/\n/ /g;

    return $output,
      structured_answer => {
        input     => [],
        operation => 'Random Chuck Norris fact',
        result    => $output
      };
};

1;

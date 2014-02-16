package DDG::Goodie::Stopwatch;

use DDG::Goodie;

name 'Stopwatch';
description 'Displays a stopwatch';
primary_example_queries 'stopwatch';
category 'special';
topics 'everyday', 'science', 'words_and_games';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Stopwatch.pm';
attribution twitter => 'mattr555',
            github => ['https://github.com/mattr555/', 'Matt Ramina'];

triggers end => 'stopwatch';

my $html = share('stopwatch.html')->slurp;

handle remainder => sub {
    return 'Stopwatch', html => $html if $_ eq '';
    return;
};

1;

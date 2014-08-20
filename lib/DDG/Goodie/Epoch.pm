package DDG::Goodie::Epoch;
# ABSTRACT: UNIX epoch <-> human time

use DDG::Goodie;
use Date::Calc qw(Today_and_Now Mktime);

zci is_cached => 0;
zci answer_type => "epoch";

primary_example_queries 'epoch';
description 'Time since the Unix epoch';
name 'epoch';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Epoch.pm';
category 'computing_tools';
topics 'sysadmin';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];

triggers query_lc => qr/^epoch$/i;

handle query => sub {
    my ($year, $month, $day, $hour, $min, $sec) = Today_and_Now();
    my $epoch = Mktime($year, $month, $day, $hour, $min, $sec);
    $sec = '0' . $sec  if length($sec) == 1;
    $sec = '0' . $min  if length($min) == 1;
    $sec = '0' . $hour if length($hour) == 1;

    return qq(Unix time: $epoch (for $month/$day/$year $hour:$min:$sec));
};

1;

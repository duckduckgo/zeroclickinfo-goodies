package DDG::Goodie::UnicodeReverse;
# ABSTRACT: returns unicode symbols matching the input

use DDG::Goodie;

triggers startend => "unicode";

zci is_cached => 1;
# zci answer_type => "convert_to_ascii";

attribution
    github => "konr",
    twitter => "konr",
    web => "http://konr.mobi";
primary_example_queries 'unicode black heart';
secondary_example_queries "unicode 2665";

name 'Reverse Unicode Search';
description 'returns unicode symbols matching the input';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UnicodeReverse.pm';
# category 'computing_tools';
# topics 'programming';

handle remainder => sub {
    return unless $_;

    my $pattern = uc join(' ', $_);
    my @matches =
        grep { /^[^;]*;?[^;]*$pattern/ }
    split /\n/,
    share("UnicodeData.txt")->slurp;

    return unless (scalar @matches > 0 && scalar @matches < 15);

    @matches = map {
        (my $code, my $name) = split /;/;
        {symbol => chr hex $code,
         code => $code,
         name => $name};
    } @matches;


    my @results = map {sprintf('%s: %s (U+%s)', @{$_}{qw/name symbol code/})} @matches;

    return join("\n", @results), html => join("<br>", @results);

};

1;

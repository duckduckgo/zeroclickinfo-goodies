package DDG::Goodie::UnicodeFuzzySearch;
# ABSTRACT: returns unicode symbols matching the input

use DDG::Goodie;

triggers startend => "unicode";

zci is_cached => 1;

attribution
    github => "konr",
    twitter => "konr",
    web => "http://konr.mobi";
primary_example_queries 'unicode black heart';
secondary_example_queries "unicode 2665";

name 'Reverse Unicode Search';
description 'returns unicode symbols matching the input';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UnicodeReverse.pm';
category 'computing_info';
topics 'programming';

# UnicodeData.txt is a semicolon-separated file.
# Uploaded file version: 6.3.0, obtained from
# ftp://ftp.unicode.org/Public/6.3.0/ucd/
my @lines = split /\n/, share("UnicodeData.txt")->slurp;

handle remainder => sub {
    return unless $_;
    my $pattern = uc join('.*', $_);

    # 1st column = number ; 2nd column = name. See
    # http://www.unicode.org/draft/ucd/UnicodeData.html
    my @matches;

    # AS FUZZY AS POSSIBLE BUT NOT MORE - It's either (a) number (no ';'
    # before) or (b) part of the name or, when there are way too many
    # matches for the result to be helpful, (c) isolated words.
    @matches = grep { /^[^;]*;?[^;]*$pattern/ } @lines;
    @matches = grep { /\b$pattern\b/ } @lines if (scalar @matches >= 50);

    return unless (scalar @matches > 0 && scalar @matches < 50);

    @matches = map {
        (my $code, my $name) = split /;/;
        {symbol => chr(hex($code)),
         code => $code,
         name => $name};
    } @matches;

    my @results = map {sprintf('%s: %s (U+%s)', @{$_}{qw/name symbol code/})} @matches;

    my $html = scalar @results > 1 ?
		'<ul>' . join('', map {"<li>$_</li>"} @results) . '</ul>' : $results[0];

    return join("\n", @results), html => $html;

};

1;

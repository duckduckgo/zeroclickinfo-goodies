package DDG::Goodie::DuckDuckGo;
# ABSTRACT: Return hard-coded descriptions for DuckDuckGo terms

use DDG::Goodie;

my %data = (
    zeroclickinfo       => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
    zeroclick           => \"zeroclickinfo",
    '0click'            => \"zeroclickinfo",
    '0clickinfo'        => \"zeroclickinfo",
    goodies             => "DuckDuckGo's goodie repository: https://github.com/duckduckgo/zeroclickinfo-goodies",
    spice               => "DuckDuckGo's spice repository: https://github.com/duckduckgo/zeroclickinfo-spice",
    longtail            => "DuckDuckGo's longtail repository: https://github.com/duckduckgo/zeroclickinfo-longtail",
    fathead             => "DuckDuckGo's fathead repository: https://github.com/duckduckgo/zeroclickinfo-fathead",
    goodies_html        => "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-goodies'>goodie repository</a>",
    spice_html          => "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-spice'>spice repository</a>",
    longtail_html       => "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-longtail'>longtail repository</a>",
    fathead_html        => "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-fathead'>fathead repository</a>",
    help                => "DuckDuckGo's help website: http://help.duckduckgo.com/",
    help_html           => "DuckDuckGo's help website: <a href='http://help.duckduckgo.com/'>http://help.duckduckgo.com/</a>",
    roboduck_html       => "DuckDuckGo's official <a href='https://en.wikipedia.org/wiki/IRC_Bot'>IRC bot</a>: <a href='https://github.com/Getty/duckduckgo-roboduck'>https://github.com/Getty/duckduckgo-roboduck</a>",
    roboduck            => "DuckDuckGo's official IRC bot: https://github.com/Getty/duckduckgo-roboduck",
    quackandhack        => "QUACK!",
    duck                => "I am the duck. Dax the duck.",
    duck_html           => "<img src='https://duckduckgo.com/assets/logo_header.v101.png' alt='Dax' /><br/>I am the duck. Dax the duck.",
    dax                => "I am the duck. Dax the duck.",
    dax_html           => "<img src='https://duckduckgo.com/assets/logo_header.v101.png' alt='Dax' /><br/>I am the duck. Dax the duck.",
);

triggers any => keys %data, qw/zero 0/;

zci is_cached => 1;

primary_example_queries 'help';
secondary_example_queries 'Zero-Click Info', 'zeroclick';
description 'take the average of a list of numbers';
name 'DuckDuckGo';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DuckDuckGo.pm';
category 'cheat_sheets';
topics 'everyday';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

handle query_nowhitespace_nodash => sub {
    $_ = lc;
    s/\W//g;
    s/^duckduckgo//i;
    s/repo(?:sitory)?//i;
    return unless exists $data{$_};
    my $answer = $data{$_};
    my $answerhtml = exists $data{"${_}_html"} ? $data{"${_}_html"} : 0;

    if (ref $answer eq 'SCALAR') {
        $answer = $data{$$answer};
        $answerhtml = exists $data{"${answer}_html"} ? $data{"${answer}_html"} : 0;
    }

    return $answer unless $answerhtml;
    return $answer, html => $answerhtml;
};

1;

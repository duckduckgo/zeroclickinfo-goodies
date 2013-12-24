package DDG::Goodie::DuckDuckGo;
# ABSTRACT: Return hard-coded descriptions for DuckDuckGo terms

use DDG::Goodie;

my %data = (
    goodies             => "DuckDuckGo's goodie repository: https://github.com/duckduckgo/zeroclickinfo-goodies",
    spice               => "DuckDuckGo's spice repository: https://github.com/duckduckgo/zeroclickinfo-spice",
    longtail            => "DuckDuckGo's longtail repository: https://github.com/duckduckgo/zeroclickinfo-longtail",
    fathead             => "DuckDuckGo's fathead repository: https://github.com/duckduckgo/zeroclickinfo-fathead",
    goodies_html        => "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-goodies'>goodie repository</a>",
    spice_html          => "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-spice'>spice repository</a>",
    longtail_html       => "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-longtail'>longtail repository</a>",
    fathead_html        => "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-fathead'>fathead repository</a>",
    help                => "DuckDuckGo's help website: http://dukgo.com/help/",
    help_html           => "DuckDuckGo's help website: <a href='http://dukgo.com/help/'>http://dukgo.com/help/</a>",
    roboduck_html       => "DuckDuckGo's official <a href='https://en.wikipedia.org/wiki/IRC_Bot'>IRC bot</a>: <a href='https://github.com/Getty/duckduckgo-roboduck'>https://github.com/Getty/duckduckgo-roboduck</a>",
    roboduck            => "DuckDuckGo's official IRC bot: https://github.com/Getty/duckduckgo-roboduck",
    quackandhack        => "QUACK!",
    duck                => "I am the duck. Dax the duck.",
    duck_html           => "<img src='https://duckduckgo.com/assets/logo_header.v101.png' alt='Dax' /><br/>I am the duck. Dax the duck.",
    dax                 => "I am the duck. Dax the duck.",
    dax_html            => "<img src='https://duckduckgo.com/assets/logo_header.v101.png' alt='Dax' /><br/>I am the duck. Dax the duck.",
    irc                 => "DuckDuckGo's official IRC channel is #duckduckgo on irc.freenode.net",
    irc_html            => "DuckDuckGo's official IRC channel is <a href='http://webchat.freenode.net/?channels=duckduckgo'>#duckduckgo</a> on <a href='http://freenode.net/'>irc.freenode.net</a>",
    remove              => "To remove DuckDuckGo from your browser, take a look at https://duck.co/help/desktop. Let us know why you are leaving: https://duckduckgo.com/feedback",
    remove_html         => qq(To remove DuckDuckGo from your browser, look <a href="https://duck.co/help/desktop">here</a> for your web browser.<br/>In short, check your browser's addons/extensions for DuckDuckGo, then check the search settings.<br/>Please <a href="https://duckduckgo.com/feedback">let us know</a> why you are leaving!),
    removing            => \"remove",
    removing_html       => \"remove_html",
    removal             => \"remove",
    removal_html        => \"remove_html",
    (map {
        $_              => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
        } qw/zeroclickinfo zeroclick 0click 0clickinfo/),
);

triggers any => keys %data, qw/zero 0/;

zci is_cached => 1;

primary_example_queries 'help';
secondary_example_queries 'Zero-Click Info', 'zeroclick';
description 'DuckDuckGo help and quick links';
name 'DuckDuckGo';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DuckDuckGo.pm';
category 'cheat_sheets';
topics 'everyday';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

handle query_lc => sub {
    s/\W//g;
    return if $_ eq 'irc';
    s/^?(?:ddg|duckduckgo)\$?|repo(?:sitory)?//g;
    $_ = ${$data{$_}} if ref $data{$_};
    return unless my $answer = $data{$_};
    return $answer unless exists $data{"${_}_html"};
    return $answer, html => $data{"${_}_html"};
};

1;

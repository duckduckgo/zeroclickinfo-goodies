package DDG::Goodie::LeetSpeak;
# ABSTRACT: Translate the query into leet speak.

use DDG::Goodie;

triggers startend => 'leetspeak', 'l33tsp34k', 'l33t', 'leet speak', 'l33t sp34k';
primary_example_queries 'leetspeak hello world !';
description 'Translate the query into leet speak.';
topics 'geek';
category 'conversions';
name 'LeetSpeak';
code_url 'https://github.com/antoine-vugliano/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LeetSpeak.pm';
attribution github => ['https://github.com/antoine-vugliano', 'antoine-vugliano'],
	web => ['http://antoine.vugliano.free.fr', 'Antoine Vugliano'];


my %alphabet = (
    a => '/-\\',
    b => '|3',
    c => '(',
    d => '|)',
    e => '3',
    f => '|=',
    g => '6',
    h => '|-|',
    i => '1',
    j => '_|',
    k => '|<',
    l => '|_',
    m => '|\/|',
    n => '|\|',
    o => '0',
    p => '|D',
    q => '(,)',
    r => '|2',
    s => '5',
    t => "']['",
    u => '|_|',
    v => '\/',
    w => '\^/',
    x => '><',
    y => "`/",
    z => '2'
);

handle remainder => sub {
    return unless $_;

    my $translation = join '', map {
        exists $alphabet{$_} ?  $alphabet{$_} : $_
    } split //, lc;

    return "Leet Speak: $translation";
};

1;

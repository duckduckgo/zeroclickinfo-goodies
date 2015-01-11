package DDG::Goodie::MarkdownCheatSheet;
# ABSTRACT: Provide a cheatsheet for common Markdown syntax

use DDG::Goodie;

zci answer_type => "markdown_cheat";
zci is_cached   => 1;

name "MarkdownCheatSheet";
description "Markdown cheat sheet";
source "http://daringfireball.net/projects/markdown/syntax";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MarkdownCheatSheet.pm";
category "cheat_sheets";
topics "computing", "geek", "web_design";

primary_example_queries 'markdown help', 'markdown cheat sheet', 'markdown syntax';
secondary_example_queries 'markdown quick reference', 'markdown guide';

triggers startend => (
    'markdown help',
    'markdown cheat sheet',
    'markdown cheatsheet',
    'markdown syntax',
    'markdown guide',
    'markdown quick reference',
    'markdown reference',
);

attribution github  => ["marianosimone", "Mariano Simone"];

my $txt = scalar share('markdown_cheat_sheet.txt')->slurp,
my $html = scalar share('markdown_cheat_sheet.html')->slurp;

handle remainder => sub {
    return
        heading => 'Markdown Cheat Sheet',
        html    => $html,
        answer  => $txt,
};

1;
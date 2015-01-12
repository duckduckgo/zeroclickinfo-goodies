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

my %snippets = (
    'header', '<h1>This is an H1</h1><h2>This is an H2</h2><pre># This is an H1
## This is an H2</pre>',
    'em', '<em>Emphasis</em> or <em>ephasis</em><pre>_emphasis_ or *emphasis*</pre>',
    'strong', '<strong>Strong</strong> or <strong>strong</strong><pre>**strong** or __strong__</pre>',
    'list', '<ul><li>First</li><li>Second</li><li>Third</li></ul><pre>- First
- Second
- Third</pre><ol><li>First</li><li>Second</li><li>Third</li></ol><pre>1. First
2. Second
3. Third</pre>',
    'image', '<img src="http://duckduckgo.com/assets/badges/logo_square.64.png"></img><pre>![Image Alt](http://duckduckgo.com/assets/badges/logo_square.64.png)</pre>',
    'link', '<a href="http://www.duckduckgo.com" title="Example Title">This is an example inline link</a><pre>[This is an example inline link](http://www.duckduckgo.com "Example Title")</pre>',
    'blockquote', '<blockquote>This is the first level of quoting.<blockquote>This is nested blockquote.</blockquote>Back to the first level.</blockquote><pre>> This is the first level of quoting.
>
> > This is nested blockquote.
>
> Back to the first level.</pre>'
);

sub load_synonyms {
    my %mappings = (
        "header", ['h1', 'heading'],
        "em", ['emphasis', 'emphasize'],
        "strong", [],
        "image", ["img", "images", "insert image"],
        "link", ["a", "href", "links"],
        "blockquote", ["quote", "quotation"],
        "list", ["lists", "ordered list", "unordered list", "ul", "ol"]
    );

    my %synonims = ();
    foreach my $key (keys(%mappings)) {
        $synonims{$key} = $key;
        foreach my $v (@{$mappings{$key}}) {
            $synonims{$v} = $key;
        }
    }
    return %synonims;
};

my %synonyms = load_synonyms();

handle remainder => sub {
    return unless $_;
    my $requested = $synonyms{$_};
    return unless $requested;
    return
        heading => 'Markdown Cheat Sheet',
        html    => $snippets{$requested}."<br>See full <a href='http://daringfireball.net/projects/markdown/syntax'>Markdown Syntax Documentation</a>",
        answer  => $snippets{$requested},  # TODO: make simpler txt response
};

1;

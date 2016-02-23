package DDG::Goodie::MarkdownCheatSheet;
# ABSTRACT: Provide a cheatsheet for common Markdown syntax

use strict;
use DDG::Goodie;
use HTML::Entities;

zci answer_type => "markdown_cheat";
zci is_cached   => 1;

triggers startend => (
    'markdown', 'md',
    'markdown help', 'md help',
    'markdown cheat sheet', 'md cheat sheet',
    'markdown cheatsheet', 'md cheatsheet',
    'markdown syntax', 'md syntax',
    'markdown guide', 'md guide',
    'markdown quick reference', 'md quick reference',
    'markdown reference', 'md reference',
);

# Base snippet definitions
my %snippets = (
    'header' => {
        'html' => HTML::Entities::encode_entities('<h1>This is an H1</h1>
<h2>This is an H2</h2>
<h6>This is an H6</h6>'),
        'text' => '# This is an H1
## This is an H2
###### This is an H6'
    },
    'em' => {
        'html' => HTML::Entities::encode_entities('<em>Emphasis</em> or <em>emphasis</em>'),
        'text' => '_emphasis_ or *emphasis*'
    },
    'strong' => {
        'html' => HTML::Entities::encode_entities('<strong>Strong</strong> or <strong>strong</strong>'),
        'text' => '**strong** or __strong__'
    },
    'list' => {
        'html' => HTML::Entities::encode_entities('<ul>
  <li>First</li>
  <li>Second</li>
</ul>
<ol>
  <li>First</li>
  <li>Second</li>
</ol>'),
        'text' => '- First
- Second

1. First
2. Second'
    },
    'image' => {
        'html' => HTML::Entities::encode_entities('<img src="https://duckduckgo.com/assets/badges/logo_square.64.png"/>'),
        'text' => '![Image Alt](https://duckduckgo.com/assets/badges/logo_square.64.png)'
    },
    'link' => {
        'html' => HTML::Entities::encode_entities('<a href="http://www.duckduckgo.com" title="Example Title">This is an example inline link</a>'),
        'text' => '[This is an example inline link](http://www.duckduckgo.com "Example Title")'
    },
    'blockquote' => {
        'html' => HTML::Entities::encode_entities('<blockquote>This is the first level of quoting.<blockquote>This is nested blockquote.</blockquote>Back to the first level.</blockquote>'),
        'text' => '> This is the first level of quoting.
>
> > This is nested blockquote.
>
> Back to the first level.'
    }    
);

my %synonyms = (
    'header', ['h1', 'headers', 'h2', 'h3', 'h4', 'h5', 'h6', 'heading'],
    'em', ['emphasis', 'emphasize', 'italic', 'italics'],
    'strong', ['bold'],
    'image', ['img', 'images', 'insert image'],
    'link', ['a', 'href', 'links'],
    'blockquote', ['quote', 'quotation'],
    'list', ['lists', 'ordered list', 'unordered list', 'ul', 'ol', 'bullet', 'bullets']
);

# Add more mappings for each snippet
foreach my $key (keys(%synonyms)) {
    foreach my $v (@{$synonyms{$key}}) {
        $snippets{$v} = $snippets{$key};
    }
}

my $more_at = '<a href="http://daringfireball.net/projects/markdown/syntax" class="zci__more-at--info"><img src="http://daringfireball.net/favicon.ico" class="zci__more-at__icon"/>More at Daring Fireball</a>';

sub make_html {
    my $element = $_[0];
    return 'Markdown:<pre>'.$snippets{$element}->{'text'}.'</pre>HTML:<pre>'.$snippets{$element}->{'html'}.'</pre>'.$more_at
};

handle remainder => sub {
    return unless $_;
    my $requested = $snippets{$_};
    return unless $requested;
    return
        heading => 'Markdown Cheat Sheet',
        html    => make_html($_),
        answer  => $snippets{$_}->{'text'}
};

1;

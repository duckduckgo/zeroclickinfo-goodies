package DDG::Goodie::MarkdownReference;
# ABSTRACT: Provide a cheatsheet for common Markdown syntax

use strict;
use DDG::Goodie;
use HTML::Entities;

zci answer_type => 'markdown_reference';
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

my %synonyms = (
    'header', ['h1', 'headers', 'h2', 'h3', 'h4', 'h5', 'h6', 'heading'],
    'emphasis', ['em', 'emphasize', 'italic', 'italics'],
    'bold', ['strong'],
    'image', ['img', 'images', 'insert image'],
    'link', ['a', 'href', 'links'],
    'blockquote', ['quote', 'quotation'],
    'list', ['lists', 'ordered list', 'unordered list', 'ul', 'ol', 'bullet', 'bullets']
);

sub get_element_from_alias {
    my $name = shift;
    foreach my $key (keys(%synonyms)) {
        return $key if $name eq $key;
        foreach my $v (@{$synonyms{$key}}) {
            return $key if $v eq $name;
        }
    }
}

my $more_at = '<a href="http://daringfireball.net/projects/markdown/syntax" class="zci__more-at--info"><img src="http://daringfireball.net/favicon.ico" class="zci__more-at__icon"/>More at Daring Fireball</a>';

sub get_element_type {
    my $query = shift;
    return get_element_from_alias $query;
}

sub element_to_subtitle {
    my $element = shift;
    return ucfirst $element;
}

sub get_results {
    my $query = shift;
    my $element_type = get_element_type $query or return;
    my %elements = map { $_ => 0 } (
        'header',
        'list',
        'emphasis',
        'bold',
        'blockquote',
        'image',
        'link',
    );
    $elements{$element_type} = 1;
    my $subtitle = element_to_subtitle $element_type;
    return ($subtitle, \%elements);
}

handle remainder => sub {
    my $query = shift;
    return unless $query;
    my ($subtitle, $elements) = get_results $query or return;
    return $subtitle,
        structured_answer => {
            id   => 'markdown_reference',
            name => 'Answer',
            data => {
                elements => $elements,
                subtitle => $subtitle,
            },
            templates => {
                group   => 'base',
                options => {
                    content => 'DDH.markdown_reference.content',
                },
            },
        };
};

1;

package DDG::Goodie::MarkdownReference;
# ABSTRACT: Provide a cheatsheet for common Markdown syntax

use strict;
use DDG::Goodie;

zci answer_type => 'markdown_reference';
zci is_cached   => 1;

triggers startend => (
    'markdown', 'md',
);

sub build_synonyms {
    my %header_synonyms = map { $_ => 1 } (
        'h1', 'headers', 'h2', 'h3',
        'h4', 'h5', 'h6', 'heading',
    );
    my %emphasis_synonyms = map { $_ => 1 } (
        'em', 'emphasize', 'italic', 'italics',
    );
    my %bold_synonyms = map { $_ => 1 } (
        'strong',
    );
    my %image_synonyms = map { $_ => 1 } (
        'img', 'images', 'insert image',
    );
    my %link_synonyms = map { $_ => 1 } (
        'a', 'href', 'links',
    );
    my %blockquote_synonyms = map { $_ => 1 } (
        'quote', 'quotation',
    );
    my %list_synonyms = map { $_ => 1 } (
        'lists', 'ordered list', 'unordered list',
        'ul', 'ol', 'bullet', 'bullets',
    );
    return (
        'header' => \%header_synonyms,
        'emphasis' => \%emphasis_synonyms,
        'bold' => \%bold_synonyms,
        'image' => \%image_synonyms,
        'link' => \%link_synonyms,
        'blockquote' => \%blockquote_synonyms,
        'list' => \%list_synonyms,
    );
}

sub get_element_from_alias {
    my $name = shift;
    my %synonyms = build_synonyms();
    while (my ($elt_type, $syns) = each %synonyms) {
        return $elt_type if $name eq $elt_type;
        return $elt_type if defined $syns->{$name};
    };
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
                elements     => $elements,
                element_type => $subtitle,
                title        => "Markdown Reference",
            },
            meta => {
                sourceName => 'Daring Fireball',
                sourceUrl  => 'https://daringfireball.net/projects/markdown/syntax',
            },
            templates => {
                group   => 'text',
                options => {
                    subtitle_content => 'DDH.markdown_reference.content',
                    moreAt           => 1,
                },
            },
        };
};

1;

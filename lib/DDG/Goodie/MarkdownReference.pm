package DDG::Goodie::MarkdownReference;
# ABSTRACT: Provide a cheatsheet for common Markdown syntax

use strict;
use DDG::Goodie;
use JSON;

zci answer_type => 'markdown_reference';
zci is_cached   => 1;

triggers startend => (
    'markdown', 'md',
);

my $json = share('synonyms.json')->slurp();
my $synonyms = decode_json($json);

sub get_element_from_alias {
    my $name = shift;
    my %synonyms = %{$synonyms};
    while (my ($elt_type, $syns) = each %synonyms) {
        return $elt_type if $name eq $elt_type;
        return $elt_type if defined $syns->{$name};
    };
}

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

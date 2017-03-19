package DDG::Goodie::CssColors;
# ABSTRACT: List of all the named CSS colors

use DDG::Goodie;

use strict;
use warnings;

use Color::Library;

zci answer_type => 'csscolors';

zci is_cached => 1;

triggers startend => share('triggers.txt')->slurp;

my @color_names = Color::Library::Dictionary::Mozilla->names;

handle remainder => sub {

    # Verify we have no remainder
    return if $_;

    my $query_lc = $req->query_lc;

    my @color_list;

    foreach ( @color_names ) {
        my $color_code = uc Color::Library->Mozilla->color($_);
        push @color_list, { color_name => $_, color_code => "$color_code" };
    }

    my ($title, $subtitle);
    $title = 'CSS ';
    $subtitle = 'List of named CSS ';
    if ( $query_lc =~ /colors/i ) {
        $title .= 'Colors';
        $subtitle .= 'colors';
    } else {
        $title .= 'Colours';
        $subtitle .= 'colours';
    }

    return 'CSS Colors',
        structured_answer => {
            data => {
                title => $title,
                subtitle => $subtitle,
                list => \@color_list
            },
            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.css_colors.content'
                }
            },
            meta => {
                sourceName => 'Mozilla Developer Network',
                sourceUrl => 'https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#Color_keywords'
            }
        };
};

1;

package DDG::Goodie::CssColors;
# ABSTRACT: List of all the named CSS colors

use DDG::Goodie;

use strict;
use warnings;

use Color::Library;
use Data::Dumper;

zci answer_type => 'csscolors';

zci is_cached => 1;

triggers any => 'css colors', 'css3 colors', 'css named colors', 'css3 named colors', 'named css colors', 'named css3 colors', 'css colours', 'css3 colours', 'css named colours', 'css3 named colours', 'named css colours', 'named css3 colours';

handle query_lc => sub {

    my $query_lc = $_;

    my @color_list;
    my $color_names = Color::Library::Dictionary::Mozilla->names;

    foreach my $color_name (@{$color_names}) {
        my (%color_info, $color_info_ref);
        $color_info{'color_name'} = $color_name;
        $color_info{'color_code'} = Color::Library::Dictionary::Mozilla->color($color_name)."";
        print $color_info{'color_code'};
        print Color::Library::Dictionary::Mozilla->color($color_name);
        $color_info_ref = \%color_info;
        push @color_list, $color_info_ref;
    }

    return 'CSS Colors',
        structured_answer => {

            data => {
                title => 'CSS Colors',
                subtitle => 'List of named CSS colors',
                list => \@color_list
            },

            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.css_colors.content'
                }
            }
        };
};

1;

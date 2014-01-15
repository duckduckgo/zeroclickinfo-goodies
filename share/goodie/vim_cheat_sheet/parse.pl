#!/usr/bin/env perl

use strict;
use warnings;

use Web::Scraper;
use Path::Class;
use JSON;


{
    my $data   = parse_html();
    my $tables = $data->{tables};
    my $names  = $data->{names};

    cleanup_tables_data( $tables );
    merge_names_and_tables( $names, $tables );
    my $columns = split_into_two_columns( $tables );
    my $json    = JSON->new->pretty->utf8->encode( $columns );

    file('vimcheat.json')->spew( iomode => '>:encoding(UTF-8)', $json );
}


# Returns a data structure which looks like:
#
# { names  => ['Cursor movement', 'Insert Mode', ...],
#   tables => [
#     {rows => [ {help => 'h - move left'}, {help => 'j - move down'}, ... ]},
#     {rows => [ {help => 'i - start insert mode'}, ...                    ]},
#     ...
#   ],
# }
#
sub parse_html {
    my $scraper = scraper {
        process "h2", "names[]" => 'TEXT';
        process "ul", "tables[]" => scraper {
            process "li", "rows[]" => scraper {
                process "li", "help" => 'TEXT';
            };
        };
    };

    my $string = scalar file('download/vimcheat.html')
        ->slurp(iomode => '<:encoding(UTF-8)');

    return $scraper->scrape($string);
}

# Alters each $table->{rows} so it looks like this:
#
#  [ {cmds => ['h'], help => 'move left'}, 
#    {cmds => ['j'], help => 'move down'}, 
#    ... 
#  ]
#
sub cleanup_tables_data {
    my $tables = shift;

    foreach my $table (@$tables) {
        foreach my $row (@{ $table->{rows} }) {

            # $row->{help} looks like: "gt or :tabnext or :tabn - move to next tab"

            # The code below puts everything to the right of the ' - ' into
            # $row->{help} and everything to the left goes into $row->{cmds}

            my ($left, $right) = split / - /, $row->{help};
            my @cmds = split / or /, $left;

            $row->{cmds} = \@cmds;
            $row->{help} = $right;

        }
    }
}

# Alters $tables so it looks like this:
#
# [
#   {name => 'Cursor movement', rows => [...]},
#   {name => 'Insert Mode',     rows => [...]},
#   ...
# ]
#
sub merge_names_and_tables {
    my ($names, $tables) = @_;

    foreach my $table (@$tables) {
        $table->{name} = shift @$names;
    }
}

# Returns a data structure which looks like:
#
# [ $tables[0],   $tables[1],       ... ],
# [ $tables[x/2], $tables[x/2 + 1], ... ],
#
# Where x is the size of the array @tables
#
sub split_into_two_columns {
    my $tables = shift;
    my $length = scalar @$tables;
    my $half = int( $length / 2 );
    my @column1 = @$tables[0..$half];
    my @column2 = @$tables[$half .. $length - 1];
    return [ \@column1, \@column2 ];

}


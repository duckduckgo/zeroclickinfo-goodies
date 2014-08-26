#!/usr/bin/env perl

use strict;
use warnings;

use Path::Class;
use Text::Xslate;
use Web::Scraper;


{
    my $src_file  = file('download/vimcheat.html'); # in
    my $html_file = file('vim_cheat_sheet.html');   # out
    my $text_file = file('vim_cheat_sheet.txt');    # out

    my $data = parse_html($src_file);

    generate_html_cheat_sheet($data => $html_file);
    generate_text_cheat_sheet($data => $text_file);
}


# Returns a data structure which looks like:
#
# [
#    [  # column 1
#       {  name => 'first table name',
#          rows => [ {cmds => ['h'], help => 'move left'}, ... ]
#       },
#       {  name => 'second table name',
#          rows => [ {cmds => ['i'], help => 'start insert mode'}, ... ]
#       },
#       ...
#    ],
#    [  # column 2
#       ...
#    ]
# ]
#
sub parse_html {
    my $file = shift;

    my $scraper = scraper {
        process "h2", "names[]"  => 'TEXT';
        process "ul", "tables[]" => scraper {
            process "li", "rows[]" => scraper {
                process "li", "help" => 'TEXT';
            };
        };
    };

    my $string = $file->slurp(iomode => '<:encoding(UTF-8)');
    my $data   = $scraper->scrape($string);

    my $tables = $data->{tables};
    my $names  = $data->{names};

    cleanup_tables_data( $tables );
    merge_names_and_tables( $names, $tables );
    return split_into_two_columns( $tables );
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

            # remove spaces around +
            # this is to make commands like 'Ctrl + v' less wide
            $row->{help} =~ s/ \+ /+/g; 

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
# [ {name => 'Cursor movement', rows => [...]},
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
    my $half   = int( $length / 2 );

    my @column1 = @$tables[0 .. $half - 1];
    my @column2 = @$tables[$half .. $length - 1];

    return [ \@column1, \@column2 ];
}

# Generates an html answer from $data and saves the answer to $file.
sub generate_html_cheat_sheet {
    my $data = shift;
    my $file = shift;

    my $css  = file("vim_cheat_sheet.css")->slurp;
    my $html = "<style type='text/css'>\n\n$css\n</style>\n\n";

    my $vars  = { columns => $data };
    $html    .= Text::Xslate->new()->render('template.tx', $vars);

    $file->spew(iomode => '>:encoding(UTF-8)', $html);
}

# Generates a plain text answer from $data and saves the answer to $file.
sub generate_text_cheat_sheet {
    my $data = shift;
    my $file = shift;
    my $answer = '';

    foreach my $tables (@$data) {
        foreach my $table (@$tables) {
            $answer .= $table->{name} . "\n\n";
            foreach my $row (@{ $table->{rows} }) {
                my $cmds = $row->{cmds};
                my $left = join ' or ', @$cmds;

                $answer .= sprintf('%-35s ', $left);
                $answer .= $row->{help};
                $answer .= "\n";
            }
            $answer .= "\n";
        }
        $answer .= "\n";
    }

    $file->spew(iomode => '>:encoding(UTF-8)', $answer);
}


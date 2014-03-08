#!/usr/bin/env perl

use strict;
use warnings;

use Path::Class;
use Text::Xslate;
use YAML qw/LoadFile/;


{
    foreach my $type (qw/emacs vi/) {
        print "Generating $type readline cheat sheet\n";

        my $src_file  = file("download/${type}.yml");     # in
        my $html_file = file("${type}_cheat_sheet.html"); # out
        my $text_file = file("${type}_cheat_sheet.txt");  # out

        my $data = LoadFile($src_file);

        generate_html_cheat_sheet($data => $html_file, $type);
        generate_text_cheat_sheet($data => $text_file, $type);
    }
}

# Generates an html answer from $data and saves the answer to $file.
sub generate_html_cheat_sheet {
    my $data = shift;
    my $file = shift;
    my $type = shift;

    my $css  = file("style.css")->slurp;
    my $html = "<style type='text/css'>\n\n$css\n</style>\n\n";

    my $vars  = { columns => $data, type => $type };
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


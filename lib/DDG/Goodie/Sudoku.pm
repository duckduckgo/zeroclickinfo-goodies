package DDG::Goodie::Sudoku;
# ABSTRACT: Show a small sudoku puzzle.

use DDG::Goodie;
use Games::Sudoku::Component;

use strict;
use warnings;

triggers startend => 'sudoku';

zci is_cached => 0;
zci answer_type => "sudoku";

primary_example_queries 'sudoku easy';
description 'show a little sudoku you can play in the browser';

name 'Sudoku';
category 'random';
attribution github => ['DrDub', 'Pablo Duboue'],
    web => ['http://duboue.net/', 'Pablo Duboue'],
    github => ['https://github.com/mintsoft', 'Rob Emery'],
    github => ['https://github.com/Mailkov', 'Melchiorre Alastra'];

handle remainder => sub {

    return unless /^(easy|average|medium|hard|random|generate|play|)$/;

    my($difficulty) = m/^(average|medium|hard)?$/;
    $difficulty = "easy" unless ($difficulty);

    my $sudoku = Games::Sudoku::Component->new(size => 9);

    #proportion of the grid to be blank
    my $blanks = 0.25;
    $blanks = 0.75 if ($difficulty eq "hard");
    $blanks = 0.5 if ($difficulty eq "medium" || $difficulty eq "average");

    $sudoku->generate(blanks => (9 ** 2) * $blanks);
    my $str_output = $sudoku->as_string();

    my @sudoku_lines = split(/\n/, $str_output);

    my @sudoku_tables;
    
    my @number;
    for my $line (@sudoku_lines) {
        $line =~ s/0//g;
        @number = split(/ /, $line);
        while (scalar(@number) < 9) {
            push @number, "";
        }
        push @sudoku_tables, [@number];
    }    
    
    #switch 0 to more sensible placeholders
    $str_output =~ s/0/_/g;
    
    return $str_output,
    structured_answer => {
        id => 'sudoku',
        name => 'Games',
        data => {
            title => 'Sudoku',
            subtitle => 'Difficulty: ' . $difficulty,
            sudoku_tables => \@sudoku_tables
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.sudoku.content'
            }
        }
    };
};

1;

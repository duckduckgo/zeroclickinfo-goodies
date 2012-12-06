package DDG::Goodie::Sudoku;
# ABSTRACT: Show a small sudoku puzzle.

use DDG::Goodie;

use Games::Sudoku::Component;

triggers start => 'sudoku';
triggers start => 'i\'m bored';
triggers start => 'i am bored';
triggers start => 'this is boring';

zci is_cached => 0;
zci answer_type => "sudoku";

primary_example_queries 'sudoku 4x4 easy';
secondary_example_queries 'I am bored';
description 'show a little sudoku you can play in the browser';
name 'Sudoku';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Sudoku.pm';
category 'random';
attribution github => ['https://github.com/DrDub', 'DrDub'],
            web => ['http://duboue.net/', 'Pablo Duboue'];

handle query => sub {
    return unless /^sudoku|(i(\'m)|( am) bored)|(this is boring)/i;
    my($number, undef, $difficulty) = m/^sudoku ([49])?(x[49])?\s*((easy)|(medium)|(hard))?/;
    $number = 4 unless ($number);              # fast
    $difficulty = "easy" unless ($difficulty); # and easy

    if(m/(i(\'m)|( am) bored)|(this is boring)/i){
        # prepare to be unbored!
        $number = 9; 
        $difficulty = "hard"; 
    }
    
    my $sudoku = Games::Sudoku::Component->new(size=>$number);
    my $blanks = 0.25; # can't be easier
    if ($difficulty eq "hard") {
        $blanks = 0.75; # now we're talking
    }elsif($difficulty eq "medium"){
        $blanks = 0.5; # fun games are fun
    }

    $sudoku->generate(blanks => ($number ** 2) * $blanks);

    my$as_str = $sudoku->as_string(separator=>" ", linebreak=>"\n");
    $as_str =~ s/0/ /g;

    my$as_html = $sudoku->as_HTML(border=>1, color_by_block=>1);
    if ($blanks > 0.25){
        $as_html =~ s/0/\<input size=\"1\">\<\/input>/g;
    }else{
        $as_html =~ s/0/ /g;
    }

    return $as_str, html => '<style type="text/css">td.odd { background-color: lightgray } table.sudoku { border-spacing: 0px; border-collapse: collapse; }</style>'.$as_html;
};

1;

    

    



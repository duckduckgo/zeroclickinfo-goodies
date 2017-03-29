package DDG::Goodie::Sudoku;
# ABSTRACT: Show a small sudoku puzzle.

use DDG::Goodie;
use Games::Sudoku::Component;

use strict;
use warnings;

triggers startend => 'sudoku';

zci is_cached => 0;
zci answer_type => "sudoku";

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
  # my $str_output = "[";
  my $str_output = $sudoku->as_string();
  # $str_output .= "]";
  $str_output =~ s/\R/,/g;
  $str_output =~ s/\s/,/g;
  
  # return $str_output, html => $html_table;
  return $str_output, 
  structured_answer => {
    data => {
      title => 'Sudoku',
      sudoku_values => $sudoku # works if I return $sudoku->as_string();
    },
    templates => {
      group => 'media',
      options => {
        content => 'DDH.sudoku.content'
      }
    }
  };
};

1;

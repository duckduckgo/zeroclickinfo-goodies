package DDG::Goodie::PaleoIngredientCheck;
# ABSTRACT: Indicates if a given food item is known to be safe or unsafe on the paleo diet.

use DDG::Goodie;
use List::MoreUtils 'any';
use YAML::XS qw(Load);

triggers any => 'paleo', 'paleo friendly', 'paleo diet', 'paleo friendly?', 'paleo?';

zci answer_type => "paleo_ingredient_check";
zci is_cached   => 1;

name "PaleoIngredientCheck";
description "Indicates if a given food item is known to be safe or unsafe on the paleo diet.";
primary_example_queries "are apples paleo friendly", "Is dairy allowed on the paleo diet?";
secondary_example_queries "Is sugar paleo friendly?", "beans paleo safe";
category "food";
topics "food_and_drink";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PaleoIngredientCheck.pm";
attribution github => ["murz", "Mike Murray"];
attribution github => ["javathunderman", "Thomas Denizou"];
attribution twitter => ["javathunderman", "Thomas Denizou"];

my $safeornot = Load(scalar share('safeornot.yml')->slurp);
handle remainder => sub {
my ($query,$ingredient,$safe); #Define vars

    s/^paleo friendly (diet)?//g; # strip common words
    $query = $_;


return unless $ingredient;
$safe= $safeornot->{$ingredient}
return unless $safe;
if ($safe eq "0") {$safe = $ingredient." is safe";}
else if ($safe eq "1") {$safe= $ingredient."is not safe";}
return $ingredient . " is $safe",
      structured_answer => {
        input     => [$ingredient],
        operation => 'paleo',
        result    => $safe
      };

};

1;
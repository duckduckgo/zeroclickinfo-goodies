package DDG::Goodie::PaleoIngredientCheck;
# ABSTRACT: Indicates if a given food item is known to be safe or unsafe on the paleo diet.

use DDG::Goodie;
use List::MoreUtils 'any';

triggers startend => share('triggers.txt')->slurp;

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

my @safe_keywords = share('safe.txt')->slurp;
my @unsafe_keywords = share('unsafe.txt')->slurp;

handle remainder => sub {

    my $item = lc($_);

    # Remove any preceding "is" or "are" text from the query.
    $item =~ s/^(is|are)[\W]+//;

    my $is_plural = substr($item, -1) eq "s";
    my($result);

    if (any {/$item/} @safe_keywords) {
        
        $result= "Yes";
    } elsif (any {/$item/} @unsafe_keywords) {
        $result= "No"
    } elsif (!$is_plural) {
        # If nothing was found and the query was not plural, try it pluralized.
        if (any {/$item."s"/} @safe_keywords) {
            $result = "Yes";
        } elsif (any {/$item."s"/} @unsafe_keywords) {
            $result = "No";
        }
    } elsif ($is_plural) {
        # If nothing was found and the query was plural, try it depluralized.
        my $depluralized = substr($item, 0, -1);
        if (any {/$depluralized/} @safe_keywords) {
            $result = "Yes";
        } elsif (any {/$depluralized/} @unsafe_keywords) {
            $result = "No";
        }
    }
    #return unless any {/$item/} @safe_keywords
return $result;

structured_answer => {
    input     => "Is $item paleo-diet friendly", # or just the original query
    operation => "",
    result    => $result, # this could possibly be shortened to a simple "Yes" or "No"
};
};

1;
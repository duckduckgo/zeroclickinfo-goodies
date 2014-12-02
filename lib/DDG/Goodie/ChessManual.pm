package DDG::Goodie::ChessManual;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "chess_manual";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "ChessManual";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ChessManual.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers any => "pawn", "pawn chess", "pawn chess piece";

# Handle statement
handle remainder => sub {
     return if $_;
     return "P: The pawn (♙♟) is the most numerous piece in the game of chess, and in most circumstances, also the weakest. Unlike other pieces, the pawn does not capture in the same direction as it otherwise moves. A pawn captures diagonally, one square forward and to the left or right.";
};


1;

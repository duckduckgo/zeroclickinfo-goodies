package DDG::Goodie::FenViewer;
# ABSTRACT: This instant answer parses a chess position in the Forsyth-Edwards notation, 
# and draws a chessboard on screen representing that position. The current version only 
# parses the current board position (the first field in the FEN format) and does not check
# that the given position is actually legal.

use DDG::Goodie;
use strict;
use Try::Tiny;
with 'DDG::GoodieRole::Chess';

zci answer_type => "fen_viewer";
zci is_cached   => 1;

name "FenViewer";
description "This instant answer parses a chess position in the Forsyth-Edwards notation, and draws a chessboard on screen representing that position.";
primary_example_queries "FEN rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", "fen rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1";

category "entertainment";
topics "gaming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FENViewer.pm";
attribution github => ["rouzbeh", "Ali Neishabouri"],
            twitter => "Rou7_beh";

triggers start => "fen";

handle remainder => sub {
    my ($query) = $_;
    return unless $query;
    my (@pos) = parse_position($query);
    if ($#pos != 63) {
        # The format is wrong, e.g. space in the middle
        return;
    }
    my ($html_out) = '';
    my ($ascii_out) = '';
    try {
        $html_out = draw_chessboard_html(@pos);
        $ascii_out = draw_chessboard_ascii(@pos);
    }
    catch {
        # The format is wrong, e.g. non-existent piece
        return;
    };
    return $ascii_out, html => $html_out;
};

1;

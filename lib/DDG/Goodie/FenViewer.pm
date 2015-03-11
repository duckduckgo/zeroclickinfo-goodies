package DDG::Goodie::FenViewer;
# ABSTRACT: This instant answer parses a chess position in the Forsyth–Edwards notation, 
# and draws a chessboard on screen representing that position. The current version only 
# parses the current board position (the first field in the FEN format) and does not check
# that the given position is actually legal.

use DDG::Goodie;
use Scalar::Util qw(looks_like_number);
use Try::Tiny;

zci answer_type => "fen_viewer";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "FenViewer";
description "This instant answer parses a chess position in the Forsyth–Edwards notation, and draws a chessboard on screen representing that position.";
    primary_example_queries "FEN rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", "fen rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1";

category "entertainment";
topics "gaming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FENViewer.pm";
attribution github => ["rouzbeh", "Ali Neishabouri"],
            twitter => "Rou7_beh";

# Triggers
triggers start => "fen";

# Parse the FEN string into an array of length 64.
sub parse_position {
    my ($i) = 0;
    my ($inp_query) = @_;
    my (@cases) = ();
    my (@fen_fields) = split(' ', $inp_query);
    my ($position) = $fen_fields[0];
    for (my $char = 0 ; $char < length($position) ; $char++ ) {
        my $fenchar = substr($position, $char, 1);
        if (looks_like_number($fenchar)) {
            for ($i = 0; $i < $fenchar; $i++){
                push(@cases, 'e');
            }
        }
        elsif ($fenchar ne '/') {
            push(@cases, $fenchar);
        }
    }
    return @cases;
}

# Generate a chessboard as a HTML table.
sub draw_chessboard {
    my (@position) = @_;
    my ($i) = 0;
    my ($j) = 0;
    my ($counter) = 0;
    my (@arr) = ("A".."Z");
    my (%class_dict) = (
        'r' => 'black rook',
        'n' => 'black knight',
        'b' => 'black bishop',
        'q' => 'black queen',
        'k' => 'black king',
        'p' => 'black pawn',
        'e' => 'empty',
        'R' => 'white rook',
        'N' => 'white knight',
        'B' => 'white bishop',
        'Q' => 'white queen',
        'K' => 'white king',
        'P' => 'white pawn',
    );
    
    my (%unicode_dict) = (
        'r' => '&#9820;',
        'n' => '&#9822;',
        'b' => '&#9821;',
        'q' => '&#9819;',
        'k' => '&#9818;',
        'p' => '&#9823;',
        'e' => '',
        'R' => '&#9814;',
        'N' => '&#9816;',
        'B' => '&#9815;',
        'Q' => '&#9813;',
        'K' => '&#9812;',
        'P' => '&#9817;',
        );
    
    my ($html_chessboard) = '<div class="zci--fenviewer"><table class="chess_board" cellpadding="0" cellspacing="0">';
    for ($i = 0; $i < 8; $i++){
        # Rows
        $html_chessboard .= '<tr>';
        for ($j = 0; $j < 8; $j++){
            # Columns
            $html_chessboard .= '<td id="'.$arr[$j].(8-$i).'">';
            $html_chessboard .= '<a href="#" class="'.$class_dict{$position[$counter]};
            $html_chessboard .= '">'.$unicode_dict{$position[$counter]}.'</a>';
            $html_chessboard .= '</td>';
            $counter++;
        }
        $html_chessboard .= '</tr>';
    }
    $html_chessboard .= '</table></div>';
    return $html_chessboard;
}

# Handle statement
handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;
    my ($query) = $_;
    return unless $query;
    my (@pos) = parse_position($query);
    my ($html_out) = '';
    try {
        $html_out = draw_chessboard(@pos);
    }
    catch {
        return;
    };
    return 'Chessboard', html => $html_out;
};

1;

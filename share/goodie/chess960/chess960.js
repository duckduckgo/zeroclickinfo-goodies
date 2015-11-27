DDH.chess960 = DDH.chess960 || {};

(function(DDH) {
    "use strict";
    DDH.chess960.build = function(ops) {
        // Global Variables Declaration
        var $tempChessboard;
        var squares, started;
        var scheme = [];
        var letters = ["H", "G", "F", "E", "D", "C", "B", "A"];
        var position = ops.data.position;
    
        for (var i = 0; i<position.length; i++) {
            scheme[i] = position.substring(i, i + 1);
        }

        // This function creates and prints on page chess board
        function start() {
            var nsquare = 63;
            var squaresid = combination();
            squares.each(function(index) {
                $(this).attr("id", squaresid[nsquare--]);
            });
            drawPawns();
            drawPieces();
        }
    
        // This function creates the names of the squares e.g "A1" "B1" ...
        function combination() {
            var combinations = [];
            for (var i = 1; i < 9; i++) {
                for (var t = 0; t < letters.length; t++) {
                    combinations[(i - 1) * 8 + t] = letters[t] + i;
                }    
            }    
            return combinations;
        }
    
        function drawPawns() {
            for (var i = 0; i < 8; i++) {
                $("#" + letters[i] + "7 span").html("&#9823;"); 
                $("#" + letters[i] + "2 span").html("&#9817;");
            }
        }
    
        function drawPieces() {
            var codepiece;
            for (var i = 0; i < 8; i++) {
                codepiece = getCodePiece(i);
                $("#" + letters[i] + "8 span").html("&#98" + (codepiece + 6) + ";"); 
                $("#" + letters[i] + "1 span").html("&#98" + codepiece + ";");
            }
        }
    
        function getCodePiece(i) {
            var code;
            switch (scheme[i]) { 
                case "R": 
                    code = 14; 
                break; 
                case "N": 
                    code = 16; 
                break; 
                case "B": 
                    code = 15; 
                break;             
                case "Q": 
                    code = 13; 
                break;
                case "K": 
                    code = 12; 
                break;                               
            } 
            return code;
        }
    
        return {
            onShow: function() {

                //'started' is a boolean variable used in order to avoid the
                //duplication of the chess area. Moving around the DDG tabs the
                //'onShow' function is executed over and over. This simple solution
                //prevents the problem
                if (!started) {
                    started = true;

                    $tempChessboard = $('#chess_board');
                    squares = $('td.square');
                
                    start();

                }
            }
        };
    };
})(DDH);

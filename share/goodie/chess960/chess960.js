DDH.chess960 = DDH.chess960 || {};

(function(DDH) {
    "use strict";
    
    // Global Variables Declaration
    var squares, started;
    var scheme = [];
    var letters = ["H", "G", "F", "E", "D", "C", "B", "A"];
    var obj = { "R" : 14, "N" : 16, "B" : 15, "Q" : 13, "K" : 12 }; 
    
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
            codepiece = obj[ scheme[i] ];
            $("#" + letters[i] + "8 span").html("&#98" + (codepiece + 6) + ";"); 
            $("#" + letters[i] + "1 span").html("&#98" + codepiece + ";");
        }
    }
    
    DDH.chess960.build = function(ops) {
    
        var position = ops.data.position;
        
        for (var i = 0; i < position.length; i++) {
            scheme[7 - i] = position.substring(i, i + 1);
        }
    
        return {
            onShow: function() {

                //'started' is a boolean variable used in order to avoid the
                //duplication of the chess area. Moving around the DDG tabs the
                //'onShow' function is executed over and over. This simple solution
                //prevents the problem
                if (!started) {
                    started = true;

                    squares = $('td.square');
                
                    start();

                }
            }
        };
    };
})(DDH);

DDH.sudoku = DDH.sudoku || {}; // create the namespace in case it doesn't exist

DDH.sudoku.build = function(ops) {
    var started;
    var levels = { "simple" : 1, "easy" : 2, "average" : 3, "medium" : 3, "hard" : 4 }; 
    var level = levels[ops.data.level];
    var cells =[];
    
    function start() {
        var nsquare = 0;
        $.getScript('https://raw.githubusercontent.com/Mailkov/SudokuJSMA/master/sudokujsma2.js')
        .done(function(){
            cells = getSudoku(level);
            squares.each(function(index) {
                $(this).attr("id", "C"+nsquare);
                if (cells[nsquare] != 0) {
                    $("#C"+nsquare+" span").html(cells[nsquare++]);
                } else {
                    $("#C"+(nsquare++)+" span").html("<input maxlength='1'/>");
                }
            });
        })  
        .fail(function() {
            var p=0;
        });       
     }
     
    return {
        onShow: function() {
                if (!started) {
                    started = true;
                    squares = $('td.square');               
                    start();
                }
            }
    };
}; 
    
    
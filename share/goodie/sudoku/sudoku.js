DDH.sudoku = DDH.sudoku || {}; // create the namespace in case it doesn't exist

DDH.sudoku.build = function(ops) {

    var cells =[];
    $.getScript('https://github.com/Mailkov/SudokuJSMA/blob/master/sudokujsma2.js')
    .done(function(){
        cells = getSudoku(1);
        var t=0;
    })  
    .fail(function() {
        var p=0;
    });
    
    return {
        // Specify any frontend display properties here
    };

}; 
    
    
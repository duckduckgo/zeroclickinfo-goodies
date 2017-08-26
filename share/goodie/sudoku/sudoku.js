DDH.sudoku = DDH.sudoku || {}; // create the namespace in case it doesn't exist

DDH.sudoku.build = function(ops) {
    var started;
    var levels = { "simple" : 1, "easy" : 2, "average" : 3, "medium" : 3, "hard" : 4 }; 
    var level = levels[ops.data.level];
    var cells = [];
    var controlcells= [];
    
    function start() {
        var nsquare = 0;
        $.getScript('https://rawgit.com/Mailkov/SudokuJSMA/master/sudokujsma2.js')
        .done(function(){
            cells = getSudoku(level);
            squares.each(function(index) {
                $(this).attr("id", "C"+nsquare);
                if (cells[nsquare] != 0) {
                    $("#C"+nsquare+" span").html(cells[nsquare++]);
                } else {
                    $("#C"+(nsquare)+" span").html("<input class='inputsquare' maxlength='1' id='I"+(nsquare++)+"'/>");//"' onblur='verifyValue("+(nsquare++)+")'/>");
                }
            });
            
            inputs = $('input.inputsquare');
            inputs.each(function(index) {
                $(this).on("blur", function () {
                    verifyValue($(this));
                });
            });
            
            controlcells = initialcells;
        })  
        .fail(function() {
            var p=0;
        });       
     }
    
     function verifyValue(input){
         var value = input.val();
         var numcell = input.attr("id").substring(1);
         if (value != "" && value != controlcells[numcell]) {
             input.css("background-color", "red");
             input.css("color", "white");
         } else {
             input.css("background-color", "white");
             input.css("color", "black");
         }
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
    
    
DDH.sudoku = DDH.sudoku || {};
var sudoku_values;
DDH.sudoku.build = function(ops) {
  sudoku_values = ops.data.sudoku_values;
};

Handlebars.registerHelper("moduloIf", function(index_count,mod,block) {
  if(parseInt(index_count)%(mod)=== 0)
    return block.fn(this);
});

Handlebars.registerHelper('ifBlank', function(value) {
  if(value==0)
    return new Handlebars.SafeString("<input maxlength='1'/>")
  else
    return this;
});

DDH.geometry = DDH.geometry || {};
(function(DDH) {
    "use strict";

    DDH.geometry.build = function(ops) {

        return {

            // Function that executes after template content is displayed
            onShow: function() {
                var formulaSelector = '#zci--geometry-formulas .formula .dot';
                var svgSelector = '#zci--geometry-svg *';
                $(formulaSelector).hover(
                  function() {
                    console.log('test');
                    $( this ).addClass( "hover" );
                  }, function() {
                    $( this ).removeClass( "hover" );
                  }
                );
            }
        };
    };
})(DDH);
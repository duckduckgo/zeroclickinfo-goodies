DDH.geometry_goodie = DDH.geometry_goodie || {};

(function(DDH) {
    "use strict";

    DDH.geometry_goodie.build = function(ops) {
        return {
            onShow: function() { 
                var formulaSelector = '#zci--geometry-formulas .formula .dot';
                var svgSelector = '#zci--geometry-svg *';
                    
                $(svgSelector + ',' + formulaSelector).hover(
                    function() {
                        // Get Current geoemetry type
                        var datatype = $( this ).data('type');
                        // Add Hover to Dot
                        $('#zci--geometry .'+ datatype).addClass( "hover" );
                        // Add Hover to SVG
                        // JQuery 1.1 cant select SVGs by normal selectors
                        var svg = document.querySelector("#zci--geometry-svg ." + datatype);
                        svg.classList.add("hover");
                        
                        
                    }, function() {
                        // Remove hovers when not hovering
                        var datatype = $( this ).data('type');
                        $('#zci--geometry .' + datatype).removeClass( "hover" );
                        
                        var svg = document.querySelector("#zci--geometry-svg ." + datatype);
                        svg.classList.remove("hover");
                    }
                );
            }
        };
    };
})(DDH);
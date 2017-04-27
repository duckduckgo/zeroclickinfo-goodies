DDH.geometry = DDH.geometry || {};

(function(DDH) {
    "use strict";

    DDH.geometry.build = function(ops) {
        return {
            onShow: function() {
                var formulaSelector = '.geometry-formulas .formula .dot';
                var svgSelector = '.geometry-svg *';

                $(svgSelector + ',' + formulaSelector).hover(
                    function() {
                        // Get Current geoemetry type
                        var datatype = $( this ).data('type');
                        // Add Hover to Dot
                        $('#geometry--goodie .'+ datatype).addClass( "hover" );
                        // Add Hover to SVG
                        // JQuery 1.1 cant select SVGs by normal selectors
                        var svg = document.querySelector(".geometry-svg ." + datatype);
                        svg.classList.add("hover");


                    }, function() {
                        // Remove hovers when not hovering
                        var datatype = $( this ).data('type');
                        $('#geometry--goodie .' + datatype).removeClass( "hover" );

                        var svg = document.querySelector(".geometry-svg ." + datatype);
                        svg.classList.remove("hover");
                    }
                );
            }
        };
    };
})(DDH);

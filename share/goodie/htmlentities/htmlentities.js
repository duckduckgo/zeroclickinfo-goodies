DDH.html_entities = DDH.htmlentities || {};

DDH.html_entities.build = function(ops) {
    "use strict";

    Spice.registerHelper('lookup', function(obj, key) {
        if (obj) {
            if (key in obj) {
                return obj[key];
            }
        }
        return null;
    });

    var wasShown = false;

    return {
        onShow: function() {

            if (wasShown) {
                return;
            }

            wasShown = true;

            var $dom = $("#zci-htmlentities");
            var $table = $dom.find("table.htmlentities");
            var $bodyCells = $table.find('tbody tr:first').children();

            var flowHeader = function() {
                var colWidth = $bodyCells.map(function() {
                    return $(this).width();
                }).get();
                $table.find('thead tr').children().each(function(i, v) {
                    $(v).width(colWidth[i]);
                });
            };

            $(window).resize(flowHeader);
            setTimeout(flowHeader, 500);
        }
    };
};

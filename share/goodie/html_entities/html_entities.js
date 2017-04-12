DDH.html_entities = DDH.html_entities || {};

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
};

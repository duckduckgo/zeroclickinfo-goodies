DDH.url_escape_codes = DDH.url_escape_codes || {};

DDH.url_escape_codes.build = function(ops) {
    "use strict";

    Spice.registerHelper('get_value', function(obj, key) {
        if (obj) {
            if (key in obj) {
                return obj[key];
            }
        }
        return '';
    });
};
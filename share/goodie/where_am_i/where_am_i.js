DDH.goodie_where_am_i = DDH.goodie_where_am_i || {};

DDG.require('maps', function (DDH) {
    "use strict";

    DDH.goodie_where_am_i.build = function(ops) {
        
        var myLatitude = (Math.round(ops.data.lat * 100) / 100).toFixed(2);
        var myLongitude = (Math.round(ops.data.lon * 100) / 100).toFixed(2);
       
        return {
            model: 'Place',
            view: 'Map',
            
            data: [{
                display_name: "Apparent current location",
                name: "Apparent current locationn",
                lat: myLatitude,
                lon: myLongitude
            }],
            meta: {
                zoomLevel: 3
            }
        };
    };
}(DDH));
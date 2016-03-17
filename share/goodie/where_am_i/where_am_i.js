DDH.where_am_i = DDH.where_am_i || {};

DDG.require('maps', function (DDH) {
    "use strict";

    DDH.where_am_i.build = function(ops) {
        var myLatitude = (Math.round(ops.data.lat * 100) / 100).toFixed(2);
        var myLongitude = (Math.round(ops.data.lon * 100) / 100).toFixed(2);
        var displayName = ops.data.display;
        
        return {
            model: 'Place',
            view: 'Map',
            
            data: [{
                display_name: displayName,
                name: displayName,
                lat: myLatitude,
                lon: myLongitude
            }],
            meta: {
                zoomLevel: 3
            },
            normalize: function(item) {
                return {
                    lat: myLatitude,
                    lon: myLongitude
                };
            }
        };
    };
}(DDH));

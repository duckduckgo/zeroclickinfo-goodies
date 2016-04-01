DDH.where_am_i = DDH.where_am_i || {};

DDH.where_am_i.build_async = function(ops, DDH_async_add) {
    
    var myLatitude = (Math.round(ops.data.lat * 100) / 100).toFixed(2);
    var myLongitude = (Math.round(ops.data.lon * 100) / 100).toFixed(2);
    var displayName = ops.data.display;

    DDG.require('maps', function(){
        DDH_async_add({
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
            }
        });
    });
};

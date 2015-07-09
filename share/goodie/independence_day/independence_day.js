DDH.independence_day = DDH.independence_day || {};
DDH.independence_day.build = function(ops) {
    return {
        normalize: function(item) {
            return {
                image: DDG.settings.region.getLargeIconURL(ops.data.country_code)
            };
        }
    };
};
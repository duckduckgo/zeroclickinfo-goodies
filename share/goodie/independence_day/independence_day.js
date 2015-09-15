DDH.independence_day = DDH.independence_day || {};
DDH.independence_day.build = function(ops) {
    var flagUrl = DDG.settings.region.getLargeIconURL(ops.data.country_code);
    // makes flag icon url point to a 64 px image.
    flagUrl = flagUrl.replace(/\/\d+\//, "/64/");
    return {
        normalize: function(item) {
            return {
                image: flagUrl
            };
        }
    };
};
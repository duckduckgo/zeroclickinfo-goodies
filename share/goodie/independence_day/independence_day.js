DDH.independence_day = DDH.independence_day || {};

DDH.independence_day.build = function(ops) {
    return {
        normalize: function(item) {
            var isMobile = ($('.is-mobile').length > 0) ? true : false;
            var info = {
                title: ops.data.date,
                subtitle: ops.data.info
            };
            if (isMobile) {
                info.image = DDG.settings.region.getSmallIconURL(ops.data.country_code);
            } else {
                info.image = DDG.settings.region.getLargeIconURL(ops.data.country_code);
            }
            return info;
        }
    };
};
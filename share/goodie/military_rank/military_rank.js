DDH.military_rank = DDH.military_rank || {};
var no_insignia_svg = DDG.get_asset_path('military_rank', 'no_insignia.svg');
no_insignia_svg = no_insignia_svg.replace(/spice/, 'goodie')
DDH.military_rank.build = function(ops) {
    return {
        normalize: function(item) {
            return {
                image: item.image.length == 0 ? no_insignia_svg : item.image
            };
        }
    };
};
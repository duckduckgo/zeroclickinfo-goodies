DDH.military_rank = DDH.military_rank || {};

DDH.military_rank.build = function(ops) {
    var no_insignia_svg = '/share/goodie/military_rank/' + ops.goodie_version + '/no_insignia.svg';

    return {
        normalize: function(item) {
            return {
                image: item.image.length == 0 ? no_insignia_svg : item.image
            };
        }
    };
};
DDH.screen_resolution = DDH.screen_resolution || {};

DDH.screen_resolution.build = function(ops){
    var title = window.screen.width + ' × ' + window.screen.height,
        sub = ['Your Screen Resolution'];
    if (window.devicePixelRatio && window.devicePixelRatio > 1){
        sub.push('Pixel Ratio: x' + window.devicePixelRatio);
    }

    ops.data.title = title;
    ops.data.subtitle = sub;
    return ops;
}

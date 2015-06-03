DDH.screen_resolution = DDH.screen_resolution || {};

DDH.screen_resolution.build = function(ops){
    var res = 'Your screen resolution is ' + window.screen.width + 'x' + window.screen.height;
    if (window.devicePixelRatio && window.devicePixelRatio > 1){
        res += ' (pixel ratio x' + window.devicePixelRatio + ')';
    }

    ops.data.title = res;
    return ops;
}

DDH.screen_resolution = DDH.screen_resolution || {};

DDH.screen_resolution.build = function(ops){
    return {
        onShow: function(){
            var res = 'Your screen resolution is ' + window.screen.width + 'x' + window.screen.height;
            if (window.devicePixelRatio && window.devicePixelRatio > 1){
                res += ' (pixel ratio x' + window.devicePixelRatio + ')';
            }
            $('#zci-screen_resolution').find('h3').html(res);
        }
    }
}
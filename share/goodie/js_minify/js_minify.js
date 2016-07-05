DDH.js_minify = DDH.js_minify || {};

"use strict";

DDH.js_minify.build = function(ops) {

    var shown = false;

    return {
        onShow: function() {
            // make sure this function is run only once, the first time
            // the IA is shown otherwise things will get initialized more than once
            if (shown)
                return;

            // set the flag to true so it doesn't get run again
            shown = true;

            $.getScript('')
            
            var $dom = $('#zci-js_minify'),
                $main = $dom.find('.zci__main'),
                $minifyButton = $dom.find('.js_minify__action');

            $main.toggleClass('c-base');

            var minifyCode = function() {
                console.log("Call for minifyCode");
            };

            $minifyButton.click(minifyCode);

        }
    };
};

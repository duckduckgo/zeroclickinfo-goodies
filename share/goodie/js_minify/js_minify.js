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

            var $dom = $('#zci-js_minify'),
                $main = $dom.find('.zci__main'),
                $minifyButton = $dom.find('.js_minify__action'),
                $input = $dom.find('#js_minify__input'),
                $output = $dom.find('#js_minify__output');

            $main.toggleClass('c-base');

            // hide output textarea by default
            $output.css('display', 'none');

            $.getScript('http://sahildua.com/js/prettydiff.min.js', function() {
                // Add click handler for the minify button
                $minifyButton.click(function() {
                    // Set config options for minify operation
                    var args = {
                        mode: "minify",
                        lang: "javascript",
                        source: $input.val()
                    };

                    // Operate using the prettydiff function provided by the library
                    var output = prettydiff(args);

                    // hide output textarea by default
                    $output.css('display', 'inline');

                    // Add the output to output textarea field
                    $output.val(output);
                });
            })
        }
    };
};

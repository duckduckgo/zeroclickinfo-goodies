DDH.js_minify = DDH.js_minify || {};

DDH.js_minify.build = function(ops) {
    "use strict";

    // Flag to make denote if IA has been shown or not
    var shown = false;

    // Flag to denote if library 'prettydiff' has been loaded or not
    var libLoaded = false;

    ops.data.cols = is_mobile ? 8 : 20;

    return {
        onShow: function() {
            // Make sure this function is run only once, the first time
            // the IA is shown otherwise things will get initialized
            // more than once
            if (shown)
                return;

            // Set the flag to true so it doesn't get run again
            shown = true;

            var $dom = $('.zci--js_minify'),
                $minifyButton = $dom.find('button'),
                $input = $dom.find('.js_minify--input'),
                $output = $dom.find('.js_minify--output');

            // remove max-width restriction from container
            $dom.find(".zci__main").removeClass('c-base');

            // Add event handler for change in input of textarea
            $input.on('input', function() {
                if (!libLoaded) {
                    // Set the flag to make sure the library isn't loaded
                    // again and again
                    libLoaded = true;

                    // Change text of button to show the loading action
                    // to make sure users aren't confused to see
                    // the disabled button
                    $minifyButton.text('Loading..');

                    // load the library
                    DDG.require('prettydiff', function() {
                        // Change the text of button back to 'Minify',
                        // enable the button and change the pointer back to
                        // 'pointer'
                        $minifyButton
                            .text('Minify Code')
                            .prop('disabled', false)
                            .css('cursor', 'pointer')
                            .removeClass('btn--skeleton')
                            .addClass('btn--primary');
                    });
                }
            });

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

                // Remove is-hidden class to make it visible again
                $output.parent().removeClass('is-hidden');

                // Add the output to output textarea field
                $output.val(output);
            });
        }
    };
};

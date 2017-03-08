DDH.js_beautifier = DDH.js_beautifier || {};

DDH.js_beautifier.build = function(ops) {
    "use strict";

    // Flag to make denote if IA has been shown or not
    var shown = false;

    // Flag to denote if library 'beautify-js' has been loaded or not
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

            var $dom = $('.zci--js_beautifier'),
                $beautifyButton = $dom.find('button'),
                $input = $dom.find('.js_beautifier--input'),
                $output = $dom.find('.js_beautifier--output');

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
                    $beautifyButton.text('Loading..');

                    // load the library
                    DDG.require('js-beautify', function(){
                        // Change the text of button back to 'Beautify',
                        // enable the button and change the pointer back to
                        // 'pointer'
                        $beautifyButton
                            .text('Beautify Code')
                            .prop('disabled', false)
                            .css('cursor', 'pointer')
                            .removeClass('btn--skeleton')
                            .addClass('btn--primary');
                    });
                }
            });

            // Add click handler for the beautify button
            $beautifyButton.click(function() {
                // Remove is-hidden class to make it visible again
                $output.parent().removeClass('is-hidden');

                // Add the output to output textarea field
                $output.val(window.js_beautify($input.val()));
            });
        }
    };
};

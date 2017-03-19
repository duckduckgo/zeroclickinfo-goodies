DDH.html_beautifier = DDH.html_beautifier || {};

DDH.html_beautifier.build = function(ops) {
    "use strict";

    // Flag to make denote if IA has been shown or not
    var shown = false;

    // Flag to denote if library 'prettydiff' has been loaded or not
    var libLoaded = false;

    ops.data.cols = is_mobile ? 8 : 20;

    return {
        onShow: function () {
            // Make sure this function is run only once, the first time
            // the IA is shown otherwise things will get initialized
            // more than once
            if (shown)
                return;

            // Set the flag to true so it doesn't get run again
            shown = true;

            var $dom = $('.zci--html_beautifier'),
                $beautifyButton = $dom.find('.html--beautify-btn'),
                $clearButton = $dom.find('.html--clear-btn'),
                $input = $dom.find('.html_beautifier--input'),
                $output = $dom.find('.html_beautifier--output');

            function enableButtons() {
                $beautifyButton
                    .prop('disabled', false)
                    .css('cursor', 'pointer')
                    .removeClass('is-disabled')
                    .addClass('btn--primary');

                $clearButton
                    .prop('disabled', false)
                    .css('cursor', 'pointer')
                    .removeClass('is-disabled')
                    .addClass('btn--secondary');
            }

            function disableButtons() {
                $beautifyButton
                    .prop('disabled', true)
                    .addClass('is-disabled')
                    .removeClass('btn--primary');

                $clearButton
                    .prop('disabled', true)
                    .addClass('is-disabled')
                    .removeClass('btn--secondary');
            }

            // remove max-width restriction from container
            $dom.find(".zci__main").removeClass('c-base');
            // Add event handler for change in input of textarea
            $input.on('input', function () {
                if (!$input.val().length) {
                    disableButtons();
                }
                else if (!libLoaded) {
                    // Set the flag to make sure the library isn't loaded
                    // again and again
                    libLoaded = true;

                    // Change text of button to show the loading action
                    // to make sure users aren't confused to see
                    // the disabled button
                    $beautifyButton.text('Loading..');

                    // load the library
                    DDG.require('html-beautify', function () {
                        // Change the text of button back to 'Beautify',
                        // enable the button and change the pointer back to
                        // 'pointer'
                        $beautifyButton.text('Beautify');
                        enableButtons();
                    });
                } else {
                    enableButtons();
                }
            });

            // Add click handler for the beautify button
            $beautifyButton.click(function () {
                var options = {
                    "indent_size": 4,
                    "indent_char": " ",
                    "eol": "\n",
                    "indent_level": 0,
                    "indent_with_tabs": false,
                    "preserve_newlines": true,
                    "max_preserve_newlines": 1,
                    "jslint_happy": false,
                    "space_after_anon_function": true,
                    "brace_style": "collapse",
                    "keep_array_indentation": false,
                    "keep_function_indentation": false,
                    "space_before_conditional": true,
                    "break_chained_methods": false,
                    "eval_code": false,
                    "unescape_strings": true,
                    "wrap_line_length": 0,
                    "wrap_attributes": "auto",
                    "wrap_attributes_indent_size": 4,
                    "end_with_newline": false
                };
                // Remove is-hidden class to make it visible again
                $output.parent().removeClass('is-hidden');
                // Add the output to output textarea field
                $output.val(window.html_beautify($input.val(), options));
            });
            $clearButton.click(function () {
                // clear the input textarea
                $input.val('');
                $output.val('');
                $output.parent().addClass('is-hidden');
                // disable validate and clear buttons
                disableButtons();
            });
        }
    };
};
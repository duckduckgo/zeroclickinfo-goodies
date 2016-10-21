DDH.sass_to_css = DDH.sass_to_css || {};

DDH.sass_to_css.build = function (ops) {
    "use strict";

    // Flag to make denote if IA has been shown or not
    var shown = false,
        sass;
    ops.data.rows = is_mobile ? 8 : 30;
    return {
        onShow: function () {
            // Make sure this function is run only once, the first time
            // the IA is shown otherwise things will get initialized
            // more than once
            if (shown)
                return;

            // Set the flag to true so it doesn't get run again
            shown = true;

            var $dom = $('.zci--sass_to_css'),
                $validateButton = $dom.find('.sass_to_css--validate_button'),
                $clearButton = $dom.find('.sass_to_css--clear_button'),
                $input = $dom.find('.sass_to_css--input'),
                $output = $dom.find('.sass_to_css--output'),
                $error = $dom.find('.sass_to_css--error');

            function enableButtons() {
                $validateButton
                    .prop('disabled', false)
                    .css('cursor', 'pointer')
                    .removeClass('btn--skeleton')
                    .addClass('btn--primary');
                $clearButton
                    .prop('disabled', false)
                    .css('cursor', 'pointer')
                    .removeClass('btn--skeleton')
                    .addClass('btn--primary');
            }

            function disableButtons() {
                $validateButton
                    .prop('disabled', true)
                    .css('cursor', 'default')
                    .addClass('btn--skeleton')
                    .removeClass('btn--primary');
                $clearButton
                    .prop('disabled', true)
                    .css('cursor', 'default')
                    .addClass('btn--skeleton')
                    .removeClass('btn--primary');
            }

            // Load library when the IA is shown for the first time
            $input.on('input', function () {
                if (!$input.val().length) {
                    disableButtons();
                } else if (!sass) {

                    $validateButton
                        .text('Loading..');

                    DDG.require('sass.js', function () {
                        sass = Sass;
                        $validateButton
                            .text('Convert');
                        enableButtons();
                    });
                } else {
                    enableButtons();
                }
            });

            $validateButton
                .click(function () {
                    if (sass) {
                        $error.parent().addClass('is-hidden');
                        $output.val('');
                        sass.compile($input.val(), function (result) {
                            if (result.status === 0) {
                                $output.val(result.text);
                                return;
                            }
                            $error.parent().removeClass('is-hidden');
                            $error.html(result.formatted);
                        });
                    }
                });

            $clearButton.click(function () {
                // clear the input textarea
                $input.val('');
                $output.val('');

                // hide the results section
                $error.parent().addClass('is-hidden');

                // disable validate and clear buttons
                disableButtons();
            });
        }
    };
};

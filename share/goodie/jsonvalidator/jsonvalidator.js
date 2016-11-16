DDH.json_validator = DDH.json_validator || {};

DDH.json_validator.build = function(ops) {
    "use strict";

    // Flag to make denote if IA has been shown or not
    var shown = false;

    ops.data.rows = is_mobile ? 8 : 20;

    return {
        onShow: function() {
            // Make sure this function is run only once, the first time
            // the IA is shown otherwise things will get initialized
            // more than once
            if (shown)
                return;

            // Set the flag to true so it doesn't get run again
            shown = true;

            var $dom = $('.zci--json_validator'),
                $validateButton = $dom.find('.json_validator--validate_button'),
                $clearButton = $dom.find('.json_validator--clear_button'),
                $input = $dom.find('.json_validator--input'),
                $result = $dom.find('.json_validator--result');

            // Load library when the IA is shown for the first time
            DDG.require('jsonlint', function () {
                $validateButton
                    .text('Validate JSON')
                    .css('cursor', 'default');
            });

            $input.on('input', function() {
                if ($input.val() == '') {
                    $validateButton
                        .prop('disabled', true)
                        .css('cursor', 'default')
                        .addClass('btn--skeleton')
                        .removeClass('btn--primary');
                } else {
                    $validateButton
                        .prop('disabled', false)
                        .css('cursor', 'pointer')
                        .removeClass('btn--skeleton')
                        .addClass('btn--primary');
                }
            });

            $validateButton.click(function () {
                // Fetch the value of indentation options (2 or 4 spaces)
                var tabSize = $('#tabsize').val();

                $result.parent().removeClass('is-hidden');
                try {
                    var result = jsonlint.parse($input.val());
                    // JSON is valid
                    if (result) {
                        $result
                            .html("JSON is valid!")
                            .removeClass('tx-clr--red-dark')
                            .addClass('tx-clr--green');

                        // Set indentation according to option selected by user
                        var indentation = ( tabSize == 1 ) ? '\t' : ' '.repeat(tabSize);

                        // Prettyprint (beautify) JSON when it's valid
                        $input.val(JSON.stringify(result, null, indentation));
                    }
                } catch(e) {
                    // JSON is invalid, show the exception (error)
                    $result
                        .html(e)
                        .removeClass('tx-clr--green')
                        .addClass('tx-clr--red-dark')
                }
            });

            $clearButton.click(function () {
                // clear the input textarea
                $input.val('');

                // hide the results section
                $result.parent().addClass('is-hidden');

                // disable validate button
                $validateButton
                    .prop('disabled', true)
                    .css('cursor', 'default')
                    .addClass('btn--skeleton')
                    .removeClass('btn--primary');
            });
        }
    };
};

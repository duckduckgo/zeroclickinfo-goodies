DDH.sass_to_css = DDH.sass_to_css || {};

DDH.sass_to_css.build = function(ops) {
    "use strict";

    // Flag to make denote if IA has been shown or not
    var shown = false,
        sass;
    ops.data.rows = is_mobile ? 8 : 30;
    var goodie_version = ops.data.goodie_version;
    return {
        onShow: function() {
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

            // Load library when the IA is shown for the first time

            $.getScript("http://medialize.github.io/sass.js/dist/sass.js").done(function(){
                Sass.setWorkerUrl("share/goodie/sass_to_css/"+goodie_version+"/sass.worker.js");
                sass = new Sass();
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
                sass.compile(input.value, function (result) {
                    if (result.status === 0) {
                        $output.value = result.text;
                        return;
                    }
                    $error.parent().removeClass('is-hidden');
                    $error.value = result.formatted;
                });
            });

            $clearButton.click(function () {
                // clear the input textarea
                $input.val('');
                $output.val('');

                // hide the results section
                $error.parent().addClass('is-hidden');

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

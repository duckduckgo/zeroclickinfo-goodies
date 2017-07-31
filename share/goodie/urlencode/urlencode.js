DDH.urlencode = DDH.urlencode || {};

DDH.urlencode.build = function(ops) {
    "use strict";
    
    var shown = false;
    
    return {
        onShow: function() {
            if(shown)
                return;
            
            shown = true;
            
            var $dom = $('.zci--urlencode'),
                $encodeButton = $('.urlencode--encode_button'),
                $decodeButton = $('.urlencode--decode_button'),
                $clearButton = $('.urlencode--clear_button'),
                $input = $dom.find('.urlencode--input'),
                $output = $dom.find('.urlencode--output'),
                $error = $dom.find('urlencode--error')
            
            function enableButtons() {
                $encodeButton
                  .prop('disabled', false)
                  .css('cursor', 'pointer')
                  .removeClass('is-disabled')
                  .addClass('btn--primary')
                $decodeButton
                  .prop('disabled', false)
                  .css('cursor', 'pointer')
                  .removeClass('is-disabled')
                  .addClass('btn--primary')
                $clearButton
                    .prop('disabled', false)
                    .css('cursor', 'pointer')
                    .removeClass('is-disabled')
                    .addClass('btn--secondary');
            }
            
            function disableButtons() {
                $encodeButton
                  .prop('disabled', true)
                  .css('cursor', 'default')
                  .addClass('is-disabled')
                  .removeClass('btn--primary')
                $decodeButton
                  .prop('disabled', true)
                  .css('cursor', 'default')
                  .addClass('is-disabled')
                  .removeClass('btn--primary')
                $clearButton
                    .prop('disabled', true)
                    .css('cursor', 'default')
                    .addClass('is-disabled')
                    .removeClass('btn--secondary');
            }
            
            $input.on('input', function() {
                if(!$input.val().length) {
                    disableButtons();
                } else {
                    $encodeButton
                        .text('Loading...');
                        $encodeButton
                            .text('Encode');
                        enableButtons();
                }
            });
            
            $encodeButton
                .click(function() {
                $output.val('');
                $output.removeClass('is-hidden');
                $output.val(encodeURIComponent($input.val()))
                $error.parent().removeClass('is-hidden');
            })            
            
            $decodeButton
                .click(function() {
                $output.val('');
                $output.removeClass('is-hidden');
                $output.val(decodeURIComponent($input.val()))
                $error.parent().removeClass('is-hidden');
            })
            
            $clearButton
                .click(function() {
                    $input.val('');
                    $output.val('');
                    $output.addClass('is-hidden');
                    $error.parent().addClass('is-hidden');
                
                    disableButtons();
            })
        }
    }
    
}
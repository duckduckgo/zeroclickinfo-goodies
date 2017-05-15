DDH.metronome = DDH.metronome || {};

(function(DDH) {
    "use strict";

    console.log('DDH.metronome.build'); // remove this before submitting pull request

    // define private variables and functions here
    //
    // function helper () { ... }
    //
    // var a = '',
    //     b = '',
    //     c = '';

    DDH.metronome.build = function(ops) {
        console.log("ops: " + JSON.stringify(ops));
        console.log("ops.data: " + JSON.stringify(ops.data));
        return {

            // Function that executes after template content is displayed
            onShow: function() {

                // define any callbacks or event handlers here
                //
                // var $dom = $(".zci--metronome");
                // $dom.find(".my-special-class").click(function(){
                //
                // });

            }
        };
    };
})(DDH);

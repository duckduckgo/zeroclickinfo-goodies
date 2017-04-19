DDH.volume_of = DDH.volume_of || {};

(function(DDH) {
    "use strict";

    console.log("DDH.volume_of.build"); // remove this before submitting pull request

    var answer;
    
    DDH.volume_of.build = function(ops) {

        return {

            normalize: function(item){
                answer = item.answer;
                return {
                    answer: item.answer
                };
            },

            // Initiate Math quill To render LaTex
            onShow: function() {
                DDG.require('mathquill', function (){
                    var container = Spice.getDOM('volume_of');
                    $(container).find(".mathquill-embedded-latex").mathquill('latex', answer);
                });
            }
        };
    };
})(DDH);

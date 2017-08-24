DDH.nutritional = DDH.nutritional || {};

(function(DDH) {
    "use strict";

    console.log('DDH.nutritional.build'); // remove this before submitting pull request

    // define private variables and functions here
    //
    // function helper () { ... }
    //
    // var a = '',
    //     b = '',
    //     c = '';

    DDH.nutritional.build = function(ops) {

        return {

            meta: {
                sourceName: 'United States Department of Agriculture',
                sourceUrl: 'https://source.website.com'
            },

            // normalize: function(item){
            //     use this to map your 'data'
            //     to the properties required for your chosen template
            //
            //     return {
            //         title: item.myTitle,
            //         subtitle: item.foo.subtitle
            //     };
            // },
            
            onShow: function() {

                // define any callbacks or event handlers here
                //
                // var $dom = $(".zci--nutritional");
                // $dom.find(".my-special-class").click(function(){
                //
                // });

            }
        };
    };
})(DDH);

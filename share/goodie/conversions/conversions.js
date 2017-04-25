DDH.conversions = DDH.conversions || {};

(function(DDH) {
    "use strict";

    console.log('DDH.conversions.build');
    
    var firstUnit   = undefined,
        secondUnit  = undefined,
        firstValue  = undefined,
        secondValue = undefined;
    
    

    DDH.conversions.build = function(ops) {

        return {
            signal: "high",

            data: {
            // already defined in Perl Package
            // you can re-define it here
            // or access/modify 'ops.data'
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

            // Function that executes after template content is displayed
            onShow: function() {
                DDG.require('math.js', function() {
                    alert(math.eval('10m to cm')); 
                });
            }
        };
    };
})(DDH);
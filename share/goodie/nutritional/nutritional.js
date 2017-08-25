DDH.nutritional = DDH.nutritional || {};

(function(DDH) {
    "use strict";

    DDH.nutritional.build = function(ops) {

        var headings = ops.data.information["headings"];
        var protein = ops.data.information["Protein"];
        console.log(ops.data.information);

        return {

            meta: {
                sourceName: 'United States Department of Agriculture',
                sourceUrl: 'https://ndb.nal.usda.gov/ndb/search/list?qlookup=09040'
            },

            normalize: function(item){
            
                return {
                    title: "Banana",
                    subtitle: "Fruit",
                    headings: headings,
                    protein: "1.1g",
                    calories: 89,
                };
            },
            
            onShow: function() {

                // var $dom = $(".zci--nutritional");
                // $dom.find(".my-special-class").click(function(){
                //
                // });

            }
        };
    };
})(DDH);

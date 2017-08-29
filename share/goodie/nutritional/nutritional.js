DDH.nutritional = DDH.nutritional || {};

(function(DDH) {
    "use strict";

    var nutritional_cache = {};

    function init(data) {
        var headings = data["headings"];
        delete data["headings"]; 

        for(var i = 0; i < headings.length; i++) {
          console.log(headings[i]);         
          for(var key in data) {
            console.log("Key -> " + key);
            console.log("Vals -> " + data[key]);
            console.log("Vals len -> " + data[key].length);
          }
        }

        console.log(nutritional_cache);
    }

    DDH.nutritional.build = function(ops) {

        var headings = ops.data.information["headings"];
        var protein = ops.data.information["Protein"];

        init(ops.data.information);

        return {

            meta: {
                sourceName: 'United States Department of Agriculture',
                sourceUrl: 'https://ndb.nal.usda.gov/ndb/search/list?qlookup=09040'
            },

            normalize: function(item){
            
                return {
                    title: "Apple",
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

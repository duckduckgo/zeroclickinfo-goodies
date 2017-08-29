DDH.nutritional = DDH.nutritional || {};

(function(DDH) {
    "use strict";

    var initialized = false;
    var nutritional_cache = {};

    function init(data) {
        var headings = data["headings"];
        delete data["headings"]; 

        for(var i = 0; i < headings.length; i++) {
          nutritional_cache[headings[i]] = []; 
          for(var key in data) {

            if(data[key].length > 6) { data[key].shift(); }
            var tmp_obj = {};
            tmp_obj[key.toLowerCase().replace(/\s+/g, "_")] = data[key][i];
            nutritional_cache[headings[i]].push(tmp_obj);

          }
        }

        console.log(nutritional_cache);
    }

    DDH.nutritional.build = function(ops) {

        var headings = ops.data.information["headings"];
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

                var $dom = $(".zci--nutritional");
                initialized = true;

            }
        };
    };
})(DDH);

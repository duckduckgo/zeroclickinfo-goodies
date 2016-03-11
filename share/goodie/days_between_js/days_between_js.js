DDH.days_between_js = DDH.days_between_js || {};

(function(DDH) {
    "use strict";

    console.log("DDH.days_between_js.build"); // remove this before submitting pull request

    // define private variables and functions here
    //
    // fuction helper () { ... }
    //
    // var a = '',
    //     b = '',
    //     c = '';


    DDH.days_between_js.build = function(ops) {

      function dateRange(ops) {
        var query = ops.query;
        return query;
      }

      function inDays(startDate, endDate) {
        var seconds = Math.round(endDate - startDate);
        var days = (seconds / (60*60*24));
        return days;
      }

      console.log('now');
      console.log(ops);


        return {
            id: 'days_between_js',
            data: {
              title: 'Detailed',
              record_data: {
                query: "" + dateRange(ops),
                minutes: "",
                hours: "",
                days: "",
              }
            },
            templates: {
              group: 'text',
              options: {
                content: 'record',
                rowHighlight: 'true'
              }
            },

            // data: {
            //     already defined in Perl Package
            //     you can re-define it here
            //     or access/modify 'ops.data'
            // },

            // normalize: function(item){
            //     use this to map your 'data'
            //     to the properties required for your chosen template
            //
            //     return {
            //         title: item.myTitle,
            //         subtitle: item.foo.subtitle
            //     };
            // },

            // templates: {
            //     group: 'text',
            //
            //     options: {
            //
            //     },
            //
            //     variants: {
            //
            //     }
            // },

            // Function that executes after template content is displayed
            onShow: function() {
              console.log('TEST');
              console.log(dateRange(ops));
            //  console.log(ops);
                // define any callbacks or event handlers here
                //
                // var $dom = $(".zci--'days_between_js'");
                // $dom.find(".my-special-class").click(funtcion(){
                //
                // });

            }
        };

    };
})(DDH);

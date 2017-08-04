DDH.speedtest = DDH.speedtest || {};

(function(DDH) {
    "use strict";

    DDH.speedtest.build = function(ops) {

        return {

            meta: {
                sourceName: 'Fast.com',
                sourceUrl: 'https://fast.com'
            },


            normalize: function(item){
                return {
                    title: 'Network Speed Test',
                    subtitle: 'Powered By Fast.com - Netflix',
                };
            },

            templates: {
                group: 'info',
            
                options: {
                    content: 'DDH.speedtest.content'
                }
            },
        };
    };
})(DDH);

DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";

    var hasShown = false;
    var countdown;
    var loaded = false;    
       
    DDG.require('moment.js', function() {
           loaded = true;                
           getCountdown();               
    });       
    
    function getCountdown() {
        var from  = moment().seconds();
        console.log("from " + from);
        var to = moment().day("Friday");
        var ms = moment(from,"DD/MM/YYYY HH:mm:ss").diff(moment(to,"DD/MM/YYYY HH:mm:ss"));
        var d = moment.duration(ms);
        var s = Math.floor(d.asHours()) + moment.utc(ms).format(":mm:ss");
        countdown = s;                 
        console.log("countdown" + countdown);
    }
    
    function parseQueryForTime() {
        var query = DDH.get_query();
        var regex = new RegExp(/[\s]+ (\d{1,2}) [\s]+ ([Aa|Pp][Mm])/);
    }
    
    DDH.countdown.build = function(ops) {                
        
        return {
            id: 'countdown',
            
            templates: {
                group: 'text',
                options: {
                    content: DDH.countdown.countdown
                },
            },
            
            onShow: function() {
                if(hasShown) {
                    return;
                }                
                
                console.log("in on show");
                hasShown = true;                
                $(".time_display").html(countdown);                
                setInterval(function() {
                    getCountdown();
                    $(".time_display").html(countdown);
                }, 1000);
            }
        };
    };
})(DDH);
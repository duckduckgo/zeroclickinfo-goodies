DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";

    var hasShown = false;
    var countdown = "";
    var initialDifference;       
    var halfComplete = false;
    
    function padZeroes(s, len) {
//        var s = n.toString();
        while (s.length < len) {
            s = '0' + s;
        }
        return s;
    }
    
    function renderProgressCircle(difference) {
            var progress = 1 - difference / initialDifference,
                angle = 360 * progress;
            
            //var $my_countdown = DDH.getDOM('countdown');
            var $progressRotFill = $(".countdown_container").find('.rotated_fill');
            // the progress circle consists of two clipped divs,
            // each displaying as a half circle
            //
            // one of them rotates based on how much the timer's progressed
            // the other one is stationary, and is only displayed once the timer is half complete

            // the first time we reach progress over 0.5
            // add the "half_complete" class
            if (!halfComplete && progress > 0.5) {
                halfComplete = true;
                $(".countdown_container").addClass("half_complete");
            }

            $progressRotFill.css("transform", "rotate(" + angle + "deg)");
    }
    
    function displayCountdown(difference) {                       
        var parts = countdown.split(":");
        if(parts.length > 1) {
            if(parts[0] > 0) {
                $(".time_display .years,.months").show();                
                $(".time_display .years").html(padZeroes(parts[0],2));    
                $(".time_display .months").html(":"+padZeroes(parts[1],2));
                $(".time_display .days").html(":"+padZeroes(parts[2],2));
                $(".time_display .unit_year,.unit_month").show();                
            } else if(parts[1] > 0) {
                $(".time_display .months").show();
                $(".time_display .months").html(padZeroes(parts[1],2));
                $(".time_display .days").html(":"+padZeroes(parts[2],2));
                $(".time_display .unit_month").show();                                
            } else {
                $(".time_display .days").html(padZeroes(parts[2],2));    
            }            
            $(".time_display .hours").html(":"+padZeroes(parts[3],2));
            $(".time_display .minutes").html(":"+padZeroes(parts[4],2));
            $(".time_display .seconds").html(":"+padZeroes(parts[5],2));    
            renderProgressCircle(difference);
        }                
    }
    
    function getCountdown(difference)  {        
        var d = moment.duration(difference);        
        var s = d.years() + ":" + d.months() + ":"+d.days() + ":" + d.hours() + ":" + d.minutes() + ":" + d.seconds();
        countdown = s;       
        difference = d.subtract(1, 's');
        displayCountdown(difference);
        return difference;
    }
    
    DDH.countdown.build = function(ops) {                        
        initialDifference = ops.data.difference/1000000;
        var    remainder = ops.data.remainder,
               duration;        
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
                hasShown = true;          
                
                DDG.require('moment.js', function() {                
                    duration = getCountdown(moment.duration(initialDifference));
                    //displayCountdown();
                    setInterval(function() { 
                        duration = getCountdown(duration); 
                        //displayCountdown();
                    }, 1000);
                });
                $(".name_input").val(DDG.get_query());
            }
        };
    };
})(DDH);
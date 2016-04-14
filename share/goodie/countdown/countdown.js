DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";    
    var hasShown = false;
    var countdown = "";
    var initialDifference;       
    var halfComplete = false;
    var $progressRotFill;
    var stopped = false;
    
    function padZeroes(s, len) {
        while (s.length < len) {
            s = '0' + s;
        }
        return s;
    }
    
    function renderProgressCircle(difference) {            
            var progress = 1 - difference / initialDifference,
                angle = 360 * progress;                        
            
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
                $(".time_display .months").html(padZeroes(parts[1],2));
                $(".time_display .days").html(padZeroes(parts[2],2));
                $(".unit_year,.unit_month").show();                
            } else if(parts[1] > 0) {
                $(".time_display .months").show();                
                $(".time_display .months").html(padZeroes(parts[1],2));                
                $(".time_display .days").html(padZeroes(parts[2],2));
                $(".unit_month").show();             
                $(".time_display .y_separator").addClass("hide_separator");
                $(".time_display .units_y_separator").addClass("hide_separator");
            } else {                
                $(".time_display .days").html(padZeroes(parts[2],2));    
                $(".time_display .y_separator,.m_separator").addClass("hide_separator");
                $(".time_display .units_y_separator,.units_m_separator").addClass("hide_separator");
            }                        
            $(".time_display .hours").html(padZeroes(parts[3],2));
            $(".time_display .minutes").html(padZeroes(parts[4],2));
            $(".time_display .seconds").html(padZeroes(parts[5],2));    
            renderProgressCircle(difference);
        }                
    }
    
    function endCountdown() {
        setInterval(function() { 
            $(".time_display").fadeToggle("fast");
        }, 500);        
    }
    
    function getCountdown(difference)  {                
        if(stopped) {
            return;
        }       
        var d = moment.duration(difference);        
        var s = d.years() + ":" + d.months() + ":"+d.days() + ":" + d.hours() + ":" + d.minutes() + ":" + d.seconds();
        countdown = s;       
        if(difference >= 0) {
            displayCountdown(difference);
            difference = d.subtract(1, 's');            
        } else {
            stopped = true;
            endCountdown();     
        }
        return difference;
    }
        
    DDH.countdown.build = function(ops) {              
        initialDifference = ops.data.difference/1000000;
        var remainder = ops.data.remainder,             
            countdown_to = ops.data.countdown_to,
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
                    setInterval(function() { 
                        duration = getCountdown(duration);                         
                    }, 1000);
                });
                $(".name_input").val("Counting down to "+countdown_to+",");
                $progressRotFill = $(".countdown_container").find('.rotated_fill');
            }
        };
    };
})(DDH);
DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";    
    var hasShown = false,
        countdown = "",
        initialDifference,
        halfComplete = false,
        $countdownContainer,
        $progressRotFill,
        $time_display,
        $fill,
        $displayYears, $displayMonths, $displayDays, 
        $displayHrs, $displayMins, $displaySecs,
        $unitYear,$unitMonth,
        $unitYearSeparator,$unitMonthSeparator,
        $yearSeparator,$monthSeparator,
        stopped = false,
        cachedPlayer, soundIsPlaying = false,
        SOUND_NAME = "alarm-sound",
        soundUrl = 'share/goodie/countdown/alarm.mp3';
    
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
                $displayYears.show(); $displayMonths.show();
                $displayYears.html(padZeroes(parts[0],2));                    
                $displayMonths.html(padZeroes(parts[1],2));
                $displayDays.html(padZeroes(parts[2],2));
                $unitYear.show(); $unitMonth.show();            
            } else if(parts[1] > 0) {
                $displayMonths.show();
                $displayMonths.html(padZeroes(parts[1],2));                
                $displayDays.html(padZeroes(parts[2],2));
                $unitMonth.show();
                $yearSeparator.addClass("hide_separator");
                $unitYearSeparator.addClass("hide_separator");                
            } else {                
                $displayDays.html(padZeroes(parts[2],2));
                $yearSeparator.addClass("hide_separator"); $monthSeparator.addClass("hide_separator");                
                $unitYearSeparator.addClass("hide_separator"); $unitMonthSeparator.addClass("hide_separator");
            }                        
            $displayHrs.html(padZeroes(parts[3],2));
            $displayMins.html(padZeroes(parts[4],2));
            $displaySecs.html(padZeroes(parts[5],2));    
            renderProgressCircle(difference);
        }                
    }
    
    function loop() {                
        cachedPlayer.play(SOUND_NAME, soundUrl, {
            autoPlay: true,
            onfinish: loop
        });
    }

    function stopLoop() {
        soundIsPlaying = false;
        cachedPlayer.stop(SOUND_NAME);
    }
    
    function endCountdown() {
        if (!cachedPlayer) {
            DDG.require('audio', function (player) {
                cachedPlayer = player;                
                endCountdown();
            });
            return;
        }
        // if a sound is already playing, stop for a moment
        // and then start again
        if (soundIsPlaying) {
            stopLoop();
            setTimeout(endCountdown(), 500);
            return;
        }
        // start looping sound - single click anywhere on the screen will
        // stop looping
        loop();
        soundIsPlaying = true;
        $(document).one("click", stopLoop);
         setInterval(function() { 
             $time_display.fadeToggle("fast");
             $fill.fadeToggle("fast");
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
    
    function getReferences() {
        $countdownContainer = $(".zci__body").find(".countdown_container");
        $progressRotFill    = $countdownContainer.find('.rotated_fill');
        $time_display       = $countdownContainer.find('.time_display');
        $fill               = $countdownContainer.find('.fill');
        $displayYears       = $countdownContainer.find('.years');
        $displayMonths      = $countdownContainer.find('.months');
        $displayDays        = $countdownContainer.find('.days');
        $displayHrs         = $countdownContainer.find('.hours');
        $displayMins        = $countdownContainer.find('.minutes');
        $displaySecs        = $countdownContainer.find('.seconds');
        $unitYear           = $countdownContainer.find(".unit_year");
        $unitMonth          = $countdownContainer.find(".unit_month");       
        $unitYearSeparator  = $countdownContainer.find(".units_y_separator");
        $unitMonthSeparator = $countdownContainer.find(".units_m_separator");       
        $yearSeparator      = $countdownContainer.find(".y_separator");
        $monthSeparator     = $countdownContainer.find(".m_separator");
    }
    
    DDH.countdown.build = function(ops) {                      
        var remainder = ops.data.remainder,             
            countdown_to = ops.data.countdown_to,
            duration;                
        initialDifference = ops.data.difference/1000000;
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
                getReferences();
            }
        };
    };
})(DDH);
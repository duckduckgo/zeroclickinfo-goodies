DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";
    var hasShown = false,
        countdown = "",
        initialDifference,
        $countdownContainer,
        $time_display,
        $displayYears, $displayMonths, $displayDays,
        $displayHrs, $displayMins, $displaySecs,
        $year,$month,$display,
        stopped = false,
        cachedPlayer, soundIsPlaying = false,
        SOUND_NAME = "alarm-sound",
        soundUrl = 'share/goodie/countdown/alarm.mp3',
        isVisible = true;
   
    function displayCountdown() {
        var parts = countdown.split(":");
        if(parts.length > 1) {
            if(parts[0] > 0) {
                $year.removeClass("is-hidden");
                $month.removeClass("is-hidden");
                $displayYears.html(parts[0]);
                $displayMonths.html(parts[1]);
                $displayDays.html(parts[2]);                 
            } else if(parts[1] > 0) {
                $month.removeClass("is-hidden");
                $displayMonths.html(parts[1]);
                $displayDays.html(parts[2]);                 
            } else {
                $displayDays.html(parts[2]);                 
            }
            $displayHrs.html(parts[3]);
            $displayMins.html(parts[4]);
            $displaySecs.html(parts[5]);             
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
             if(isVisible) {
                 isVisible = false;
                 $display.removeClass("tx-clr--slate");
                 $display.addClass("tx-clr--silver");
             } else {
                isVisible = true;
                $display.addClass("tx-clr--slate");
                $display.removeClass("tx-clr--silver");
             }
        }, 500);
    }
    
    function getCountdown(difference)  {
        if(stopped) {
            return;
        }
        var s = difference.years() + ":" + difference.months() + ":" + difference.days() + ":" + difference.hours() + ":" + difference.minutes() + ":" + difference.seconds();
        countdown = s;
        if(difference >= 0) {
            displayCountdown();
            difference = difference.subtract(1, 's');
        } else {
            stopped = true;
            endCountdown();
        }
        return difference;
    }
    
    function getReferences() {
        $countdownContainer = $(".zci--countdown").find(".countdown_container");
        $display            = $countdownContainer.find('.number');
        $displayYears       = $countdownContainer.find('.years');
        $displayMonths      = $countdownContainer.find('.months');
        $displayDays        = $countdownContainer.find('.days');
        $displayHrs         = $countdownContainer.find('.hours');
        $displayMins        = $countdownContainer.find('.minutes');
        $displaySecs        = $countdownContainer.find('.seconds');
        $year               = $countdownContainer.find(".year");
        $month              = $countdownContainer.find(".month");
    }
    
    DDH.countdown.build = function(ops) {
        var remainder    = ops.data.remainder,
            countdown_to = ops.data.countdown_to,
            duration;
        initialDifference = ops.data.difference;
        //console.log(ops.data.days1);
        return {
//             meta: {
//                 rerender: [
//                     'days','hours','minutes','seconds'
//                 ]
//             },
            data: {
                subtitle: "Countdown to " + countdown_to
            },
            templates: {
                group: 'text',
                options: {
                    title_content: DDH.countdown.countdown
                },
            },
            onShow: function() {
                if(hasShown) {
                    return;
                }
                hasShown = true;
                getReferences();
                DDG.require('moment.js', function() {
                    //console.log("initial diff " + initialDifference + "  " + isNaN(initialDifference) + "typeof " + typeof initialDifference);
                    var initialDifferenceDuration = moment.duration(initialDifference,'seconds');
                    console.log("initial duration " + initialDifferenceDuration);
                    duration = getCountdown(initialDifferenceDuration);
                    setInterval(function() {
                        duration = getCountdown(duration);
                    }, 1000);
                });
            }
//             onItemShown: function(item) {
//                 //item.set({ foo: bar, days: 34 })
//                 if(hasShown) {
//                     return;
//                 }
//                 hasShown = true;
//                 DDG.require('moment.js', function() {
//                     var initialDifferenceDuration = moment.duration(initialDifference,'seconds');
//                     console.log("initial diff "+initialDifferenceDuration);
//                     duration = initialDifferenceDuration;
//                     //duration = getCountdown(initialDifferenceDuration);
//                     //item.set({ days: duration.days(), hours: duration.hours(), minutes: duration.minutes(), seconds: duration.seconds() });
//                     setInterval(function() {
//                         duration = getCountdown(duration);
//                         item.set({ days: duration.days(), hours: duration.hours(), minutes: duration.minutes(), seconds: duration.seconds() });
//                     }, 1000);
//                 });
//                 item.set({ days: r.reviews });
//             }
        };
    };
})(DDH);
DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";
    var hasShown = false,
        countdown = "",
        initialDifference,
        $display,
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
            //displayCountdown();
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
    
    DDH.countdown.build_async = function(ops, DDH_async_add) {
        var remainder    = ops.data.remainder,
            countdown_to = ops.data.countdown_to,
            soundUrl     = 'share/goodie/countdown/' + ops.data.goodie_version + '/alarm.mp3',
            duration;

        initialDifference = ops.data.difference;
        DDG.require('moment.js', function() {
            duration = moment.duration(initialDifference,'seconds');            
            //duration = initialDifferenceDuration;
            DDH_async_add({
                meta: {
                    rerender: [
                        'year','month','day','hour','minute','second'
                    ]
                },
                data: {
                    year    : duration.years(),
                    month   : duration.months(),
                    day     : duration.days(),
                    hour    : duration.hours(),
                    minute  : duration.minutes(),
                    second  : duration.seconds(),
                    subtitle: "Countdown to " + countdown_to,
                },
                templates: {
                    group: 'text',
                    options: {
                        title_content: DDH.countdown.countdown
                    },
                },
                onItemShown: function(item) {
                    if(hasShown) {
                        return;
                    }
                    hasShown = true;                    
                    duration = getCountdown(duration);
                    item.set({ year: duration.years(), month: duration.months(), day: duration.days(), hour: duration.hours(), minute: duration.minutes(), second: duration.seconds() });
                    setInterval(function() {
                        duration = getCountdown(duration);
                        item.set({ year: duration.years(), month: duration.months(), day: duration.days(), hour: duration.hours(), minute: duration.minutes(), second: duration.seconds() });
                    }, 1000);
                }
            });
        });
    };
})(DDH);
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
        soundUrl,
        isVisible = true;

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
            $display = $(".zci--countdown").find(".countdown_container").find('.number');
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
            $display.toggleClass("tx-clr--silver");
        }, 500);
    }
    
    function getCountdown(difference)  {
        if(stopped) {
            return;
        }
        if(difference > 0) {
            difference = difference.subtract(1, 's');
        } else {
            stopped = true;
            endCountdown();
        }
        return difference;
    }
    
    DDH.countdown.build_async = function(ops, DDH_async_add) {
        var remainder    = ops.data.remainder,
            countdown_to = ops.data.countdown_to,
            soundUrl     = 'share/goodie/countdown/' + ops.data.goodie_version + '/alarm.mp3',
            input_date   = ops.data.input_date,
            duration;

        DDG.require('moment.js', function() {
            var now  = moment();
            var then = moment(input_date);

            initialDifference = then.diff(now,'seconds');
            if(initialDifference <= 0)
                return;

            duration = moment.duration(initialDifference,'seconds');

            DDH_async_add({
                id: 'countdown',   //class name of enclosing div is inferred as .zci--answer, without this
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

                    setInterval(function() {
                        duration = getCountdown(duration);
                        if(duration)
                            item.set({ year: duration.years(),
                                      month: duration.months(),
                                      day: duration.days(),
                                      hour: duration.hours(),
                                      minute: duration.minutes(),
                                      second: duration.seconds()
                                     });
                    }, 1000);
                }
            });
        });
    };
})(DDH);
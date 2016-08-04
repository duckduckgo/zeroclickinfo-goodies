DDH.what_does_dax_say = DDH.what_does_dax_say || {};

(function(DDH) {
    'use strict';
    
    var hasShown = false,
        cachedPlayer,
        soundIsPlaying = false,
        SOUND_NAME = "quack",
        soundUrl = 'share/goodie/what_does_dax_say/quack_by_dobroide.mp3';
    
    function play() {
        cachedPlayer.play(SOUND_NAME, soundUrl, {
            autoPlay: true
        });
    }

    function startAudio() {
        if (!cachedPlayer) {
            DDG.require('audio', function (player) {
                cachedPlayer = player;
                startAudio();
            });
            return;
        }
        // if a sound is already playing, stop for a moment
        // and then start again
        if (soundIsPlaying) {
            cachedPlayer.stop();
            setTimeout(startAudio(), 500);
            return;
        }
        // Play the sound
        play();
        soundIsPlaying = true;
    }
    
    DDH.what_does_dax_say.build = function(ops) {
        return {
            onShow: function() {
                if (hasShown) {
                    return;
                }
                hasShown = true;
                startAudio();
            }
        };
    };
})(DDH);
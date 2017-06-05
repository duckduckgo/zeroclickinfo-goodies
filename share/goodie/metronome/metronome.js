DDH.metronome = DDH.metronome || {};

(function(DDH) {
    "use strict";

    DDH.metronome = DDH.metronome || {};

    DDH.metronome.build = function(ops) {
        var metronomeIsOn,
            clickTrack;

        function playBeat() {
            var $dom = $(".zci--metronome");
            var clickSound= $dom.find(".audio_click")[0];

            var bpmInMs = getUserSetBPMAndConvertToMs();

            // Play the click sound at the specified bpms
            metronomeIsOn = true;
            clickTrack = setInterval(function() {
                clickSound.currentTime = 0;
                clickSound.play();
            }, bpmInMs);
        }

        function getUserSetBPMAndConvertToMs () {
            var $dom = $(".zci--metronome");
            var bpm = $dom.find(".bpm_slider").val();

            return 60000 / bpm;
        }

        function handleRangeSliderInput () { 
            adjustClickTrackBeatRate();
            updateBPMDisplay();
        }

        function adjustClickTrackBeatRate() {
            if (!metronomeIsOn) {
                return;
            }
            var $dom = $(".zci--metronome");
            var clickSound= $dom.find(".audio_click")[0];

            var bpmInMs = getUserSetBPMAndConvertToMs();

            clearInterval(clickTrack);
            clickTrack = setInterval(function() {
                clickSound.currentTime = 0;
                clickSound.play();
            }, bpmInMs);
        }

        function stopBeat() {
            metronomeIsOn = false;
            clearInterval(clickTrack);
        }

        function playOrStopBeat() {
            metronomeIsOn ? stopBeat(): playBeat();
        }

        function updateBPMDisplay() {
            var $dom = $(".zci--metronome");
            var bpm = $dom.find(".bpm_slider").val();
            $dom.find(".t-xxxl").val(bpm);
        }

        return {

            // Function that executes after template content is displayed
            onShow: function() {
                var $dom = $(".zci--metronome");
                $dom.find(".bpm_slider").on('input', handleRangeSliderInput);
                $dom.find(".ddgsi-play").click(playOrStopBeat);
            }
        };
    };
})(DDH);

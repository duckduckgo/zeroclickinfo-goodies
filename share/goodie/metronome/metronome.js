DDH.metronome = DDH.metronome || {};

(function(DDH) {
    "use strict";

    DDH.metronome = DDH.metronome || {};

    DDH.metronome.build = function(ops) {
        console.log("ops: " + JSON.stringify(ops));
        console.log("ops.data: " + JSON.stringify(ops.data));

        var metronomeIsOn,
            clickTrack;

        function playBeat() {
            var clickSound = document.getElementById("audioBeat");

            var bpmInMs = getUserSetBPMAndConvertToMs();

            // Play the click sound at the specified bpms
            metronomeIsOn = true;
            clickTrack = setInterval(function() {
                clickSound.currentTime = 0;
                clickSound.play();
            }, bpmInMs);
        }

        function getUserSetBPMAndConvertToMs () {
            var bpm = document.getElementById("bpmSlider").value;

            return 60000 / bpm;
        }

        // TODO: investigate listener/handler function naming convetions
        function handleRangeSliderInput () { 
            adjustClickTrackBeatRate();
            updateBPMDisplay();
        }

        function adjustClickTrackBeatRate() {
            if (!metronomeIsOn) {
                return;
            }
            var clickSound = document.getElementById("audioBeat");
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
            var bpm = document.getElementById("bpmSlider").value; 
            console.log("bpm is " + bpm);
            document.getElementById('displayBPM').value = bpm; 
        }

        return {

            // Function that executes after template content is displayed
            onShow: function() {

                $( '#playButton' ).click(playOrStopBeat);
                $('#bpmSlider').on('input', function () {
                    handleRangeSliderInput();
                });
                // define any callbacks or event handlers here
                //
                // var $dom = $(".zci--metronome");
                // $dom.find(".my-special-class").click(function(){
                //
                // });

            }
        };
    };
})(DDH);

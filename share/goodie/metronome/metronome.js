DDH.metronome = DDH.metronome || {};

(function(DDH) {
    "use strict";

    DDH.metronome = DDH.metronome || {};

    DDH.metronome.build = function(ops) {
        console.log("ops: " + JSON.stringify(ops));
        console.log("ops.data: " + JSON.stringify(ops.data));

        var metronomeIsOn,
            clickTrack;

        function bpmToMs(bpm) {
           return 60000/bpm;
        }

        function playBeat() {
            var clickSound = document.getElementById("audioBeat");

            // Get the user specified bpm and convert to ms
            var bpm = document.getElementById("slider").value;
            var bpmInMs = bpmToMs(bpm);
            console.log("user specified bpm is " + bpm + ", will click every " 
                    + bpmInMs + " ms.");

            //Play the click sound at the specified bpms
            console.log(clickSound.playbackRate)
            metronomeIsOn = true;
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

        return {

            // Function that executes after template content is displayed
            onShow: function() {

                $( '#playButton' ).click(playOrStopBeat);
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

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
            console.log("user specified bpm is " + bpm);
            var bpmInMs = bpmToMs(bpm);

            //Play the click sound at the specified bpms
            clickTrack = setInterval(function() {
                clickSound.play();
                metronomeIsOn = true;
                console.log("every second" + bpmInMs);
            }, bpmInMs);
        }

        function stopBeat() {
            clearInterval(clickTrack);
            metronomeIsOn = false;
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

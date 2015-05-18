DDH.music_maker = DDH.music_maker || {};

DDH.music_maker.build = function(ops) {

    DDG_MAX_HB_LOOP = 100;
    var _active = 0,
        _beats  = 24,
        _playing,
        _bpm,
        _ms_per_bar;

    // source: http://stackoverflow.com/a/23084015
    $.wait = function (ms) {
        var defer = $.Deferred();
        setTimeout(function() { defer.resolve(); }, ms);
        return defer;
    };

    function calc_mspb ($input, $display) {

        var val = $input.val();
        _bpm = val;
        $display.text(val);
        console.log("New tempo: " + val);

        var mspb = 1000 * 60 / _bpm;
        console.log("Mspb is: " + mspb);
        _ms_per_bar = mspb;
    }

    return {
        onShow: function() {

            // only run once
            if (_active) {
                return;
            } else {
                _active = 1;
            }

            DDG.require('audio', function() {
                var $dom      = $("#zci-music_maker"),
                    $cont     = $dom.find(".container"),
                    $beats    = $dom.find("td.beat"),
                    $tracks   = $dom.find("tr.track"),
                    $playBtn  = $dom.find("button.play"),
                    $stopBtn  = $dom.find("button.stop"),
                    $bpmInput = $dom.find("input.tempo"),
                    $tempo    = $dom.find("span.tempo--value");

                calc_mspb($bpmInput, $tempo);

                $playBtn.click(function(){
                    _playing = 1;
                    console.log("Playing...");
                    console.log("BPM is: " + _bpm);
                    console.log("MS per Beat is: " + _ms_per_bar);
                    $tracks.trigger("play");
                });

                $stopBtn.click(function(){
                    _playing = 0;
                    $beats.removeClass("highlight");
                    console.log("Stopping music");
                });

                $beats.click(function(){
                    $(this).toggleClass("selected");
                 });

                $bpmInput.change(function(){
                    calc_mspb($bpmInput, $tempo);
                });

                $tracks.on("play", function(event){
                    var $target = $(event.target),
                        $_beats = $target.children("td.beat"),
                        _length = $_beats.length,
                        _index  = 0,

                        play_beat = function(index){
                            setTimeout(function(){

                                console.log("Index: " + index);
                                var _beat = $_beats.get(_index);
                                $(_beat).addClass("highlight").trigger("play_beat");
                                _index++;

                                if (_index == _length && _playing){
                                    console.log("Restarting loop");
                                    _index = 0;
                                }

                                if (_playing){
                                    play_beat(_index);
                                }
                            }, _ms_per_bar);
                        };

                    // Make sure STOP hasn't been pressed
                    if (_playing){
                        play_beat(_index);
                    }
                });

                $beats.on("play_beat", function(event){
                    var $target = $(event.target);

                    if ( $target.hasClass("selected") ){
                        // play audio
                    }

                    setTimeout(function(){
                        $target.removeClass("highlight");
                    }, _ms_per_bar);
                });
            });
        }
    };
};
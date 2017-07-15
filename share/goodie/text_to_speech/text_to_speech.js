var voices = window.speechSynthesis.getVoices();

window.onload = function(){
    // If browser has speech synthesis show goodie
    if ('speechSynthesis' in window && voices.length > 0) {
       loadGoodie();
    }
}

function playAudio() {
    var msg = new SpeechSynthesisUtterance();
    msg.text = document.getElementById('text_to_audio__audio_text').value;
    // Note: some voices don't support altering params
    msg.voice = voices[document.getElementById('text_to_audio__voice_selection').value];
    msg.volume = document.getElementById('text_to_audio__volume_slider').value;
    msg.rate = document.getElementById('text_to_audio__rate_slider').value;
    msg.pitch = document.getElementById('text_to_audio__pitch_slider').value;
    window.speechSynthesis.speak(msg);
}

function loadGoodie() {
    // If goodie hasn't been injected into dom try again in 1 second
    document.getElementById('zci-text_to_speech') ? setupGoodie() : setTimeout(loadGoodie, 1000);
}

function setupGoodie() {
    // Add voice options
    for (var i = 0; i < voices.length; i++) {
        var select = document.getElementById('text_to_audio__voice_selection');
        select.options[select.options.length]= new Option(voices[i].name, i);
        if(voices[i].name=="english-us") select.selectedIndex = i;
    }

    // Display Goodie
    document.getElementById('zci-text_to_speech').style.display = 'block';

    // Play audio on button click
    document.getElementById("text_to_audio__play_audio").addEventListener("click", playAudio); 
}

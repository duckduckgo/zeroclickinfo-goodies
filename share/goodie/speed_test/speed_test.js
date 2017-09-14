var startDate;

function loadGoodie() {
    // If goodie hasn't been injected into dom try again in 1 second
    console.log("attempting to load");
    document.getElementById('speed_test__content') ? setupGoodie() : setTimeout(loadGoodie, 1000);
}

function setupGoodie() {
    var content = document.getElementById('speed_test__content');
    var src = document.getElementById('speed_test__status').getAttribute('test');
    var html = "<img id='speed_test__img' src='"+src+"'>";
    content.innerHTML = content.innerHTML + html;
    startDate = new Date();
    var img1 = document.getElementById('speed_test__img');
    if (img1.complete) loaded();
    else img1.addEventListener('load', loaded);
    img1.addEventListener('error', function() {
        document.getElementById("speed_test__status").innerHTML = "Error failed to test speed";
    });
}

function loaded() {
    var endDate = new Date();
    var timeDiff = endDate.getTime() - startDate.getTime();
    console.log("time diff = " + timeDiff);
    var secondsDiff = Math.round(timeDiff/1000);
    var speed = 98/secondsDiff + " mpbs";
    document.getElementById("speed_test__status").innerHTML = speed;
}

window.onload = function(){
    loadGoodie();
}

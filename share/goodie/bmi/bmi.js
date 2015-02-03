$(document).ready(function() {
    $('#form_bmi_m').on('submit', function(e) {
        e.preventDefault();
        h = $('#height').val();
        w = $('#weight').val();
        res = getBmi(h, w, 'metric');
        formatResult(res);
    });
    
    $('#form_bmi_i').on('submit', function(e) {
        e.preventDefault();
        h = $('#feet').val()*12;
        h += $('#inches').val()*1;
        w = $('#pounds').val();
        res = getBmi(h, w, 'imperial');
        formatResult(res);
    });
    
    $('.unit a').on('click', function(e) {
        e.preventDefault();
        $('#form_bmi_i, #form_bmi_m').toggle();
        $('.unit a').toggleClass('selected');
        $('#form_bmi_i input[type=number], #form_bmi_m input[type=number]').val('');
        $('#div_result').html('');
    });
});


function getBmi(h, w, unit) {
    if(unit == 'metric') {
        h = h/100;
        bmi = w / (h*h);
    }
    if(unit == 'imperial') { // yay murica!! let's use an obscure system nobody uses anymore just to make everything look bigger ;-)
        bmi = (w*703) / (h*h);  
    }
    bmi = Math.round(bmi*100)/100;
    return bmi;
}

function getRange(bmi) {
    if(bmi < 15) {
        range = "very severely underweight";
    }else if(bmi >= 15 && bmi < 16) {
        range = "severely underweight";
    }else if(bmi >= 16 && bmi < 18.5) {
        range = "underweight";
    }else if(bmi >= 18.5 && bmi < 25) {
        range = "normal";
    }else if(bmi >= 25 && bmi < 30) {
        range = "overweight";
    }else if(bmi >= 30 && bmi < 35) {
        range = "moderately obese";
    }else if(bmi >= 35 && bmi < 40) {
        range = "severely  obese";
    }else if(bmi >= 40) {
        range = "very severely obese";
    }
    return range;
}

function formatResult(bmi) {
    if(isNaN(bmi)){
        html = 'Error, your bmi is not a number, did you filled the fields?';
    }else{
        html = 'Your bmi is ' + bmi;
        html += '<br/>This is within the <b>' + getRange(bmi) + '</b> range';
        html += '<br/><small>source <a href="http://en.wikipedia.org/wiki/Body_mass_index">http://en.wikipedia.org/wiki/Body_mass_index</a></small>';
    }
    $('#div_result').html(html);
}

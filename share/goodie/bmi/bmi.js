DDH.bmi = DDH.bmi || {};

DDH.bmi.build = function(ops) {
    var text = ops.data.text;
 
    function getBmi(h, w, unit) {
        if(unit == 'metric') {
            h = h/100;
            bmi = w / (h*h);
        }
        if(unit == 'imperial') {
            bmi = (w*703) / (h*h);  
        }
        bmi = Math.round(bmi*100)/100;
        return bmi;
    }

    function getRange(bmi) {
        if(bmi < 15) {
            range = text.range[0];
        }else if(bmi >= 15 && bmi < 16) {
            range = text.range[1];
        }else if(bmi >= 16 && bmi < 18.5) {
            range = text.range[2];
        }else if(bmi >= 18.5 && bmi < 25) {
            range = text.range[3];
        }else if(bmi >= 25 && bmi < 30) {
            range = text.range[4];
        }else if(bmi >= 30 && bmi < 35) {
            range = text.range[5];
        }else if(bmi >= 35 && bmi < 40) {
            range = text.range[6];
        }else if(bmi >= 40) {
            range = text.range[7];
        }
        return range;
    }

    function formatResult(bmi) {
        if(isNaN(bmi)){
            html = text.error;
        }else{
            html = text.your_bmi + bmi;
            html += text.within + getRange(bmi) + text.str_range;
            html += text.source_line;
        }
        $('#div_result').html(html);
    }

    return {
         onShow: function() {
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
         } // ends onShow
    };
};
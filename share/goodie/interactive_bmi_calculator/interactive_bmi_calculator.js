DDH.interactive_bmi_calculator = DDH.interactive_bmi_calculator || {};
DDH.interactive_bmi_calculator.build = function(ops) {

    return {
        onShow: function(){
            var $height = $("#bmi_height");
            var $weight = $("#bmi_weight");

            $(".bmi_var").keydown(function(evt) {
                if (evt.keyCode === 13) { //Enter
                    var height = $height.val()? parseFloat($height.val()) : 0;
                    var weight = $weight.val()? parseFloat($weight.val()) : 0;
                    var bmi;

                    //Calculate BMI
                    if (height !== 0) {
                        bmi = weight / (height * height);
                    }

                    $("#bmi_result").val(bmi);
                }
            });
        }
    };
};

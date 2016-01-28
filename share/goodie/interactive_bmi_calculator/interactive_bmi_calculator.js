DDH.interactive_bmi_calculator = DDH.interactive_bmi_calculator || {};
DDH.interactive_bmi_calculator.build = function(ops) {

    return {
        onShow: function(){
            var $height = $("#bmi_height");
            var $weight = $("#bmi_weight");
            var is_metric = DDG.settings.get('kaj') === 'm';
            updateUnits();

            $(".bmi_var").keydown(function(evt) {
                $(this).removeClass("bmi_error");

                if (evt.keyCode === 13) { //Enter
                    var height = $height.val()? parseFloat($height.val()) : null;
                    var weight = $weight.val()? parseFloat($weight.val()) : null;
                    var error = "bmi_error";
                    var bmi;

                    //Calculate BMI
                    if ($.isNumeric(height) && $.isNumeric(weight) && height !== 0) {
                        
                        // When using imperial units the formula is slightly different
                        if (!is_metric) {
                            weight = weight * 703;
                        }
                        
                        bmi = weight / (height * height);
                        
                        // Truncate all decimal digits but the first
                        var bmi_arr = bmi.toString().split(".");
                        if (bmi_arr[1] && (bmi_arr[1].charAt(0) !== "0")) {
                            bmi = bmi_arr[0] + "." + bmi_arr[1].charAt(0);
                        } else {
                            bmi = bmi_arr[0];
                        }
                    } else {
                        if ((!$.isNumeric(height)) || (height === 0)) {
                            $height.addClass(error);
                        } 
                        
                        if (!$.isNumeric(weight)) {
                            $weight.addClass(error);
                        }
                    }

                    $("#bmi_result").text(bmi);
                }
            });

            $(".bmi_switch").click(function(evt) {
                is_metric = $(this).attr("id") === "bmi_metric";
                updateUnits();
                
                //Update settings in the cloud too
                DDG.settings.set('kaj', is_metric? 'm' : 'u', { saveToCloud: true });
            });

            function updateUnits() {
                var selected = "tx-clr--dk";
                var unselected = "tx-clr--lt";
                $("." + selected).removeClass(selected).addClass(unselected);

                var units = is_metric? "metric" : "imperial";
                $("#bmi_" + units).addClass(selected).removeClass(unselected);
                
                $(".bmi_text").addClass("hide");
                $("#bmi_weight_text_" + units + ", #bmi_height_text_" + units).removeClass("hide");
            }
        }
    };
};

DDH.interactive_bmi_calculator = DDH.interactive_bmi_calculator || {};
DDH.interactive_bmi_calculator.build = function(ops) {

    return {
        onShow: function(){
            var $height = $("#bmi_height");
            var $weight = $("#bmi_weight");
            var is_metric = DDG.settings.get('kaj') === 'm';
            updateUnits();

            $(".bmi_var").keydown(function(evt) {
                if (evt.keyCode === 13) { //Enter
                    var height = $height.val()? parseFloat($height.val()) : 0;
                    var weight = $weight.val()? parseFloat($weight.val()) : 0;
                    var bmi;

                    // When using imperial units the formula is slightly different
                    if (!is_metric) {
                        weight = weight * 703;
                    }

                    //Calculate BMI
                    if (height !== 0) {
                        bmi = weight / (height * height);
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
                var selected_class = "bmi_selected_switch";
                $("." + selected_class).removeClass(selected_class);

                var units = is_metric? "metric" : "imperial";
                $("#bmi_" + units).addClass(selected_class);
                
                $(".bmi_text").addClass("hide");
                $("#bmi_weight_text_" + units + ", #bmi_height_text_" + units).removeClass("hide");
            }
        }
    };
};

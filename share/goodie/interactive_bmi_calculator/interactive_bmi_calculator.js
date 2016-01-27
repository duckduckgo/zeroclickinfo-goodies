DDH.interactive_bmi_calculator = DDH.interactive_bmi_calculator || {};
DDH.interactive_bmi_calculator.build = function(ops) {

    return {
        onShow: function(){
            var $height = $("#bmi_height");
            var $weight = $("#bmi_weight");
            var is_metric = DDG.settings.get('kaj') === 'm';
            updateSwitches();

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

            $(".bmi_switch").click(function(evt) {
                is_metric = $(this).attr("id") === "bmi_metric";
                updateSwitches();
                
                //Update settings in the cloud too
                DDG.settings.set('kaj', is_metric? 'm' : 'u', { saveToCloud: true });
            });

            function updateSwitches() {
                var selected_class = "bmi_selected_switch";
                $("." + selected_class).removeClass(selected_class);

                var $active_switch = is_metric? $("#bmi_metric") : $("#bmi_imperial");
                $active_switch.addClass(selected_class);
            }
        }
    };
};

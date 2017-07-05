DDH.tips = DDH.tips || {};

(function(DDH) {
    "use strict";

    var initialized = false;
    var $dom, $inputs, $bill_input, $bill_tip, $bill_people, $tip_label, $total_label, $tip, $total, $tips_pp, $tips_labels;

    /*
     * setUpSelectors
     *
     * Sets up the jQuery selectors when the IA is built
     */
    function setUpSelectors() {
        $dom = $(".zci--tips");

        // the inputs
        $inputs = $dom.find('input');
        $bill_input = $dom.find("#bill_input");
        $bill_tip = $dom.find("#bill_tip");
        $bill_people = $dom.find("#bill_people");

        // the display labels
        $tip_label = $dom.find("#tip_label");
        $total_label = $dom.find("#total_label");
        $tip = $dom.find("#tip");
        $total = $dom.find("#total");
        $tips_pp = $dom.find(".tips__pp");
        $tips_labels = $dom.find(".tips__label h4");
    }

    /**
     * calculateTip
     *
     * Calculates the tip and sets the display
     */
    function calculateTip() {
        var bill_input = $bill_input.val();
        var bill_tip = $bill_tip.val();
        var bill_people = $bill_people.val();

        if(bill_input === "") {
            bill_input = 0;
        }

        var tip = bill_input * (bill_tip / 100);
        var tip_pp = tip / parseInt(bill_people);
        var total = parseFloat(bill_input) + tip;
        var total_pp = total / parseInt(bill_people);

        if(bill_people > 1) {
            $tips_pp.removeClass('hide');
            $tips_labels.addClass('tips__label--pp');
            $tip.text(tip_pp.toFixed(2));
            $total.text(total_pp.toFixed(2));
        } else {
            $tip_label.text("Tip");
            $tips_pp.addClass('hide');
            $tips_labels.removeClass('tips__label--pp');
            $total_label.text("Total");
            $tip.text(tip.toFixed(2));
            $total.text(total.toFixed(2));
        }

    }

    DDH.tips.build = function(ops) {

        // seed the tip calculator with some values
        var init_bill = ops.data.bill || "100";
        var init_percentage = ops.data.percentage || "20";

        return {
            onShow: function() {

                if(!initialized) {
                    setUpSelectors();
                    $bill_input.val(init_bill);
                    $bill_tip.val(init_percentage);
                    calculateTip()
                }

                /**
                 * Event handlers to update the values when
                 * keys are pressed
                 */
                $inputs.bind('keyup click change mousewheel', function(_e) {
                    calculateTip()
                });

                initialized = true;
            }

        };
    };
})(DDH);

DDH.tips = DDH.tips || {};

(function(DDH) {
    "use strict";

    var initialized = false;
    var $dom, $bill_input, $bill_tip, $bill_people, $tip_label, $tip, $total;

    /*
     * setUpSelectors
     * 
     * Sets up the jQuery selectors when the IA is built
     */
    function setUpSelectors() {
        $dom = $(".zci--tips");

        // the inputs
        $bill_input = $dom.find("#bill_input");
        $bill_tip = $dom.find("#bill_tip");
        $bill_people = $dom.find("#bill_people");

        // the display labels
        $tip_label = $dom.find("#tip_label");
        $tip = $dom.find("#tip");
        $total = $dom.find("#total");
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

        var tip = bill_input * (bill_tip / 100);
        var tip_pp = parseFloat(tip) / parseInt(bill_people);
        var total = parseFloat(bill_input) + parseFloat(tip);

        if(bill_people > 1) {
            $tip_label.text("Tips Per Person");
            $tip.text(tip_pp.toFixed(2));
        } else {
            $tip_label.text("Tip");
            $tip.text(tip.toFixed(2)); 
        }
        
        $total.text(total.toFixed(2));
    }

    DDH.tips.build = function(ops) {
        return {
            onShow: function() {
                DDG.require('math.js', function() {

                    if(!initialized) {
                        setUpSelectors();
                    }

                    $bill_input.keyup(function(_e) {
                        calculateTip()
                    });

                    $bill_tip.keyup(function(_e) {
                        calculateTip()
                    });

                    $bill_people.keyup(function(_e) {
                        calculateTip()
                    });

                    initialized = true;
                });
            }
        };
    };
})(DDH);
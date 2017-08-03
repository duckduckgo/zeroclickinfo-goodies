DDH.loan_calculator = DDH.loan_calculator || {};

(function(DDH) {
    "use strict";

    var init = false;
    var is_full_amount = true;
    var $inputs,
        $amount_input, 
        $period_input, 
        $interest_input, 
        $amount_output, 
        $repayable_output,
        $total_cost_output,
        $loan_selectors,
        $amount_label,
        $loan_bar_label;

    /*
     * setUpSelectors
     *
     * Sets up the jQuery selectors when the IA is built
     */
    function setUpSelectors() {
        var $local_dom = $(".zci--loan_calculator");

        // Input boxes
        $inputs = $local_dom.find("input"); // all of the below $*_input's
        $amount_input = $local_dom.find("#j-amount_input");
        $period_input = $local_dom.find("#j-period_input");
        $interest_input = $local_dom.find("#j-interest_input");

        // Display labels
        $amount_output = $local_dom.find("#j-amount_output");
        $repayable_output = $local_dom.find("#j-repayable_output");
        $total_cost_output = $local_dom.find("#j-total_cost_output");

        // Info labels
        $amount_label = $local_dom.find("#j-amount-info--label");
        $loan_bar_label = $local_dom.find("#j-loan_bar--info-label");

        // Type selector
        $loan_selectors = $local_dom.find(".loan_selector--radio");
    }

    function registerBehaviours() {
        $inputs.bind("keyup click change mousewheel", function(_e) {
            calculateLoanInfo();
        });

        $loan_selectors.click(function(_e) {
            if($('#loan_selector--radio-monthly').is(':checked')) {
                is_full_amount = false
                $amount_label.text("Monthly Repayment");
                $loan_bar_label.text("Loan amount available")
                $amount_input.val("250");
            } else {
                is_full_amount = true
                $amount_label.text("Amount");
                $loan_bar_label.text("Monthly Repayment")
                $amount_input.val("5000");
            }
        });
    }

    function calculateLoanInfo() {
        var amount = parseFloat($amount_input.val());
        var period = parseFloat($period_input.val());
        var interest = parseFloat($interest_input.val());

        if (is_full_amount === false) {
            var loan_available = calculateAmountBudget(amount, period, interest);
            var repayable = amount * period;
            var total_cost = (repayable - loan_available).toFixed(2);

            $amount_output.text(DDG.commifyNumber(loan_available));
        } else {
            var monthly_payment = calculateMonthlyPayment(amount, period, interest);
            var repayable = (monthly_payment * period).toFixed(2);
            var total_cost = (repayable - amount).toFixed(2);

            $amount_output.text(DDG.commifyNumber(monthly_payment));
        }

        if (isNaN(repayable) && isNaN(total_cost)) {
            repayable = 0;
            total_cost = 0;
        }
        
        $repayable_output.text(DDG.commifyNumber(repayable));
        $total_cost_output.text(DDG.commifyNumber(total_cost));

    }

   function calculateAmountBudget(principal, months, rate) {
        var payment = 0;
        var interest = rate / 1200;

        if (principal > 0 && months > 0) {
            if (rate != 0) {
                payment = principal / (interest / (1 - Math.pow((1 + interest), -(months))));
            } else {
                payment = principal * months; // 0% interest?
            }
        }
        return payment.toFixed(2);
    }

    function calculateMonthlyPayment(principal, months, rate) {
        var payment = 0;
        var interest = rate / 1200;

        if (principal > 0 && months > 0) {
            if (rate != 0) {
                payment = principal * (interest / (1 - Math.pow((1 + interest), -(months))));
            } else {
                payment = principal / months; // 0% interest?
            }
        }
        return payment.toFixed(2);
    }


    DDH.loan_calculator.build = function(ops) {

        return {

            meta: {},
            onShow: function() {
                if(!init) { 
                    setUpSelectors();
                    registerBehaviours();
                    calculateLoanInfo();
                }
                init = true;
            }
        };
    };
})(DDH);

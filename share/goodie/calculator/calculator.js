DDH.calculator = DDH.calculator || {};

(function(DDH) {
    "use strict";

    var usingState;
    var buttons, cButton;
    var currentDisplay; // pjh: refactor this out, it's not dry
    var OPERANDS = ["+", "-", "×", "÷"];
    var evaluatedExpression;
    
    var NOSHIFT_KEYCODES = {
        8: "C_OPT",
        13: "=",
        48: 0,
        49: 1,
        50: 2,
        51: 3,
        52: 4,
        53: 5,
        54: 6,
        55: 7,
        56: 8,
        57: 9,
        88: "×",
        106: "×",
        107: "+",
        109: "-",
        111: "÷",
        187: "=",
        191: "÷",
        188: ",",
        189: "-",
        190: "."
    }

    var SHIFT_KEYCODES = {
        48: ")",
        53: "%",
        56: "×",
        57: "(",
        187: "+"
    }


    function normalizeExpression( expression ) {
        var expression = expression;

        return expression
            .replace(/x/g, '*')
            .replace(/×/g, '*')
            .replace(/(\+) (\d+(\.\d{1,2})?)%/g, normalizeAddPercentage)
            .replace(/(\d+(\.\d{1,2})?) (\-) (\d+(\.\d{1,2})?)%/g, normalizeSubtractPercentage)
            .replace(/%/g,'/ 100')
            .replace(/[÷]/g,'/')
            .replace(/[,]/g,'')
    }


    // pjh: come back and refactor these two funcs into one.
    function normalizeAddPercentage( match, _operand, number ) {
        var percentage = parseInt(number);
        var base = 1;
        var divisible, remainder;
        var operator = "*";

        if(number < 99) {
            return operator + base + "." + number;
        } else {
            base += number / 100;
            remainder = number % 100;
            return operator + base + "." + remainder;
        }
    }


    function normalizeSubtractPercentage( match, fnumber, _op, operand, number ) {
        var firstNumber = parseInt(fnumber);
        var lastNumber = parseInt(number);
        return "-((" + fnumber + "*" + number + "/" + 100 + ") -" + fnumber + ")";
    }


    function formatOperands() {
        var x, y;
        if(display.value.length >= 2) {
            x = display.value[display.value.length-1];
            y = display.value[display.value.length-2];

            if($.inArray(x, OPERANDS) >= 0 && $.inArray(y, OPERANDS) >= 0){
                return false;
            } else {
                return true;
            } // if
        } // if
        return true;
    }


    function setExpression( expression ){
        expression = expression || "";
        evaluatedExpression.innerHTML = expression;
    }


    function setCButtonState( state ) {
        if(state === "C") {
            cButton.innerHTML = "C";
            cButton.value = "C";
            display.innerHTML = "0";
        } else if(state === "CE") {
            cButton.innerHTML = "CE";
            cButton.value = "CE";
        }
    }


    function calcUpdate( element ){
        var rewritten = false;
        usingState = true;

        // stops first entry being and operand, unless it's a -
        if(display.value.length === 0 && $.inArray(element, OPERANDS) > -1 && element !== "-") {
            return false;
        }

        // flips operator
        if(display.value.length > 2 && $.inArray(element, OPERANDS) > -1) {

            if($.inArray(display.value[display.value.length-2], OPERANDS) > -1) {
                display.value = display.value.substring(0, display.value.length - 2);
                rewritten = true;
            } // if

        }
        
        // stops %s / commas being entered first, or more than once
        if(element === "%" || element === ",") {
            if(display.value.length === 0) {
                return false;
            } else if(display.value.length >= 1) {
                if(!$.isNumeric(display.value[display.value.length-1]) || display.value[display.value.length-1] === ",") {
                    return false;
                }
            }
        } 


        // handles duplicate operands + ./%'s
        if(element === "." || $.inArray(element, OPERANDS) >= 0) {
            if(display.value.length >= 2) {
                if(element === display.value[display.value.length-3]) {
                    return false;
                }
            }
        }

        currentDisplay = display.value;

        if(element === "C_OPT" || element === "C" || element === "CE") {

            if(element === "C_OPT") {
                element = cButton.value;
            }

            if(element === "C" || display.value.length < 1 || usingState === false) {
                display.value = "";
                usingState = false;
                setExpression();
                setCButtonState("C");
            } else if(element === "CE" ) {

                if (display.value.length > 1 && display.value[display.value.length-2] !== " ") {
                    display.value = display.value.substring(0, display.value.length - 1);
                } else if(display.value.length > 1 && display.value[display.value.length-2] === " ") {
                    display.value = display.value.substring(0, display.value.length - 2);
                } else if (display.value.length === 1) {
                    display.innerHTML = "0";
                    setCButtonState("C");
                } else {
                    setCButtonState("C");
                    usingState = true;
                } // if

            } else {
                display.value = display.value.substring(0, display.value.length - 1);
            }

        } else if(element === "=") {

            try {
                var total = math.eval(
                    normalizeExpression(currentDisplay)
                ).toString();
            } catch(err) {
                console.log(err);
                display.innerHTML = "Error";
                display.value = "0";
                return;
            } // try / catch

            if(total === Infinity) {
                display.innerHTML = "Infinity";
                display.value = "0";
                return false;
            }

            setExpression(display.value);
            display.value = DDG.commifyNumber(total);
            setCButtonState("C");

        } else if(element !== undefined) {

            if(display.value === "0" && usingState === true && element === "0") {
                display.value = "";
            } else if (display.value === "-0"){
                display.value = "-";
                currentDisplay = display.value;
            } // else if

            // adds spaces into the display
            ($.inArray(element, OPERANDS) >= 0 && formatOperands() || rewritten)
                ? display.value = currentDisplay + " " + element + " " :
            display.value = currentDisplay + element;
            rewritten = false;

            if (display.value.length > 1) {
                setCButtonState("CE");
            }
        }// if / else block

        // sets the display
        (usingState
         ? display.innerHTML = display.value :
         display.innerHTML = "0");

    } // calcUpdate()


    DDH.calculator.build = function(ops) {

        var displayValue = (ops.data.title_html === "0" ? "" : ops.data.title_html);

        return {
            onShow: function() {

                var $calc = $(".zci--calculator");
                var $calcInputTrap = $calc.find(".tile__input-trap");

                function setFocus() {
                    $calcInputTrap.focus();
                }

                DDG.require('math.js', function() {

                    math.create({
                        number: 'BigNumber',
                        precision: 11
                    });

                    var display = $('#display')[0];
                    evaluatedExpression = $('#expression')[0];
                    cButton = $('#clear_button')[0];
                    buttons = $calc.find("button");
                    usingState = false;
                    display.value = displayValue;

                    buttons.click(function() {
                        calcUpdate(this.value);
                        setFocus();
                    });

                    $.each([$calc, $calcInputTrap], function(i,v) {
                        v.click(function(){
                            setFocus()
                        })
                    });

                    $calcInputTrap.keydown(function(e){
                        e.preventDefault();

                        var key = e.keyCode;
                        var evt = "";

                        if (!e.altKey && !e.shiftKey) {
                            evt = NOSHIFT_KEYCODES[key];
                        } else {
                            evt = SHIFT_KEYCODES[key];
                        }

                        calcUpdate(evt);
                        setFocus();
                        e.stopImmediatePropagation();
                    });
                }); // DDG.require('math.js')
                setFocus();
            }
        };
    };
})(DDH);
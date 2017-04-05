DDH.calculator = DDH.calculator || {};

(function(DDH) {
    "use strict";

    var CONSTANTS = ["e", "π"]
    var FUNCTIONS = ["log(", "ln(", "tan(", "cos(", "sin("];
    var MISC_FUNCTIONS = ["⋿⋿"];
    var OPERANDS = ["+", "-", "×", "÷"];
    var buttons, cButton;
    var evaluatedExpression;
    var evalmath;
    var usingState;
    var isExponential;
    
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
        69: "e",
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
        49: "!",
        53: "%",
        54: "<sup>□",
        56: "×",
        57: "(",
        69: "⋿⋿",
        187: "+"
    }
   
    function normalizeExpression( expression ) {
        var expression = expression;

        return expression
            // handles +/- percentages
            .replace(/(\+) (\d+(\.\d{1,2})?)%/g, normalizeAddPercentage)
            .replace(/(\d+(\.\d{1,2})?) (\-) (\d+(\.\d{1,2})?)%/g, normalizeSubtractPercentage)
            .replace(/%/g,'/ 100')
        
            // handles basic arithmetic
            .replace(/×/g, '*')
            .replace(/÷/g,'/')
            .replace(/,/g,'')
        
            // handles constants
            .replace(/π/g, 'pi')
        
            // handles exponentiation
            .replace(/<sup>2<\/sup>/g, '^2')
            .replace(/<sup>3<\/sup>/g, '^3')
            .replace(/<sup>(-?.?\d+(\.\d{1,2})?)<\/sup>/g, rewriteExponent)
            .replace(/(⋿⋿) (\d+(\.\d{1,2})?)/g, rewriteEE)
        
            // handles scientific calculation functions
            .replace(/log\((\d+(\.\d{1,2})?)\)/, rewriteLog10)
            .replace(/ln\(/g, 'log(')
            .replace(/(sin|cos|tan)\((\d+(\.\d{1,2})?)\)/g, rewriteTrig)
            .replace(/√\((\d+(\.\d{1,2})?)\)/, rewriteSquareRoot)
    }
    
    function rewriteTrig( _expression, func, number ) {
        if($('input#tile__ctrl__toggle-checkbox').is(':checked')) {
            return func + "(" + number + " deg)";
        } else {
            return func + "(" + number + ")";
        }
    }
    
    function rewriteExponent( _expression, number ) {
        return "^" + number;
    }
    
    function rewriteEE( _expression, _ee, exponent ) {
        return "* 10^" + number;
    }
    
    function rewriteSquareRoot( _expression, number ) {
        return "sqrt(" + number + ")";
    }
    
    function rewriteLog10( _expression, number ) {
        return "log(" + number + ", 10)";
    }

    // pjh: throw error if more than one percentage
    // pjh: come back and refactor these two funcs into one.
    function normalizeAddPercentage( match, _operand, number ) {
        var percentage = parseInt(number);
        var base = 1;
        var divisible, remainder;
        var operator = "*";

        if(number <= 99) {
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

            return !($.inArray(x, OPERANDS) >= 0 && $.inArray(y, OPERANDS) >= 0);
        }
        return true;
    }

    function setExpression( expression ){
        evaluatedExpression.innerHTML = expression || "";
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
            }

        }
        
        // stops %s / commas / custom exponents being entered first, or more than once
        if(element === "%" || element === "," || element === "<sup>2</sup>" || element === "<sup>3</sup>" || element === "<sup>□" || element === "!") {
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

                if (display.value.length > 1 && ($.inArray(display.value.substr(-4, 4), FUNCTIONS) >= 0 || $.inArray(display.value.substr(-3, 3), FUNCTIONS) >= 0)) {
                    display.value = display.value.substring(0, display.value.length - 4);
                } else if(display.value.length > 1 && display.value.substr(-6, 6) === "<sup>□") {
                    display.value = display.value.substring(0, display.value.length - 6);
                } else if(/<sup>\d{1}<\/sup>$/.test(display.value)) {
                    display.value = display.value.substring(0, display.value.length - 12);
                    display.value = display.value + "<sup>□";
                } else if(/<sup>\d+<\/sup>$/.test(display.value)) {
                    display.value = display.value.substring(0, display.value.length - 7);
                    display.value = display.value + "</sup>";
                } else if (display.value.length > 1 && display.value[display.value.length-2] !== " ") {
                    display.value = display.value.substring(0, display.value.length - 1);
                } else if(display.value.length > 1 && display.value[display.value.length-2] === " ") {
                    display.value = display.value.substring(0, display.value.length - 2);
                } else if (display.value.length === 1) {
                    display.innerHTML = "0";
                    setCButtonState("C");
                } else {
                    setCButtonState("C");
                    usingState = true;
                } 

            } else {
                display.value = display.value.substring(0, display.value.length - 1);
            }

        } else if(element === "=") {
            
            isExponential = false;

            try {
                var total = evalmath.eval(
                    normalizeExpression(display.value)
                ).toString();
            } catch(err) {
                console.log(err);
                display.innerHTML = "Error";
                display.value = "";
                return false;
            }

            if(total === Infinity) {
                display.innerHTML = "Infinity";
                display.value = "";
                return false;
            }

            setExpression(display.value);
            display.value = total;
            setCButtonState("C");

        } else if(element !== undefined) {

            if(display.value === "0" && usingState === true && element === "0") {
                display.value = "";
            } else if (display.value === "-0"){
                display.value = "0";
            }

            // formats the display
            if(element === "<sup>□" || element === "e<sup>□") {
                isExponential = true;
                display.value = display.value + element;
            } else if(isExponential === true && ($.inArray(element, OPERANDS) === -1 || element === "-")) {

                // need to check if last character is □
                if(display.value[display.value.length-1] === "□") {
                    display.value = display.value.substring(0, display.value.length - 1);
                    display.value = display.value + element + "</sup>";                    
                } else {
                    display.value = display.value.substring(0, display.value.length - 6);
                    display.value = display.value + element + "</sup>";
                }

            } else if(isExponential === true && $.inArray(element, OPERANDS) >= 0) {
                
                display.value = display.value + " " + element + " ";
                isExponential = false;
                    
            } else if( $.inArray(element, OPERANDS) >= 0 || $.inArray(element, CONSTANTS) >= 0 || $.inArray(element, MISC_FUNCTIONS) >= 0 && formatOperands() || rewritten) {
                display.value = display.value + " " + element + " ";
            } else if($.inArray(element, FUNCTIONS) >= 0) {
                display.value = display.value + " " + element;
            } else if(element === "!") {
                display.value = display.value + element + " "; 
            } else {
                display.value = display.value + element;   
            }
            
            
            rewritten = false;

            if (display.value.length > 1) {
                setCButtonState("CE");
            }
        }
        
        console.log(display.value); // remove for production
        // sets the display
        display.innerHTML = usingState ? display.value : "0";

    }

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

                    var display = $('#display')[0];
                    evaluatedExpression = $('#expression')[0];
                    cButton = $('#clear_button')[0];
                    buttons = $calc.find("button");
                    usingState = false;
                    display.value = displayValue;

                    evalmath = math.create({
                        number: 'BigNumber',
                        precision: 11
                    });

                    buttons.click(function() {
                        calcUpdate(this.value);
                        setFocus();
                    });

                    $.each([$calc, $calcInputTrap], function(i,v) {
                        v.click(function(){
                            setFocus()
                        })
                    });
                  
                    // tile__tab__sci
                    // tile__tab__basic
                    $("#sci-tab").click(function() {
                       $(".tile__calc .tile__tabs").css("left", "0");
                    });
                    
                    $("#basic-tab").click(function() {
                        $(".tile__calc .tile__tabs").css("left", "-310px");
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
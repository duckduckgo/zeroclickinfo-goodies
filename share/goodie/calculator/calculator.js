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
    var parenState = 0;
    var yRootState = false;
    
    /**
     * NOSHIFT_KEYCODES
     * 
     * This hash of keycodes represent the keys on the keyboard
     * which are used to determine input from a user. NOSHIFT comes
     * from the fact the user is not pressing the shift key on their
     * keyboard. We handle cases where the user is pressing the shift-<key>
     * in the SHIFT_KEYCODES hash.
     */
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

    /**
     * SHIFT_KEYCODES
     * 
     * This hash exists for user keypress that require the shift key
     * to be pressed.
     */
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
   
    /**
     * normalizeExpression
     * 
     * This Calculator IA leverages the open source math.js dependency. 
     * In light of this fact, we need to rewrite the final expression in
     * this calculator as a string parameter for the math.js .eval function
     * 
     * The inputted expression goes through a replace chain which have initially
     * been broken up into 5 stages:
     * 
     * 1. Handling +/- Percentage expressions. eg 10 + 10%, 55 - 4%
     * 2. Handling basic arithmetic. eg. 2 + 23, 2342 - 23, 99 * .5
     * 3. Handling constants. eg. π -> 3.14...
     * 4. Handling square roots. eg. 2^2, 23432^10000, 20^-.5
     * 5. Handles all other scientific formula such as logs.
     */
    function normalizeExpression( expression ) {

        return expression
            // 1. handles +/- percentages
            .replace(/(\+) (\d+(\.\d{1,2})?)%/g, PercentageNormalizer.addPercentage)
            .replace(/(\d+(\.\d{1,2})?) \- (\d+(\.\d{1,2})?)%/g, PercentageNormalizer.subtractPercentage)
            .replace(/%/g,'/ 100')
        
            // 2. handles basic arithmetic
            .replace(/×/g, '*')
            .replace(/÷/g,'/')
            .replace(/,/g,'')
        
            // 3. handles constants
            .replace(/π/g, 'pi')
        
            // 4. handles square roots
            .replace(/<sup>(\d+)<\/sup>√(\d+)/, RewriteExpression.yRoot)    
            .replace(/√\((\d+(\.\d{1,2})?)\)/, RewriteExpression.squareRoot)
        
            // 5. handles exponentiation
            .replace(/<sup>2<\/sup>/g, '^2')
            .replace(/<sup>3<\/sup>/g, '^3')
            .replace(/<sup>(-?.?\d+(\.\d{1,2})?)<\/sup>/g, RewriteExpression.exponent)
            .replace(/(⋿⋿) (\d+(\.\d{1,2})?)/g, RewriteExpression.ee)
        
            // 6. handles scientific calculation functions
            .replace(/log\((\d+(\.\d{1,2})?)\)/, RewriteExpression.log10)
            .replace(/ln\(/g, 'log(')
            .replace(/(sin|cos|tan)\((\d+(\.\d{1,2})?)\)/g, RewriteExpression.trig)
    }
    

    /**
     * RewriteExpression
     * 
     * The RewriteExpression object is for grouping together functions that
     * preprocess (rewrite) the query for the math.js eval function. They are
     * utilized exclusively by the normalizeExpression function. 
     */
    var RewriteExpression = {

        // ee: rewrites EE (Engineers Exponents) in the expression
        ee: function( _expression, _ee, exponent ) {
            return "* 10^" + exponent;
        },

        // exponent: rewrites the exponent(s) in given expression
        exponent: function( _expression, number ) {
            return "^" + number;
        },

        // log10: rewrites log (base 10) function(s) in the expression
        log10: function( _expression, number ) {
            return "log(" + number + ", 10)";
        },

        // squareRoot: rewrites square root expressions
        squareRoot: function( _expression, number ) {
            return "sqrt(" + number + ")";
        },

        // trig: rewrites trig functions to handle the different outputs (RAD | DEG)
        trig: function( _expression, func, number ) {
            if($('input#tile__ctrl__toggle-checkbox').is(':checked')) {
                return func + "(" + number + " deg)";
            } else {
                return func + "(" + number + ")";
            }
        },

        // yRoot: rewrites yth root of x expressions
        yRoot: function( _expression, y_root, x ) {
            return "nthRoot(" + x + ", " + y_root + ")";
        }
    }


    /**
     * PercentageNormalizer
     *
     * The PercentageNormalizer offers helper functions to rewrite percentage expressions.
     * Although unconventional, the user IS expecting a percentage of the original amount.
     * 
     * Example Queries
     *
     * 1. 10 + 10% -> 11, NOT 10.1
     * 2. 44 + 100% -> 88, NOT 45
     * 
     * TODO: Multiply by Percent.
     * TODO: Divide by Percent.
     */
    var PercentageNormalizer = {

        // addPercentage: takes a percentage expression and rewrites it.
        // eg. 10 + 10% --> 10 * 1.1, 44 + 100% --> 44 * 2.0
        // TODO: Make this function less verbose.
        addPercentage: function( _expression, _operand, number ) {
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
        },

        // subtractPercentage: takes a percentage expression and rewrites it
        // eg. 10 - 10% --> 10 -((10*10/100) -10) = 9, 45 - 50% --> 45 -((45*50/100) -45) = 22.5
        subtractPercentage: function( _expression, fnumber, _operand, number ) {
            return "-((" + fnumber + "*" + number + "/" + 100 + ") -" + fnumber + ")";
        }
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
        } else {
            cButton.innerHTML = "CE";
            cButton.value = "CE";
        }
    }
    
    // pjh: this function is what too big :-( going to have to cut it up
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
        if(element === "%" || element === "," || element === "<sup>2</sup>" || element === "<sup>3</sup>" || element === "<sup>□" || element === "!" || element === "⋿⋿" || element === "<sup>□</sup>√") {
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
        
        // forbids multiple . in one token
        if(element === ".") {
            var expression = display.value.split(" ");
            if(expression[expression.length-1].indexOf(".") > -1) { return false; }
        }
        
        if($.inArray(element, FUNCTIONS) >= 0) {
            parenState++;
        }
        
        if(element === ")" && parenState === 0) {
            return;
        } else if(element === ")" && parenState > 0) {
            parenState--;
        }
        
        if(element === "(") {
            parenState++;
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
                parenState = 0;
            } else if(element === "CE" ) {

                if(display.value.substr(-1, 1) === "(") {
                    display.value = display.value.substring(0, display.value.length - 2);
                    parenState--;
                } else if(display.value.substr(-1, 1) === ")") {
                    display.value = display.value.substring(0, display.value.length - 1);
                    parenState++;
                } else if (display.value.length > 1 && ($.inArray(display.value.substr(-4, 4), FUNCTIONS) >= 0 || $.inArray(display.value.substr(-3, 3), FUNCTIONS) >= 0)) {
                    display.value = display.value.substring(0, display.value.length - 4);
                } else if(display.value.length > 1 && $.inArray(display.value.substr(-2, 2).trim(), CONSTANTS) >= 0) {
                    display.value = display.value.substring(0, display.value.length - 2);
                } else if(display.value.length > 1 && display.value.substr(-3, 3) === "⋿⋿ ") {
                    display.value = display.value.substring(0, display.value.length - 3);
                } else if(display.value.length > 1 && display.value.substr(-6, 6) === "<sup>□") {
                    display.value = display.value.substring(0, display.value.length - 6);
                } else if(/<sup>□<\/sup>√\d+$/.test(display.value)) {
                    var expression = display.value.split(" ");
                    var last_element = expression.pop();
                    last_element = last_element.replace(/<sup>□<\/sup>√/g, "");
                    expression.push(last_element);
                    display.value = expression.join(" ");
                    yRootState = false;
                } else if(/<sup>\d{1}<\/sup>√\d+$/.test(display.value)) {
                    var expression = display.value.split(" ");
                    var last_element = expression.pop();
                    last_element = last_element.replace(/<sup>\d{1}<\/sup>/g, "<sup>□<\/sup>");
                    expression.push(last_element);
                    display.value = expression.join(" ");
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
                    display.value = "";
                    usingState = false;
                    setExpression();
                    setCButtonState("C");
                } else {
                    setCButtonState("C");
                    usingState = true;
                } 

            } else {
                display.value = display.value.substring(0, display.value.length - 1);
            }

        } else if(element === "=") {
            
            if(display.value === "") { return; } // stops error on immediate enter
            
            // trys to make an expression valid if it is missing parens
            if(parenState > 0) {
                display.value += ")".repeat(parenState);
                parenState = 0;
            }
            
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
            } else if(total === NaN || total === "NaN") {
                display.innerHTML = "Error";
                display.value = "";
                return false;
            }

            setExpression(display.value);
            
            display.value = total;
            setCButtonState("C");
            yRootState = false;
        } else if(element !== undefined) {

            if(display.value === "0" && usingState === true && element === "0") {
                display.value = "";
            } else if (display.value === "-0"){
                display.value = "0";
            }

            // formats the display
            // pjh: now for the hard part
            // yth Root of Number x
            if(yRootState === true && !$.inArray(element, OPERANDS) >= 0) {
                var expression = display.value.split(" ");
                var last_element = expression.pop();
                console.log("The last expression is: " + last_element);
                last_element = last_element.replace(/□/g, element);
                expression.push(last_element);
                display.value = expression.join(" ");
            } else if(element === "<sup>□</sup>√") {
                var expression = display.value.split(" ");
                var last_element = expression.pop();
                var y_root = "<sup>□</sup>√" + last_element;
                expression.push(y_root);
                display.value = expression.join(" ");
                yRootState = true
            } else if(element === "<sup>□" || element === "e<sup>□") {
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
        
        // this adds the pseudo brace at the end of the display
        if(parenState > 0) {
            var closingParens = ")".repeat(parenState);
            $(".tile__display__main").append("<span id='pseudoBrace'> " + closingParens + "</span>");
        }

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

                    if(DDG.device.isMobile || DDG.device.isMobileDevice) {
                        buttons.bind('touchstart', function(e) {
                            e.preventDefault();
                            calcUpdate(this.value);
                            setFocus();
                        });
                    } else {
                        buttons.bind('click', function() {
                            calcUpdate(this.value);
                            setFocus();
                        });              
                    }

                    $.each([$calc, $calcInputTrap], function(i,v) {
                        v.click(function(){
                            setFocus()
                        })
                    });
                  
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
            }
        };
    };
})(DDH);
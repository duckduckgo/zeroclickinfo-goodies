DDH.calculator = DDH.calculator || {};

(function(DDH) {
    "use strict";

    var usingState = false;
    var buttons;
    var currentDisplay; // pjh: refactor this out, it's not dry
    var operators = ["+", "-", "×", "÷"];
    var cButton;
    var evaluatedExpression;

    function normalizeExpression( expression ) {
        var expression = expression;

        return expression
            .replace(/x/g, '*')
            .replace(/×/g, '*')
            .replace(/\+ (\d+)%/g, '* 1.$1')
            .replace(/\- (\d+)%/g, '/ 1.$1')
            .replace(/%/g,'/ 100')
            .replace(/[÷]/g,'/')
            .replace(/[,]/g,'')
    }        

    // nothing experimental
    function setExpression( expression = "" ){
        evaluatedExpression.innerHTML = expression;
    } // setExpression()   
    
    
    function setCButtonState( state ) {
        if(state === "C") {
            cButton.innerHTML = "C";
            cButton.value = "C";
            display.innerHTML = "0";
        } else if(state === "CE") {
            cButton.innerHTML = "CE";
            cButton.value = "CE";
        }
    } // setCButtonState()
    
    
    function calcUpdate( element ){
        usingState = true;
        currentDisplay = display.value;

        if(element === "C_OPT" || element === "C" || element === "CE") {

            if(element === "C" || display.value.length < 1 || usingState === false) {
                display.value = "";
                usingState = false;
                setExpression();
                setCButtonState("C");
            } else if(element === "CE" ) {

                if (display.value.length > 1) {
                    display.value = display.value.substring(0, display.value.length - 1);
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
                );
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
            ($.inArray(element, operators) >= 0) 
                ? display.value = currentDisplay + " " + element + " " : 
            display.value = currentDisplay + element;

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
               
        return {
            onShow: function() {
                DDG.require('math.js', function() {

                    var $calc = $(".zci--calculator");
                    buttons = $calc.find("button");
                    var display = $('#display')[0];
                    display.value = "0";
                    evaluatedExpression = $('#expression')[0];
                    cButton = $('#clear_button')[0];
            
                    buttons.click(function() {
                        calcUpdate(this.value); 
                    });

                    $(document).on('keydown', function(e){

                        var key = e.keyCode;
                        
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
                            187: "=", // enter
                            88: "×",
                            191: "÷",
                            188: ",",
                            189: "-",
                            190: ".",
                        };
                        
                        var SHIFT_KEYCODES = {
                            187: "+",
                            56: "×",
                            53: "%",
                            57: "(",
                            48: ")"
                        }
                        
                        if (!e.altKey && !e.shiftKey) {
                            var evt = NOSHIFT_KEYCODES[key];
                        } else {
                            var evt = SHIFT_KEYCODES[key];
                        }
                   
                        calcUpdate(evt);

                    });

                    $calc.on("click", function(e) {
                        e.preventDefault();
                        $calc.focus();
                    });

                }); // DDG.require('math.js')
            }
        };
    };
})(DDH);
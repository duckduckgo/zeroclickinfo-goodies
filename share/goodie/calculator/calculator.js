DDH.calculator = DDH.calculator || {};

(function(DDH) {
    "use strict";

    DDH.calculator.build = function(ops) {
           
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
                .replace(/%/g,'/ 100')
                .replace(/[÷]/g,'/')
                .replace(/[,]/g,'')
        }        
        

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
                // TODO: replace with DDG.commifyNumber()
                display.value = DDG.commifyNumber(total);
                // display.value = total;

                setCButtonState("C");

            } else if(element !== undefined) {

                if(display.value === "0" && usingState === true && element === "0") {
                    display.value = "";
                } else if (display.value === "-0"){
                    display.value = "-";
                    currentDisplay = display.value;
                } // else if

                // adds spaces into the console
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

        return {
            onShow: function() {

                DDG.require('math.js', function() {

                    var $calc = $(".zci--calculator");
                    buttons = $("button");
                    var display = $('#display')[0];
                    display.value = "0";
                    evaluatedExpression = $('#expression')[0];
                    cButton = $('#clear_button')[0];
                    
                    for (var i = 0; i < buttons.length; i ++){
                        buttons[i].addEventListener("click", function(){ 
                            calcUpdate(this.value); 
                        });
                    }

                    $(document).on('keydown', function(e){

                        var keyID = e.which;
                        var keyValue;

                        if(e.shiftKey) {
                            switch(keyID)
                            {
                                case 187:
                                    keyValue = "+";
                                    break;
                                case 56:
                                    keyValue = "×";
                                    break;
                                case 53:
                                    keyValue = "%";
                                    break;
                                case 57:
                                    keyValue = "(";
                                    break;
                                case 48:
                                    keyValue = ")";
                                    break;
                            }
                        } else {
                            switch(keyID)
                            {
                                case 49:
                                    keyValue = 1;
                                    break;
                                case 50:
                                    keyValue = 2;
                                    break;
                                case 51:
                                    keyValue = 3;
                                    break;
                                case 52:
                                    keyValue = 4;
                                    break;
                                case 53:
                                    keyValue = 5;
                                    break;
                                case 54:
                                    keyValue = 6;
                                    break;
                                case 55:
                                    keyValue = 7;
                                    break;
                                case 56:
                                    keyValue = 8;
                                    break;
                                case 57:
                                    keyValue = 9;
                                    break;
                                case 48:
                                    keyValue = 0;
                                    break;
                                case 13:
                                    keyValue = "=";
                                    break;
                                case 187:
                                    keyValue = "=";
                                    break;
                                case 88:
                                    keyValue = "×";
                                    break;
                                case 191:
                                    keyValue = "÷";
                                    break;
                                case 188:
                                    keyValue = ",";
                                    break;
                                case 190:
                                    keyValue = ".";
                                    break;
                                case 189:
                                    keyValue = "-";
                                    break;
                                case 8:
                                    keyValue = "C_OPT";
                                    break;
                            }
                        }

                        calcUpdate(keyValue);

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
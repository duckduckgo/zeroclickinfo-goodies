DDH.calculator = DDH.calculator || {};

(function(DDH) {
    "use strict";

    DDH.calculator.build = function(ops) {
        return {

            onShow: function() {

                DDG.require('math.js', function() {

                    var display;
                    var buttons;
                    var currentDisplay;
                    var operators = ["+", "-", "%", "x", "×"];

                    function commatize(expression) {
                      expression += ''; // the expression that has been evaluated
                      var x = expression.split('.');

                      // temp vars
                      var x1 = x[0];
                      var x2 = x.length > 1 ? '.' + x[1] : '';
                      var rgx = /(\d+)(\d{3})/;

                      while (rgx.test(x1)) {
                        x1 = x1.replace(rgx, '$1' + ',' + '$2');
                      }

                      return x1 + x2;
                    }

                    function normalizeExpression(expression) {
                        var normalized;
                        var expression = expression;

                        normalized = expression
                                        .replace(/x/g, '*')
                                        .replace(/×/g, '*')
                                        .replace(/%/g,'/ 100')
                                        .replace(/[÷]/g,'/')
                                        .replace(/[,]/g,'')
                                        // scientific funcs, operators, constants
                                        // this is currently on hold
                                        .replace(/[π]/g,'(3.14159265359)')
                                        .replace(/(√)(\(\d+\))/g, 'sqrt($2)')
                                        .replace(/(log)(\(\d+\))/g, 'log($2, 10)')
                                        .replace(/(ln)(\(\d+\))/g, 'log($2)')
                                        .replace(/[e]/g, '(2.71828182846)')
                                        .replace(/<sup>2<\/sup>/gi, '^2')
                                        .replace(/<sup>3<\/sup>/gi, '^3');
                        return normalized;
                    }

                    function calcUpdate(element){
                        var currentClassName;
                        var elementValue = element;

                        var inputs = document.getElementsByTagName("button");
                        currentDisplay = display.value;


                        if(element === "C") {
                            display.value = "0";
                        // pjh: will implement later. this is tricky
                        // } else if(element === "inv") {
                        //     var temp = parseInt(display.input);
                        //     console.log(temp);
                        } else if(element === "CE") {
                            display.value = display.value.substring(0, display.value.length - 1);
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

                            display.value = commatize(total);

                            } else if(element !== undefined) {
                                if(display.value === "0"){
                                display.value = "";
                                currentDisplay = display.value;
                            } else if (display.value === "-0"){
                                display.value = "-";
                                currentDisplay = display.value;
                            } // else if

                            // adds spaces into the console
                            // pjh: BUG: '%' not being captured for some reason. to come back
                            ($.inArray(element, operators) >= 0) 
                                ? display.value = currentDisplay + " " + element + " " : 
                                  display.value = currentDisplay + element;

                        }

                        console.log(display.value + " = display value");
                        display.innerHTML = display.value;

                    }

                    display = document.getElementById('display');
                    buttons = document.getElementsByTagName("button");
                    display.value = "0";

                    for (var i = 0; i < buttons.length; i ++){
                        buttons[i].addEventListener("click", function(){ 
                            calcUpdate(this.value); 
                        });
                    }

                    window.onkeydown = function(e){
                      var keyID = e.which;
                      var keyValue;
                      
                      switch(keyID) {
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
                          keyValue = "+";
                          break;
                        case 189:
                          keyValue = "-";
                          break;
                        case 88:
                          keyValue = "×";
                          break;
                        case 191:
                          keyValue = "÷";
                          break;
                      }
                      calcUpdate(keyValue);

                      };

                }); // DDG.require('math.js')
            }
        };
    };
})(DDH);
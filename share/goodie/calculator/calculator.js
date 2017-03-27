DDH.calculator = DDH.calculator || {};

(function(DDH) {
    "use strict";

    // console.log('DDH.calculator.build'); // remove this before submitting pull request

    DDH.calculator.build = function(ops) {

        return {

            onShow: function() {

                DDG.require('math.js', function() {

                    var display;
                    var buttons;
                    var isEvaluated = true;
                    var currentDisplay;

                    function calcUpdate(element){
                        var currentClassName;
                        var elementValue = element;
                        isEvaluated = false;

                        var inputs = document.getElementsByTagName("button");
                        currentDisplay = display.value;

                        if(element === "C") {
                            display.value = "0";
                        } else if(element === "CE" && isEvaluated === false) {
                            display.value = display.value.substring(0, display.value.length - 1);
                        } else if(element === "=") {

                            // pjh: swap this out for something more elegant
                            try {
                                var total = math.eval(
                                    currentDisplay
                                    // basic operators / formatting
                                    .replace(/x/g, '*')
                                    .replace(/%/g,'/ 100')
                                    .replace(/[÷]/g,'/')
                                    .replace(/[,]/g,'')
                                    // scientific funcs, operators, constants
                                    .replace(/[π]/g,'(3.14159265359)')
                                    .replace(/(√)(\(\d+\))/g, 'sqrt($2)')
                                    .replace(/(log)(\(\d+\))/g, 'log($2, 10)')
                                    .replace(/(ln)(\(\d+\))/g, 'log($2)')
                                    .replace(/[e]/g, '(2.71828182846)')
                                    .replace(/<sup>2<\/sup>/gi, '^2')
                                    .replace(/<sup>3<\/sup>/gi, '^3')
                                    .replace(/(1\/)(\d+)/g, 'acoth($2)')
                                );        
                            } catch(err) {
                                console.log(err);
                                display.innerHTML = "Error";
                                display.value = "0";
                                return;
                            } // try / catch

                            if(total === Infinity) {
                                display.innerHTML = "Error";
                                display.value = "0";
                                return false;
                            }

                            display.value = total;

                            } else if(element !== undefined) {
                                if(display.value === "0"){
                                display.value = "";
                                currentDisplay = display.value;
                            } else if (display.value === "-0"){
                                display.value = "-";
                                currentDisplay = display.value;
                            } // else if

                            display.value = currentDisplay+element;

                        }

                        // console.log(display.value + " = display value");
                        display.innerHTML = display.value;
                        isEvaluated = true;

                    }

                    // pjh: fire when the calculator is first loaded.
                    display = document.getElementById('display');
                    buttons = document.getElementsByTagName("button");
                    display.value = "0";

                    // pjh: got to make sure this doesn't interfere with other buttons on page
                    for (var i = 0; i < buttons.length; i ++){
                        buttons[i].addEventListener("click", function(){ 
                            calcUpdate(this.value); 
                        });
                    }

                });
            }
        };
    };
})(DDH);
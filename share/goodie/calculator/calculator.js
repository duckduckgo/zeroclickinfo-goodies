DDH.calculator = DDH.calculator || {};

(function(DDH) {
    "use strict";

    // global function / operand constants
    var CONSTANTS = ["e", "π"]
    var FUNCTIONS = ["log(", "ln(", "tan(", "cos(", "sin("];
    var MISC_FUNCTIONS = ["EE"];
    var OPERANDS = ["+", "-", "×", "÷"];
    var POSTFIX = ["+", "-", "×", "÷", "%", "EE", "!", "<sup>2</sup>", "<sup>3</sup>", "<sup>□</sup>"]

    // global exponent constants
    var OPEN_SUP = "<sup>";
    var CLOSE_SUP = "</sup>";
    var OPEN_CLOSE_SUP = "<sup>□</sup>";

    // global variables
    var buttons, cButton;
    var evaluatedExpression;
    var usingState, evaluated;
    var isExponential;
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
        67: "C_OPT",
        69: "e",
        88: "×",
        106: "×",
        107: "+",
        109: "-",
        110: ".",
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
        54: OPEN_CLOSE_SUP,
        56: "×",
        57: "(",
        69: "EE",
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
     * 1. Handles natural language contained in search bar expressions
     * 2. Handling +/- Percentage expressions. eg 10 + 10%, 55 - 4%
     * 3. Handling basic arithmetic. eg. 2 + 23, 2342 - 23, 99 * .5
     * 4. Handling square roots. eg. 2^2, 23432^10000, 20^-.5
     * 5. Handles all other scientific formula such as logs.
     * 6. handles scientific functions such as ln, tan, cos, etc
     * 7. coverts constants. eg. π -> math.pi -> 3.14...
     * 8. tries to recover from user inputted faults (that make sense)
     */
    function normalizeExpression( expression ) {
        var expression = expression
        
            // 1. handles natural language
            .replace(/math/gi, '')
            .replace(/plus/g, '+')
            .replace(/minus/g, '-')
            .replace(/times/g, '*')
            .replace(/solve/gi, '')
            .replace(/what\s?is/gi, '')
            .replace(/calculator/gi, '')
            .replace(/divided\s?by/gi, '÷')
            .replace(/calculat(e|or)/gi, '')
            .replace(/squared/gi, '^2')
            .replace(/cubed/gi, '^3')
            // todo
            // .replace fact(orial)? ~~ rewrite
            // .replace sqrt

            // 2. handles +/- percentages
            .replace(/(\+) (\d+(\.\d{1,2})?)%/g, PercentageNormalizer.addPercentage)
            .replace(/(\d+(\.\d{1,2})?) - (\d+(\.\d{1,2})?)%/g, PercentageNormalizer.subtractPercentage)
            .replace(/(\d+(\.\d{1,2})?)%/g, PercentageNormalizer.soloPercentage)

            // 3. handles basic arithmetic
            .replace(/×/g, '*')
            .replace(/÷/g, '/')
            .replace(/,/g, '')

            // 4. handles square roots
            .replace(/<sup>(\d+)<\/sup>√(\d+)/, RewriteExpression.yRoot)
            .replace(/√\((\d+(\.\d{1,})?)\)/, RewriteExpression.squareRoot)

            // 5. handles exponentiation
            .replace(/<sup>2<\/sup>/g, '^2')
            .replace(/<sup>3<\/sup>/g, '^3')
            .replace(/<sup>(((-?(\d*.)?(\d+))|([πe(log|ln\(\d+\))]))+)<\/sup>/g, RewriteExpression.exponent)
            .replace(/(EE) (\d+(\.\d{1,})?)/g, RewriteExpression.ee)

            // 6. handles scientific calculation functions
            .replace(/log\((\d+(\.\d{1,})?)\)/, RewriteExpression.log10)
            .replace(/ln\(/g, 'log(')
            .replace(/(sin|cos|tan)\((.+)\)/g, RewriteExpression.trig)

            // 7. handles constants
            .replace(/π/g, '(pi)')
            .replace(/dozen/g, '12')

            // 8. last chance recovers
            .replace(/<sup>□<\/sup>/g, '')
        return expression;
    }

    /**
     * Utils (Utilities)
     *
     * The Utils Object provides a series of conveinance functions that return
     * truthy / string values for calculator based logic. This object is not designed
     * to record, manipulate or store state of any kind.
     *
     * The main goal of these utils are to:
     *
     * 1. Reduce jQuery / JavaScript boilerplate
     * 2. Condense verbose expressions (noisy code)
     *
     * TODO: Allow functions to accept lists as arguments in isSomething functions
     */
    var Utils = {

        // isNumber: returns a truthy value if it's a number
        // isNumber("100") --> true, isNumber("-132") --> true, isNumber("h") --> false
        isNumber: function( element ) {
            return $.isNumeric(element)
        },

        // checks if an element is an operand (ie +, -, *...)
        // isOperand("+") --> true, isOperand("u") --> false
        isOperand: function( element ) {
            return $.inArray(element, OPERANDS) >= 0;
        },

        // checks if parameter is a constant
        // isConstant("y") --> false, isConstant("e") --> true
        isConstant: function( element ) {
            return $.inArray(element, CONSTANTS) >= 0;
        },

        // checks if parameter is a math function. Named to be unambigious
        // isMathFunction("log(") --> true, isMathFunction("+") --> false
        isMathFunction: function( element ) {
            return $.inArray(element, FUNCTIONS) >= 0;
        },

        // check if parameter is a misc math function
        // isMiscMathFunction("e") --> false, isMiscMathFunction("EE") --> true
        isMiscMathFunction: function( element ) {
            return $.inArray(element, MISC_FUNCTIONS) >= 0;
        },

        // check if an element is a clear function
        // isClear("C") --> true, isClear("CE") --> true, isClear("4") --> false
        isClear: function( element ) {
            return element === "C_OPT" || element === "C" || element === "CE";
        },

        // check if a number is infinite
        // isInfinite("2034") --> false, isInfinite("898989898989^8989898998") --> true
        isInfinite: function( total ) {
            return total === Infinity;
        },

        // check if an input is NaN (Not a number). Also covers string based NaN
        // isNan("23") --> false, isNan("NaN") --> true
        isNan: function( total ) {
            return total === NaN || total === "NaN";
        },

        // checks if an input element is in the POSTFIX constant array
        // isPostfix("!") --> true, isPostfix("dax") --> false
        isPostfix: function( element ) {
            return $.inArray(element, POSTFIX) >= 0;
        }
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
            return "^(" + number + ")";
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
            var unit = ''
            if($('input#tile__ctrl__toggle-checkbox').is(':checked')) {
                unit = ' deg';
            }
            var wrappedNum = "(" + number + ")";
            return "round(" + func + "(" + wrappedNum + unit + "), 11)";
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
                // the ternary operator at the end is to account for single digit %s
                return operator + " " + base + "." + (number < 10 ? "0" + number : number);
            } else {
                base += number / 100;
                remainder = number % 100;
                return operator + " " + base + "." + remainder;
            }
        },

        // subtractPercentage: takes a percentage expression and rewrites it
        // eg. 10 - 10% --> 10 -((10*10/100) -10) = 9, 45 - 50% --> 45 -((45*50/100) -45) = 22.5
        subtractPercentage: function( _expression, fnumber, _operand, number ) {
            return "-((" + fnumber + "*" + number + "/" + 100 + ") -" + fnumber + ")";
        },

        // soloPercentage: takes a percent and returns it's decimal form
        // eg. 10% --> (10 / 100) = 0.1, 55% --> (55 / 100) = 0.55, 200% --> (200 / 100) = 2.0
        soloPercentage: function( _expression, percent ) {
            return "(" + parseInt(percent) / 100 + ")";
        }
    }

    /**
     * ExpressionParser
     *
     * The Expression Parser object contains functions that work exclusively on the
     * expression that is passed onto the math.js eval function.
     */
    var ExpressionParser = {

        // checks to see if last element, and element before that are operands
        // TODO: Rename this function.
        formatOperands: function() {
            if(display.value.length >= 2) {
                var x = display.value[display.value.length-1];
                var y = display.value[display.value.length-2];

                return !(Utils.isOperand(x) && Utils.isOperand(y));
            }
            return true;
        },

        // sets the expression on the calculators display, defaults to nothing
        setExpression: function( expression ){
            evaluatedExpression.innerHTML = expression || "";
        },

        // returns the current expressions length
        getExpressionLength: function() {
            return display.value.length;
        },

        // checks to see if expression is equal to the `count` param
        isExpressionLength: function( count ) {
            return display.value.length === count;
        },

        // backspace through the expression by `count` characters
        backspace: function( count ) {
            display.value = display.value.substring(0, display.value.length - count);
        }
    }

    /**
     * ParenManager
     *
     * Manages the paren state throughout the Instant Answer. When an opening
     * bracket is instanciated, a pseudo closing place is put into the display.
     * There are cases where the user doesn't bother to close the bracket themselves.
     * This object also provides expression parsing to recover from such instances.
     *
     * TODO: Support parens in an exponential state
     */
    var ParenManager = {

        // state: records the number of open parens
        normalTotal: 0,
        exponentTotal: 0,
        closingParens: ") ",
        template: null,

        // based on the state, it passes the increment state onto a helper function
        incrementTotal: function() {
            isExponential === true ? this.incrementExponentTotal() : this.incrementNormalTotal();
        },

        // based on the state, it passes the decrement state onto a helper function
        decrementTotal: function() {
            isExponential === true ? this.decrementExponentTotal() : this.decrementNormalTotal();
        },

        // increment the normal state
        incrementNormalTotal: function() {
            this.normalTotal++;
        },

        // decrements the normal state
        decrementNormalTotal: function() {
            this.normalTotal--;
        },

        // increment the exponent state
        incrementExponentTotal: function() {
            this.exponentTotal++;
        },

        // decrements the exponent state
        decrementExponentTotal: function() {
            this.exponentTotal--;
        },

        // returns the normal total
        getTotal: function() {
            return this.normalTotal;
        },

        // retuns the amount of open parens in an exponential state
        getExponentTotal: function() {
            return this.exponentTotal;
        },

        // resets the total back to 0
        reset: function() {
            this.normalTotal = 0;
        },

        // add pseudo paran at the end of the display
        pseudoBrace: function() {
            this.template = "<span class='pseudoBrace'> " + this.closingParens.repeat(this.normalTotal) + "</span>";
            isExponential === true ? $(".tile__display__main sup").append(this.template) : $(".tile__display__main").append(this.template);
        }
    }

    /**
     * Ledger
     *
     * The Ledger is the object responsible for persisting information, adding information into
     * the ledger / history section of the calculators UI and reloading it back into the calculator
     * if a user wants to work with the result.
     */
    var Ledger = {

        // addToHistory: adds expression and result to history and appends to list
        addToHistory: function( expression, result ) {
            // DDH.calculator.ledger_item is a ref to the ledger_item.handlebars template
            var ledger_item = DDH.calculator.ledger_item({expression: expression, result: result});
            $(".tile__history").prepend(ledger_item);
        },

        // reloadIntoCalc: reloads the clicked `<li>` into the calculator
        reloadIntoCalc: function( expression, result ) {
            ExpressionParser.setExpression(expression);
            display.value = result.replace(/,/g, '');
            display.innerHTML = result.replace(/,/g, '');
            usingState = false;
        }
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

    function evaluate() {
        if(display.value === "") { return; } // stops error on immediate enter

        // trys to make an expression valid if it is missing parens
        if(ParenManager.getTotal() > 0) {
            display.value += ")".repeat(ParenManager.getTotal());
            ParenManager.reset();
        }

        isExponential = false;

        try {
            var total = math.eval(
                normalizeExpression(display.value)
            ).toString()

        } catch(err) {
            display.value = "Error";
            ExpressionParser.setExpression();
            setCButtonState("C");
            return false;
        }

        if(Utils.isNan(total)) {
            display.value = "Error";
            setCButtonState("C");
            return false;
        }

        if(Utils.isInfinite(total)) {
            ExpressionParser.setExpression(display.value);
            Ledger.addToHistory(display.value, DDG.commifyNumber(total));
            display.value = "Infinity";
        } else {
            ExpressionParser.setExpression(display.value);
            Ledger.addToHistory(display.value, DDG.commifyNumber(total));
            display.value = total;
        }

        evaluated = true;
        setCButtonState("C");
        yRootState = false;
    }

    /**
     * Clear
     *
     * This fat function handles backspacing through the `display.value`. `display.value`
     * is the *string* representation of the expression that is used throughout the calculator.
     * It needs to take into consideration the key / button pressed and the state of the
     * calculator.
     *
     * A calculator has a lot of edge cases, many of which are hard to account for in
     * advance. Many of these hueristics were developed through trail and error and
     * logical deduction.
     *
     * TODO: Refactor nested ifs. What is the best way to do this and handle edge cases?
     */
    function clear( element ) {

        // if the C_OPT key was pressed on the keyboard, default to clear state of
        // the calculator that it's already in.
        if(element === "C_OPT") {
            element = cButton.value;
        }

        // if C, clear the UI, reset the using state and `display.value`
        if(element === "C" || display.value.length < 1 || usingState === false) {
            display.value = "";
            usingState = false;
            ExpressionParser.setExpression();
            setCButtonState("C");
            ParenManager.reset();

        // CE clears one step at a time base on the state and the length of expression
        } else if(element === "CE" ) {
            ExpressionParser.setExpression();

            // Backspace 4 if expression is greater than 1 and last part if a function
            if (ExpressionParser.getExpressionLength() > 1 && ( Utils.isMathFunction(display.value.substr(-4, 4)) || Utils.isMathFunction(display.value.substr(-3, 3)))) {
                ExpressionParser.backspace(4);
                ParenManager.decrementTotal();

            // if last element is an open paren, backspace 1
            } else if(display.value.substr(-1, 1) === "(") {
                ExpressionParser.backspace(1);
                ParenManager.decrementTotal();

            // if there is an operand in the second last character in expression, backspace 3
            } else if (ExpressionParser.getExpressionLength() > 1 && Utils.isOperand(display.value.substr(-2, 2)) ) {
                ExpressionParser.backspace(3);

            // if there is an operand in the last character in expression, backspace 2
            } else if (ExpressionParser.getExpressionLength() > 1 && Utils.isOperand(display.value.substr(-1, 1)) ) {
                ExpressionParser.backspace(2);

            // if last element is a closed paren, backspace 1
            } else if(display.value.substr(-1, 1) === ")") {
                ExpressionParser.backspace(1);
                ParenManager.incrementTotal();

            // Backspace 2 if the last 2 characters are a constant (pi, e)
            } else if(ExpressionParser.getExpressionLength() > 1 && Utils.isConstant(display.value.substr(-2, 2).trim()) ) {
                ExpressionParser.backspace(2);

            // Backspace 3 if last characters are `EE `
            } else if(ExpressionParser.getExpressionLength() > 1 && display.value.substr(-3, 3) === "EE ") {
                ExpressionParser.backspace(3);

            // If last 12 characters are `<sup>□</sup>`, backspace 12
            } else if(ExpressionParser.getExpressionLength() > 1 && display.value.substr(-12, 12) === OPEN_CLOSE_SUP) {
                ExpressionParser.backspace(12);
                isExponential = false;

            // ~~ nth square root ~~
            // if nth square root with no digits, pop last element, replace with nothin and re-append popped element
            } else if(/<sup>□<\/sup>√\d+$/.test(display.value)) {
                var expression = display.value.split(" ");
                var last_element = expression.pop();
                last_element = last_element.replace(/<sup>□<\/sup>√/g, "");
                expression.push(last_element);
                display.value = expression.join(" ");
                yRootState = false;

            // if nth square root with 1 digit, pop last element, replace with `<sup>□</sup>`, reappend popped element
            } else if(/<sup>\d{1}<\/sup>√\d+$/.test(display.value)) {
                var expression = display.value.split(" ");
                var last_element = expression.pop();
                last_element = last_element.replace(/<sup>\d{1}<\/sup>/g, OPEN_CLOSE_SUP);
                expression.push(last_element);
                display.value = expression.join(" ");

            // if ends with `<sup>□</sup>`, backspace 12
            } else if(/<sup>\d{1}<\/sup>$/.test(display.value)) {
                ExpressionParser.backspace(12);
                display.value = display.value + OPEN_CLOSE_SUP;

            // if `<sup></sup>` has numbers, backspace through the last number and reappend `</sup>`
            } else if(/<sup>\d+<\/sup>$/.test(display.value)) {
                ExpressionParser.backspace(7);
                display.value = display.value + CLOSE_SUP;

            // backspace 2 if last char is ` ` and 2nd last char is numeric
            } else if(ExpressionParser.getExpressionLength() > 1 && (display.value[display.value.length-1] === " " && Utils.isNumber(display.value[display.value.length-2]))) {
                ExpressionParser.backspace(2);

            // backspace 1 if 2nd last char is not equal to ` `
            } else if (ExpressionParser.getExpressionLength() > 1 && display.value[display.value.length-2] !== " ") {
                ExpressionParser.backspace(1);

            // backspace 2 if 2nd last char is ` ` and 3rd last is an operand (+, -, x, etc)
            } else if(ExpressionParser.getExpressionLength() > 1 && (display.value[display.value.length-2] === " " && Utils.isOperand(display.value[display.value.length-3]))) {
                ExpressionParser.backspace(2);

            // if 2nd last char is ` `
            } else if(ExpressionParser.getExpressionLength() > 1 && display.value[display.value.length-2] === " ") {
                ExpressionParser.backspace(1);

            // if expression length is 1, then reset the display value and expression, and set cButton to state `C`
            } else if (ExpressionParser.getExpressionLength() === 1) {
                display.value = "";
                usingState = false;
                ExpressionParser.setExpression();
                setCButtonState("C");
            } else {
                setCButtonState("C");
                usingState = true;
            }

        } else {
            // if all else fails, back space 1
            ExpressionParser.backspace(1);
        }

    }

    /**
     * ~~ THE MAIN ENTRY POINT ~~
     * calculator
     *
     * The main entry point to the calculators logic. This function looks to
     * provide immediate validation for the users input and pass onto the appropriate
     * objects and functions.
     */
    function calculator( element ){
        var rewritten = false;

        // resets the display
        if(display.value === "Error" || display.value === "Infinity") {
            display.value = "";
        }

        // handles the display like a normal calculator
        // If a new number / function / clear, bail and start new calculation
        if(evaluated === true && (Utils.isNumber(element) || Utils.isMathFunction(element) || Utils.isConstant(element) || Utils.isClear(element)) ) {
            ExpressionParser.setExpression("Ans: " + display.value);
            display.value = "";
            usingState = false;
            evaluated = false;
        // if evaluated and new input is a postfix operand, continue on.
        } else if(evaluated === true && !Utils.isPostfix(element)) {
            return false;
        } else {
            evaluated = false;
        }

        usingState = true;

        // stops first entry being and operand, unless it's a -
        if(display.value.length === 0 && Utils.isOperand(element) && element !== "-") {
            return false;
        }

        // if in the exponential state and the user inputs `(` or a function, then bail
        // TODO: Support parens and functions in exponents. This is really, really hard - @pjhampton
        if( isExponential && (element === "(" || Utils.isMathFunction(element)) ) {
            return false;
        }

        // opens pseudo paren for 1/(x)
        if(element === "1/(") {
            ParenManager.incrementTotal();
        }

        // flips operator
        if(display.value.length > 2 && Utils.isOperand(element)) {

            if($.inArray(display.value[display.value.length-2], OPERANDS) > -1) {
                display.value = display.value.substring(0, display.value.length - 2);
                rewritten = true;
            }
        }

        // stops %s / commas / custom exponents being entered first, or more than once
        if(element === "%" || element === "," || element === "<sup>2</sup>" || element === "<sup>3</sup>" || element === "<sup>□</sup>" || element === "EE" || element === "<sup>□</sup>√") {
            if(display.value.length === 0) {
                return false;
            } else if(display.value.length >= 1) {
                if( ( !Utils.isNumber(display.value[display.value.length-1]) && !Utils.isConstant(display.value[display.value.length-1]) ) || display.value[display.value.length-1] === ",") {
                    return false;
                }
            }
        }
        
        // Factorials (!) shouldn't follow an operand
        if(element === "!" && ( Utils.isOperand(display.value[display.value.length-1]) || Utils.isOperand(display.value[display.value.length-2]) )) {
            return false;
        }

        // forbids multiple . in one token
        if(element === ".") {
            var expression = display.value.split(" ");
            if(expression[expression.length-1].indexOf(".") > -1) { return false; }
        }

        // if element is math function or square root, increment paren total
        if(Utils.isMathFunction(element) || element === "√(") {
            ParenManager.incrementTotal();
        }

        if(element === ")" && ParenManager.getTotal() === 0) {
            return false;
        } else if(element === ")" && ParenManager.getTotal() > 0) {
            ParenManager.decrementTotal();
        }

        // if element is `(` increment the state in the paren manager
        if(element === "(") {
            ParenManager.incrementTotal();
        }

        if(element === "C_OPT" || element === "C" || element === "CE") {

            clear(element);

        } else if(element === "=") {

            evaluate();

        } else if(element !== undefined) {

            if(display.value === "0" && usingState === true && element === "0") {
                display.value = "";
            } else if (display.value === "-0"){
                display.value = "0";
            }

            // formats the display
            // yth Root of Number x
            if(yRootState === true && !Utils.isOperand(element)) {
                var expression = display.value.split(" ");
                var last_element = expression.pop();
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
            } else if(element === OPEN_CLOSE_SUP || element === "e<sup>□</sup>") {
                isExponential = true;
                display.value += element;
            } else if(isExponential === true && (!Utils.isOperand(element) || element === "-")) {

                // need to check if last character is □
                if(display.value.substr(-12, 12) === OPEN_CLOSE_SUP) {
                    display.value = display.value.substring(0, display.value.length - 7);
                    display.value += element + "</sup>";
                } else {
                    display.value = display.value.substring(0, display.value.length - 6);
                    display.value += element + "</sup>";
                }

            } else if(isExponential === true && (Utils.isOperand(element) || Utils.isConstant(element))) {

                display.value += " " + element + " ";
                isExponential = false;

            } else if( Utils.isOperand(element) || (Utils.isConstant(element) && Utils.isOperand(display.value[display.value.length-1])) || Utils.isMiscMathFunction(element) && ExpressionParser.formatOperands() || rewritten) {
                display.value += " " + element + " ";

            } else if(Utils.isMathFunction(element)) {
                display.value += " " + element;
            // if factorial and last element `!`, pop last character and append 1 blank space
            } else if(element === "!" && display.value[display.value.length-2] === "!") {
                display.value = display.value.substring(0, display.value.length - 1);
                display.value += element + " ";
            // if factorial append 1 blank space
            } else if(element === "!") {
                display.value += element + " ";
            } else {
                display.value += element;
            }

            rewritten = false;

            if (display.value.length > 1) {
                setCButtonState("CE");
            }
        }

        // sets the display
        display.innerHTML = usingState ? display.value : "0";

        // this adds the pseudo brace at the end of the display
        if(ParenManager.getTotal() > 0) {
            ParenManager.pseudoBrace();
        }

    }
    
    /**
     * calculateFromSearchBar
     * 
     * If a calculation has been provided in the search bar, then it should
     * pass the query to the calculator method.
     */
    function calculateFromSearchBar(query) {
        calculator(query);
        calculator("=");
    }
    
    /**
     * setDisplayToZeroOnStart
     * 
     * If no expression has been passed to the calculator, it sets the value to
     * nothing and displays a zero.
     */
    function setDisplayToZeroOnStart() {
        display.innerHTML = "0";
        display.value = "";
    }

    DDH.calculator.build = function(ops) {

        var displayValue = (ops.data.query === null) ? "0" : "";
        var processedQuery = ops.data.query; // if there was an expression in the query

        return {
            signal: "high",
            onShow: function() {

                var $calc = $(".zci--calculator");
                var $calcInputTrap = $calc.find(".tile__input-trap");

                function setFocus() {
                    $calcInputTrap.focus();
                }

                DDG.require('math.js', function() {

                    var display = $('#display')[0];
                    var deviceType;
                    evaluatedExpression = $('#expression')[0];
                    cButton = $('#clear_button')[0];
                    buttons = $calc.find("button");
                    usingState = false;
                    display.value = displayValue;

                    /**
                     * Bind the buttons
                     *
                     * Based on the type of device the user is searching on, the calculator
                     * buttons will be bound differently.
                     *
                     * Mobile -> touchstart (event fired when a touch point is placed on a touch surface)
                     * Desktop / Laptop -> click (event fired when a mouse is clicked on screen)
                     */
                    if(DDG.device.isMobile || DDG.device.isMobileDevice) {
                        // mobile
                        deviceType = 'touchstart';
                    } else {
                        // everything else
                        deviceType = 'click';
                    }

                    buttons.bind(deviceType, function(e) {
                        e.preventDefault();
                        calculator(this.value);
                        setFocus();
                    });

                    /**
                     * Sets focus when the calculator is clicked
                     *
                     * Sets the focus on the calculator when the Instant answer is first opened.
                     */
                    $.each([$calc, $calcInputTrap], function(i,v) {
                        v.click(function(){
                            setFocus()
                        })
                    });

                    /**
                     * Swaps out the keyboards on a mobile device
                     *
                     * The calculator has a collapsed view when the user is viewing the device
                     * on a mobile device. The following two functions handle the touch events.
                     */
                    $('.tile__options .tile__option span').click(function(e) {
                        var $tabHandle = $(this).parent();
                        if ($tabHandle.hasClass('tile__option--active')) {
                            return;
                        }

                        $('.tile__options .tile__option').removeClass('tile__option--active');

                        $tabHandle.toggleClass('tile__option--active');

                        var activeTab = $('.tile__options .tile__option.tile__option--active').data('tab');

                        $('.tile__tabs')
                            .removeClass(function (index, css) {
                                return (css.match(/(^|\s)tile__tabs--single-[a-z]+/g) || []).join(' ');
                            })
                            .addClass('tile__tabs--single-'+activeTab);
                    });

                    /**
                     * Listens for key presses on keyboard
                     *
                     * If a key is pressed the below code is fired and the key reference
                     * is looked up in the NOSHIFT_KEYCODES and SHIFT_KEYCODES hashes.
                     */
                    $calcInputTrap.keydown(function(e){
                        e.preventDefault();

                        var key = e.keyCode;
                        var evt = "";

                        if (!e.altKey && !e.shiftKey) {
                            evt = NOSHIFT_KEYCODES[key] ||
                                  // subtract 48 for numpad keys in certain browser (e.g. Safari)
                                  NOSHIFT_KEYCODES[key - 48];
                        } else {
                            evt = SHIFT_KEYCODES[key];
                        }

                        if(evt === undefined) {
                            return false;
                        }

                        calculator(evt);
                        setFocus();
                        e.stopImmediatePropagation();
                    });

                    /**
                     * Handles clicking on history items
                     *
                     * If an item is clicked in the ledger section, the expression and result are loaded
                     * and passed to the Ledger object where it resets the calculators state and result
                     */
                    $(".tile__history").on('click', '.tile__past-calc', function() {
                        var expression = $(this).find("span.tile__past-formula").html();
                        var result = $(this).find("span.tile__past-result").text();
                        Ledger.reloadIntoCalc(expression, result);
                    });
                    
                    /**
                     * If the data coming from the perl backend isn't a 0, then
                     * we try to evaluate the expression, else we set the calculator
                     * to 0.
                     */
                    if(displayValue !== "0") {
                        calculateFromSearchBar(processedQuery);
                    } else {
                        setDisplayToZeroOnStart()
                    }

                }); // DDG.require('math.js')
            }
        };
    };
})(DDH);

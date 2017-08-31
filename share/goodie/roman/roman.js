DDH.roman = DDH.roman || {};

(function(DDH) {
    "use strict";
    
    /* Reference: https://en.wikipedia.org/wiki/Roman_numerals
     * Inputs can be between 1 and 3999.
     * We rely on the substractive notation.
     */
    
    var romanTable = {
        'I': 1,
        'V': 5,
        'X': 10,
        'L': 50,
        'C': 100,
        'D': 500,
        'M': 1000
    };
    
    /* The arabicTable is used to convert an arabic digit into roman characters.
     * The field 'before' contains the substractive notation.  Hence, we need 
     * specific cases when converting to roman notation for the digits 4 and 9.
     */
    
    var arabicTable = {
        1: {digit: 'I', before: 'IV'},
        5: {digit: 'V'},
        10: {digit: 'X', before: 'XL'},
        50: {digit: 'L'},
        100: {digit: 'C', before: 'CD'},
        500: {digit: 'D'},
        1000: {digit: 'M'}
    };
    
    /* validationTable and conversionTable are used to avoid nested conditionals 
     * in the conversion process.
     */
    
    var validationTable = {
        'roman': isRoman,
        'arabic': isArabic
    };
    
    var rangeTable = {
        'roman': isRomanNumberInRange,
        'arabic': isArabicNumberInRange
    };
    
    var conversionTable = {
        'roman': { 'arabic': romanToArabic },
        'arabic': { 'roman': arabicToRoman }
    };
    
    /* Roman regular expression
     * 
     * It is composed of 4 blocks:
     *   - M{0,3} -> from M to MMM
     *   - (?:D?C{0,3}|C[DM]) -> from C to CM
     *   - (?:L?X{0,3}|X[LC]) -> from X to XC
     *   - (?:V?I{0,3}|I[VX]) -> from I to IX
     */
    
    function isRoman(input) {
        var r = /^M{0,3}(?:D?C{0,3}|C[DM])(?:L?X{0,3}|X[LC])(?:V?I{0,3}|I[VX])$/i;
        return input != '' && 
               input.match(r);
    }
    
    /* isRomanNumberInRange expects a non-null string representing a 
     * roman number.
     *
     * It always returns true because a valid roman number is in range.
     */
    
    function isRomanNumberInRange(input) {
        return true;
    }
    
    /* romanToArabic expects a non-null string representing a roman number.
     * 
     * The algorithm relies on the order of the characters.  If c is the 
     * current character, then there are two cases:  Either, c is smaller 
     * than the previous character we add the value of the roman character.
     * Or, c is greater than the previous character.  In this case, we are 
     * in a substractive notation context.  So we substract the previously
     * added value and we also substract the value of the previous value to
     * the value of the current character (hence the -2 * ...).
     * The first previous value is initialized to the greatest possible value,
     * 1000, to ensure the additive notation context at the beginning. 
     */
    
    function romanToArabic(roman) {
        var romanDigits = roman.toUpperCase().split('');
        var previousArabicValue = 1000;
        
        return romanDigits.reduce(function(acc, romanDigit) {
            var arabicValue = romanTable[romanDigit];
            var nextAcc = acc;
            
            if (arabicValue <= previousArabicValue) {
                nextAcc += arabicValue;
            } else {
                nextAcc += -2 * previousArabicValue + arabicValue;
            }
            previousArabicValue = arabicValue;
            
            return nextAcc;
        }, 0);
    }
    
    function isArabic(input) {
        return input != '0' && input.match(/\d+/);
    }
    
    /* isArabicNumberInRange expects an integer.
     * 
     * We limit the valid range to [1,3999] because the greatest roman
     * number represented by ascii characters is MMMCMXCIX (3999).
     */ 
    
    function isArabicNumberInRange(input) {
        var number = parseInt(input);
        return number >= 1 && number <= 3999;
    }
    
    /* arabicToRoman expects a non-null string composed of digits.
     * 
     * Because of the restriction on roman numbers, we limit arabic numbers to
     * 3999.
     * 
     * Arabic numbers use base 10 and can be expressed by the following 
     * expression n = a x 10^3 + b x 10^2 + c x 10 + d where a, b, c, d
     * are digits between 0 and 9.  Hence, we need to consider specific 
     * cases to convert to roman numbers.
     * The process goes from left to right.
     * If the value of the current digit is 4 or 9, we need to switch to 
     * the substractive notation.
     * If the value of the current digit is 5, we need to use the right 
     * component in the roman notation (V, L, D).
     * The remaining cases are straightforward.
     */
    
    function arabicToRoman(arabic) {
        var arabicValue = parseInt(arabic);
        var previousComponent;
        var romanDigits = '';
        
        var components = [1000, 100, 10, 1];
        for (var i = 0; i < components.length; i++) {
            var leftDigit = Math.floor(arabicValue / components[i]);

            if (leftDigit >= 1 && leftDigit <= 3) {
                var romanDigit = arabicTable[components[i]].digit.repeat(leftDigit);
                romanDigits += romanDigit;
            } else if (leftDigit == 4) {
                var romanDigit = arabicTable[components[i]].before;
                romanDigits += romanDigit;
            } else if (leftDigit == 5) {
                var romanDigit = arabicTable[components[i] * 5].digit;
                romanDigits += romanDigit;
            } else if (leftDigit >= 6 && leftDigit <= 8) {
                var romanDigit = arabicTable[components[i] * 5].digit;
                var end = arabicTable[components[i]].digit.repeat(leftDigit - 5);
                romanDigits += romanDigit + end;
            } else if (leftDigit == 9) {
                var romanDigit = arabicTable[previousComponent].digit;
                romanDigits += arabicTable[components[i]].digit + romanDigit;
            } else {
                /* if 0 then there is nothing to do. */
            }
            
            previousComponent = components[i];
            arabicValue -= components[i] * leftDigit;
        };
        
        return romanDigits;
    }
    
    function buildConverter(input, output) {        
        var $root = DDH.getDOM('roman');
        
        var $arabicWarning = $root.find('.converter__messages__arabic');
        var $romanWarning = $root.find('.converter__messages__roman');
       
        /* The following four closures capture the two previous DOM elements.
         * Hence, we build a warning table to display the right information.
         * Warnings are displayed by making the font weight bold and increasing
         * the font size. 
         */
        
        function raiseArabicWarning() {
            $arabicWarning.css('font-weight', 'bold');
            $arabicWarning.css('font-size', '1.5em');
        }
        
        function unraiseArabicWarning() {
            $arabicWarning.css('font-weight', 'normal');
            $arabicWarning.css('font-size', '1em');
        }
        
        function raiseRomanWarning() {
            $romanWarning.css('font-weight', 'bold');
            $romanWarning.css('font-size', '1.5em');
        }
        
        function unraiseRomanWarning() {
            $romanWarning.css('font-weight', 'normal');
            $romanWarning.css('font-size', '1em');
        }
        
        var raiseWarningTable = {
            'roman': raiseRomanWarning,
            'arabic': raiseArabicWarning
        };
        
        var unraiseWarningTable = {
            'roman': unraiseRomanWarning,
            'arabic': unraiseArabicWarning
        };
        
        return {
            inputLabel: DDG.capitalize(input),
            isInputValid: validationTable[input],
            isInputInRange: rangeTable[input],
            input: $root.find('.converter__input__field'),
            raiseInputWarning: raiseWarningTable[input],
            unraiseInputWarning: unraiseWarningTable[input],
            outputLabel: DDG.capitalize(output),
            isOutputValid: validationTable[output],
            isOutputInRange: rangeTable[output],
            output: $root.find('.converter__output__field'),
            raiseOutputWarning: raiseWarningTable[output],
            unraiseOutputWarning: unraiseWarningTable[output],
            inputToOutput: conversionTable[input][output],
            outputToInput: conversionTable[output][input]
        };
    }
    
    DDH.roman.build = function(ops) {
        var input = ops.data.input;
        var output = ops.data.output;
        var inputValue = ops.data.input_value;
        var outputValue = ops.data.output_value;

        /* State variables.
         * initiated: avoid init logic running multiple times.
         * warning: has a warning been raised?
         */ 
        
        var initiated = false;
        var warning = false;
        
        return {
            onShow: function() {
                /* Mechanism to avoid the init logic running multiple times. */
                if (initiated) {
                    return;
                }
                
                var $converter = buildConverter(input, output);
                
                $('.converter__input__label').html($converter.inputLabel);
                $('.converter__output__label').html($converter.outputLabel);
                $converter.input.val(inputValue);
                $converter.output.val(outputValue);
                
                /* Just in case the input provided by the server was out 
                 * of range.  In this case, we immediately raise a warning.
                 */
                
                if (! $converter.isInputInRange()) {
                    warning = true;
                    $converter.raiseInputWarning();
                }
                
                /* There are four cases to discriminate related to inputs.
                 * 
                 * - empty input
                 * - syntactically incorrect input
                 * - out of range input
                 * - valid input
                 */
                
                $converter.input.keyup(function (e) {
                    var input = $converter.input.val();
                    if (input == '') {
                        $converter.output.val('');
                    } else if (! $converter.isInputValid(input)) {
                        $converter.output.val('');
                    } else if (! $converter.isInputInRange(input)) {
                        warning = true;
                        $converter.output.val('');
                        $converter.raiseInputWarning();
                    } else {
                        if (warning) {
                            warning = false;
                            $converter.unraiseInputWarning();
                            $converter.unraiseOutputWarning();
                        }
                        var output = $converter.inputToOutput(input);
                        $converter.output.val(output);
                    }
                });
                
                $converter.output.keyup(function (e) {
                    var output = $converter.output.val();

                    if (output == '') {
                        $converter.input.val('');
                    } else if (! $converter.isOutputValid(output)) {
                        $converter.input.val('');
                    } else if (! $converter.isOutputInRange(output)) {
                        warning = true;
                        $converter.input.val('');
                        $converter.raiseOutputWarning();
                    } else {
                        if (warning) {
                            warning = false;
                            $converter.unraiseOutputWarning();
                            $converter.unraiseInputWarning();
                        }
                        var input = $converter.outputToInput(output);
                        $converter.input.val(input);
                    }
                });
                
                initiated = true;
            }
        };  
    };
    
})(DDH);
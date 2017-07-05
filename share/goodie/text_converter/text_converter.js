DDH.text_converter = DDH.text_converter || {};

(function(DDH) {
    "use strict";

    var initialized = false;

    // global DOM objects
    var $convert_button,
        $convert_from_select,
        $convert_to_select,
        $convert_from_textarea, 
        $convert_to_textarea;

    // TextConverter: A singleton object that performs all the text conversions
    var TextConverter = {

        convert: function() {
            var from_type = $convert_from_select.val();
            var to_type = $convert_to_select.val();
            var from = $convert_from_textarea.val();

            // We first need to convert the from type to ascii
            if(from_type !== "text") {
                 switch(from_type) {
                    case "binary":
                        from = TextConverter.binaryToText(from);
                        break;
                    case "decimal":
                        from = TextConverter.decimalToText(from);
                        break;
                    case "rot13":
                        from = TextConverter.rot13(from);
                        break;
                    case "base64":
                        from = TextConverter.base64Decoder(from);
                        break;
                    case "hexadecimal":
                        from = TextConverter.hexToText(from);
                        break;
                    default:
                        return from; // DEFAULT: return the original text
                }               
            }

            // then map it to the /to/ type
            switch(to_type) {
                case "binary":
                    return TextConverter.toBinary(from);
                    break;
                case "decimal":
                    return TextConverter.toDecimal(from);
                    break;
                case "rot13":
                    return TextConverter.rot13(from);
                    break;
                case "base64":
                    return TextConverter.base64(from);
                    break;
                case "hexadecimal":
                    return TextConverter.toHex(from);
                    break;
                default:
                    return from; // DEFAULT: return the original text
            }
        },

        /**
         * Binary Converter
         ********************************************
         *
         * Inputs text, Outputs Binary
         *
         */
        toBinary: function( text ) {
            var binary = "";

            for (var i=0; i < text.length; i++) {
                binary += text[i].charCodeAt(0).toString(2) + " ";
            }

            return binary
        },

        binaryToText: function( text ) {
            return text.split(/\s/).map(function (val) {
                return String.fromCharCode(parseInt(val, 2));
            }).join("");
        },

        /**
         * Decimal Converter
         ********************************************
         *
         * Inputs text, Outputs Decimal (Base 10)
         *
         */
        toDecimal: function( text ) {
            var decimal = "";

            for (var i=0; i < text.length; i++) {
                decimal += text[i].charCodeAt(0).toString(10) + " ";
            }

            return decimal;
        },

        decimalToText: function( text ) {
            return text.split(/\s/).map(function (val) {
                return String.fromCharCode(parseInt(val, 10));
            }).join("");
        },

        /**
         * Rot13 Encoder/Decoder
         ********************************************
         *
         * Inputs text, Outputs Rot13
         * Inputs Rot13, Outputs text
         *
         * This is the inversion of itself
         *
         * 
         *
         */
        rot13: function( input ) {
            return input.replace(/[a-zA-Z]/g, function(c) {
                return String.fromCharCode( (c<="Z"?90:122) >= (c=c.charCodeAt(0) + 13) ? c:c-26 ); 
            });
        },

        /**
         * Base64 Encoder / Decoder
         ********************************************
         *
         * base64Encoder: Inputs Decoded Base64
         * base64Decoder: Outputs Encoded Base64
         *
         */
        base64Encoder: function( input ) {
            return window.btoa(input);
        },

        base64Decoder: function( input ) {
            return window.atob(input);
        },

        /**
         * Hex Conversions
         ********************************************
         *
         * toHex: Inputs text, Outputs Hex
         * hexToText: Inputs Hex, outputs Text
         *
         */
        toHex: function( text ) {
            var tmp_array = [];
            var result = tmp_array.join('');
            var pretty_result = "";

            for (var i = 0 ; i < text.length ; i++)  {
                var hex = Number(text.charCodeAt(i)).toString(16);
                tmp_array.push(hex);
            }

            for ( var j = 0 ; j <= result.length ; j++ ) {
                if ( j % 2 ) {
                    pretty_result += result.charAt(j) + ' ';
                } else {
                    pretty_result += result.charAt(j);
                } 
            }

            return pretty_result;
        },

        hexToText: function( hex ) {
            return hex.split(/\s/).map(function (val) {
                return String.fromCharCode(parseInt(val, 16));
            }).join("");
        },

    } // TextConverter Obj

    DDH.text_converter.build = function(ops) {

        var from_type = ops.data.from_type;
        var to_type = ops.data.to_type;

        return {
            templates: {
                group: 'text',
                options: {
                    content: "DDH.text_converter.text_converter"
                },
            },
            onShow: function() {

                if(initialized) { return } // stops the local dom being rebuilt

                var $text_converter = $(".zci--text_converter");
                $convert_button = $text_converter.find("#js_convert-button");
                $convert_from_select = $text_converter.find("#js_convert--select-from");
                $convert_to_select = $text_converter.find("#js_convert--select-to");
                $convert_from_textarea = $text_converter.find("#text-converter--input");
                $convert_to_textarea = $text_converter.find("#text-converter--output");

                // sets the selects
                from_type !== "" ? $convert_from_select.val(from_type) : $convert_from_select.val("text");
                to_type !== "" ? $convert_to_select.val(to_type) : $convert_to_select.val("text");

                // Once clicked, we will convert whatever is in the /from/ textarea
                $convert_button.click(function() {
                    $convert_to_textarea.val(
                        TextConverter.convert(
                            $convert_from_textarea.val()
                        )
                    );
                });

                initialized = true
            }
        };
    };
})(DDH);

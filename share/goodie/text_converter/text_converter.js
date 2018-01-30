DDH.text_converter = DDH.text_converter || {};

(function(DDH) {
    "use strict";

    var initialized = false;

    // global DOM objects
    var $convert_button,
        $convert_selects,
        $convert_from_select,
        $convert_to_select,
        $convert_from_textarea,
        $convert_to_textarea;

    // TextConverter: A singleton object that performs all the text conversions
    var TextConverter = {

        convert: function() {

            var convert_from = $convert_from_textarea.val();
            $convert_to_textarea.val(
                TextConverter.converter(convert_from)
            )
        },

        converter: function() {
            var from_type = $convert_from_select.val();
            var to_type = $convert_to_select.val();
            var from = $convert_from_textarea.val();

            if(from_type === "decimal" && to_type === "binary") {
                return parseInt(from, 10).toString(2);

            } else if(from_type === "binary" && to_type === "hexadecimal") {
                return TextConverter.binaryToHex(from);

            } else if(from_type === "binary" && to_type === "base64") {
                return TextConverter.hexToBase64(
                    TextConverter.binaryToHex(from)
                );

            } else if(from_type === "binary" && to_type === "decimal") {
                return TextConverter.binaryToDecimal(from);

            } else if(from_type === "hexadecimal" && to_type === "decimal") {
                return TextConverter.hexToDecimal(from);

            } else if(from_type === "decimal" && to_type === "hexadecimal") {
                return TextConverter.decimalToHex(from);

            } else if(from_type === "base64" && to_type === "binary") {
                return TextConverter.hexToBinary(
                    TextConverter.base64ToHex(from)
                );

            } else if(from_type === "base64" && to_type === "hexadecimal") {
                return TextConverter.base64ToHex(from);

            } else if(from_type === "hexadecimal" && to_type === "binary") {
                return TextConverter.hexToBinary(from);

            } else if(from_type === "hexadecimal" && to_type === "base64") {
                return TextConverter.hexToBase64(from);

            } else { // We can convert the from type to ascii to the to_type
                
                if (from_type !== "text") {
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
                        return TextConverter.base64Encoder(from);
                        break;
                    case "hexadecimal":
                        return TextConverter.toHex(from);
                        break;
                    default:
                        return from; // DEFAULT: return the original text
                }
            }
        },

        /**
         * Binary Converter
         ********************************************
         *
         * zeroPad: text --> padded text
         * toBinary: text --> binary
         * binaryToText: binary --> text
         * binaryTohex: binary --> hex
         *
         */
        zeroPad: function(number) {
            return "00000000".slice(String(number).length) + number
        },

        toBinary: function(text) {
            return text.replace(/[\s\S]/g, function(str) {
                var octet = TextConverter.zeroPad(str.charCodeAt().toString(2));
                return octet + " ";
            });
        },

        binaryToDecimal: function(binary) {
            binary = binary.replace(/\s+/g, "");
            return parseInt(binary, 2);
        },

        binaryToText: function(text) {
            return text.split(/\s/).map(function(val) {
                return String.fromCharCode(parseInt(val, 2));
            }).join("");
        },

        binaryToHex: function(binaryString) {
            var binaryString = binaryString.replace(/\s+/g, "");
            var output = "";

            // For every 4 bits in the binary string
            for(var i = -4; i >= -binaryString.length; i -= 4) {
                var bytes = binaryString.substr(i, 4);
                var decimal = parseInt(bytes, 2); // convert to dec then hex
                var hex = decimal.toString(16);

                output = hex + output;
            }

            var rest = binaryString.length % 4;

            if(rest != 0) {
                var bytes = binaryString.substr(0, rest);
                var decimal = parseInt(bytes, 2);

                output = decimal.toString(16) + output;
            }

            return output.toUpperCase();
        },

        /**
         * Decimal Converters
         ********************************************
         *
         * toDecimal: text --> decimal (Base 10)
         * decimalToText: decimal --> text
         *
         */
        toDecimal: function(text) {
            var decimal = "";

            for (var i=0; i < text.length; i++) {
                decimal += text[i].charCodeAt(0).toString(10) + " ";
            }
            return decimal;
        },

        decimalToHex: function(number) {
            var num_split = number.split(" ");
            var hex_cache = [];

            for(var i = 0; i < num_split.length; i++) {
                hex_cache.push(Number(num_split[i]).toString(16).toUpperCase());
            }
            
            return hex_cache.join(" ");
        },

        decimalToText: function(text) {
            return text.split(/\s/).map(function(val) {
                return String.fromCharCode(parseInt(val, 10));
            }).join("");
        },

        /**
         * Rot13 Encoder/Decoder
         ********************************************
         *
         * rot13 --> text
         *
         * This is the inversion of itself.
         * If the input isn't ascii (or <original> -> <ascii>) then this will fail.
         *
         */
        rot13: function(input) {
            return input.replace(/[a-zA-Z]/g, function(c) {
                return String.fromCharCode( 
                    // this is a ternery statement, and the first arg is also a ternery statement
                    // step 1: checks to see if character is less than Z then 90, else 122
                    // step 2: checks the unicode and adds 13
                    // step 3: check if step 1 result is greater than or equal to step 2
                    // step 4: return unicode character else unicode character less than 26
                    (c <= "Z" ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c-26 ); 
            });
        },

        /**
         * Base64 Encoder / Decoder
         ********************************************
         *
         * base64Encoder: text --> encoded base64
         * base64Decoder: encoded base64 --> text
         * base64ToHex: encoded base64 --> hex
         *
         */
        base64Encoder: function(input) {
            return window.btoa(unescape(encodeURIComponent(input)));
        },

        base64Decoder: function(input) {
            return window.atob(unescape(encodeURIComponent(input)));
        },

        base64ToHex: function(base64) {
            var raw = atob(base64);
            var hex_cache = '';

            for ( var i = 0; i < raw.length; i++ ) {
                var hex = raw.charCodeAt(i).toString(16)
                hex_cache += (hex.length == 2 ? hex: "0" + hex);
            }

            return hex_cache.replace(/[^\dA-Za-z]/g, "").replace(/(.{2})/g, "$1 ").trim();
        },

        /**
         * Hex Conversions
         ********************************************
         *
         * toHex: text --> hex
         * hexToText: hex --> text
         * hexToBinary: hex --> binary
         * hexToBase64: hex --> base64 encoded hex
         *
         */
        toHex: function(text) {
            var tmp_array = [];
            var hex_result = "";

            for(var i = 0; i < text.length; i++)  {
                var hex = Number(text.charCodeAt(i)).toString(16);
                tmp_array.push(hex);
            }

            var result = tmp_array.join("");

            // this is for presentation for the user only
            for(var j = 0; j <= result.length; j++) {
                if(j % 2) {
                    hex_result += result.charAt(j) + " ";
                } else {
                    hex_result += result.charAt(j);
                } 
            }
            return hex_result;
        },

        hexToText: function(hex) {
            var hex = hex.replace(/\s|0x/g, "").match(/.{1,2}/g).join(" ");
            return hex.split(/\s/).map(function(val) {
                return String.fromCharCode(parseInt(val, 16));
            }).join("");
        },

        hexToBinary: function(hex) {
            var hex = hex.replace(/\s|0x/g, "");
            return hex.split("").reduce(function(acc, i) {
                var raw = acc + ("000" + parseInt(i, 16).toString(2)).substr(-4, 4);
                return raw.replace(/[^\d]/g, "").replace(/(.{8})/g, "$1 ").trim();
            }, '');
        },

        hexToDecimal: function(hex) {
            var hex_split = hex.split(" ");
            var dec_cache = [];

            for(var i = 0; i < hex_split.length; i++) {
                dec_cache.push(parseInt(hex_split[i], 16))
            }

            return dec_cache.join(" ");
        },

        hexToBase64: function(str) {
          return btoa(String.fromCharCode.apply(null,
            str.replace(/\r|\n/g, "").replace(/([\da-fA-F]{2}) ?/g, "0x$1 ").replace(/ +$/, "").split(" "))
          );
        },

    } // TextConverter Obj

    var Interface = {

        // can't convert two the same of the same class, swaps the labels.
        swapSelects: function(prevState, newState, id) {

            if(id === "js_convert--select-to") {
                if($convert_from_select.val() === newState) {
                    $convert_from_select.val(prevState);
                }
            } else {
                if($convert_to_select.val() === newState) {
                    $convert_to_select.val(prevState);
                } 
            }
        }
    }

    DDH.text_converter.build = function(ops) {

        var from_type = ops.data.from_type;
        var to_type = ops.data.to_type;

        return {
            templates: {
                group: 'text',
                options: {
                    content: "DDH.text_converter.content"
                },
            },
            onShow: function() {

                if(initialized) { return } // stops the local dom being rebuilt

                var $text_converter = $(".zci--text_converter");
                $convert_button = $text_converter.find("#js_convert-button");
                $convert_from_select = $text_converter.find("#js_convert--select-from");
                $convert_to_select = $text_converter.find("#js_convert--select-to");
                $convert_selects = $text_converter.find("select");
                $convert_from_textarea = $text_converter.find("#text-converter--input");
                $convert_to_textarea = $text_converter.find("#text-converter--output");

                // sets the selects
                from_type !== "" ? $convert_from_select.val(from_type) : $convert_from_select.val("text");
                to_type !== "" ? $convert_to_select.val(to_type) : $convert_to_select.val("text");

                // Once clicked, we will convert whatever is in the /from/ textarea
                $convert_button.click(TextConverter.convert);

                // swaps the selects around if they are the new select is equalilant to the opposite
                var previous;
                $convert_selects.on("focus", function () {
                    previous = this.value;
                }).change(function() {
                    Interface.swapSelects(previous, this.value, this.id);
                });

                initialized = true
            }
        };
    };
})(DDH);

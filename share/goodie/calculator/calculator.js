DDH.calculator = DDH.calculator || {};

(function(DDH) {
    "use strict";

    // GLOBALS
    var initialized = false;
    var DEVICE_TYPE = undefined;

    /**
     * KEYCODES
     *
     * This hash of keycodes represent the keys on the keyboard
     * which are used to determine input from a user.
     */
    var KEYCODES = {
        13: "=",
        33: "!",
        37: "%",
        40: "(",
        41: ")",
        42: "×",
        43: "+",
        44: ".",
        45: "-",
        46: ".",
        47: "÷",
        48: "0",
        49: "1",
        50: "2",
        51: "3",
        52: "4",
        53: "5",
        54: "6",
        55: "7",
        56: "8",
        57: "9",
        61: "=",
        69: "EE",
        99: "cos(",
        101: "e",
        103: "log(",
        108: "ln(",
        112: "π",
        113: "√(",
        115: "sin(",
        116: "tan(",
        120: "×"
    }
    
    DDH.calculator.build_async = function(ops, DDH_async_add) {

        if(2 === 2) {
            DDH_async_add({
                id: "calculator",
                data: {
                    query: undefined,
                },
                templates: {
                    group: 'base',
                    options: {
                        content: 'DDH.calculator.content'  
                    }
                }
            });
        }

        var $calc = $(".zci--calculator");
        var $buttons = $calc.find("button");

        /**
         * Input Trap
         *
         * 
         */
        var $calcInputTrap = $calc.find(".tile__input-trap");

        function setFocus() {
            $calcInputTrap.focus();
        }

        /**
         * Bind the buttons
         *
         * Based on the type of device the user is searching on, the calculator
         * buttons will be bound differently.
         *
         * Mobile -> touchstart (event fired when a touch point is placed on a touch surface)
         * Desktop / Laptop -> click (event fired when a mouse is clicked on screen)
         */
        if(!initialized) {

            // checks the device type
            if(DDG.device.isMobile || DDG.device.isMobileDevice) {
                // mobile
                DEVICE_TYPE = 'touchstart';
            } else {
                // everything else
                DEVICE_TYPE = 'click';
            }

            // initialize the buttons so when they're pressed the update the display.value
            $buttons.bind(DEVICE_TYPE, function(e) {
                e.preventDefault();
                console.log(this.value);
            });
        }

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
         * is looked up in the KEYCODES hash.
         */
        $calcInputTrap.keypress(function(e){

            var key = e.keyCode || e.charCode;
            var pressed = "";

            pressed = KEYCODES[key];

            if(pressed === undefined) {
                return false;
            }

            console.log(evt);
            setFocus();
            e.stopImmediatePropagation();
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

        initialized = true;
        console.log("Calculator now initialized");

    }; // DDH.calculator.build_async
})(DDH);

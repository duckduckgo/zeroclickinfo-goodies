DDH.conversions = DDH.conversions || {};

(function(DDH) {
    "use strict";

    var localDOMInitialized = false;
    var initialized = false;

    // UI: the input / output fields
    var $convert_left,
        $convert_right,
        $select_right,
        $select_left,
        $unitSelector,
        $selects;

    // a capitalize method to string literals
    String.prototype.capitalize = function() {
        return this.charAt(0).toUpperCase() + this.slice(1);
    }

    var Converter = {

        // the local vars
        leftUnit:   "",
        rightUnit:  "",
        leftValue:  "",
        rightValue: "",

        setValues: function() {
            this.setLeftUnit();
            this.setRightUnit();
            this.setLeftValue();
            this.setRightValue();
        },

        setLeftUnit: function() {
            this.leftUnit = $select_left.val();
        },

        setLeftValue: function() {
            this.leftValue = $convert_left.val();
        },

        setRightUnit: function() {
            this.rightUnit = $select_right.val();
        },

        setRightValue: function() {
            this.rightValue = $convert_right.val();
        },

        eval: function( expression ) {
            return math.eval(expression).format({ precision: 6 }).split(" ")[0];
        },

        convert: function( side ) {

            this.setValues();
            if(side === "right") {
                var expression = this.leftValue + " " + this.leftUnit + " to " + this.rightUnit;
                $convert_right.val(this.eval(expression));
            } else {
                var expression = this.rightValue + " " + this.rightUnit + " to " + this.leftUnit;
                $convert_left.val(this.eval(expression));
            }
        },

        emptySelects: function() {
            // removes all the options
            $select_left.empty();
            $select_right.empty();
        },

        updateUnitSelectors: function( key ) {

            this.emptySelects();
            var formatted_option_name;

            // adds the new conversion units to the selects
            for(var i = 0 ; i < Units[key].units.length ; i++) {
                formatted_option_name = (Units[key].units[i].length > 3) ? Units[key].units[i].capitalize() : Units[key].units[i];
                $selects.append(
                    '<option value="' + Units[key].units[i] + '">'
                    + formatted_option_name
                    + '</option>'
                );
            }

            // set defaults. written this way for readability
            $select_left.val(Units[key].defaults[0]);
            $select_right.val(Units[key].defaults[1]);
        },

        updateBaseUnitSelector: function( startBase ) {
            // adds the different unit types to the selector
            var unitKeys = Object.keys(Units);
            $.each(unitKeys.sort(), function(_key, value) {
                $unitSelector.append(
                    '<option value="'+value+'"' + (value === startBase ? " selected='selected'" : "") + '>'
                    + Units[value].name
                    + '</option>'
                );
            });
        }
    } // Converter

    var Utils = {

        // caches the local DOM vars
        setUpLocalDOM: function() {
            var $root           = DDH.getDOM('conversions');
            $convert_left       = $root.find(".frm__input--left");
            $convert_right      = $root.find(".frm__input--right");
            $selects            = $root.find(".frm--top select");
            $select_right       = $root.find(".frm__select--right");
            $select_left        = $root.find(".frm__select--left");
            $unitSelector       = $root.find(".frm__select--bottom");
            localDOMInitialized = true;
        },
    } // Utils

    var Units = {
        length: {
            name: "Length",
            units: [
                'decameter',
                'millimeter',
                'micrometer',
                'nanometer',
                'picometer',
                'kilometer',
                'meter',
                'cm',
                'hectometer',
                'chains',
                'mm',
                'inch',
                'foot',
                'yard',
                'mile',
                'link',
                'rod',
                'angstrom',
                'mil'
            ],
            defaults: ['meter', 'cm']
        },
        area: {
            name: "Area",
            units: [
                'm2',
                'sqin',
                'sqft',
                'sqyd',
                'sqmi',
                'sqrd',
                'sqch',
                'sqmil',
                'acre',
                'hectare'
            ],
            defaults: ['m2', 'sqin']
        },
        volume: {
            name: "Volume",
            units: [
                'litre',
                'millilitre',
                'hectolitre',
                'decalitre',
                'deciliter',
                'centilitre',
                'cc',
                'cuin',
                'cuft',
                'cups',
                'cuyd',
                'pints',
                'teaspoon',
                'tablespoon'
            ],
            defaults: ['litre', 'millilitre']
        },
        liquid_volume: {
            name: "Liquid Volume",
            units: ['minim', 'fluiddram', 'fluidounce', 'gill', 'cup', 'pint', 'quart', 'gallon', 'beerbarrel', 'oilbarrel', 'hogshead', 'drop'],
            defaults: ['minim', 'fluiddram']
        },
        angle: {
            name: "Angle",
            units: [
                'rad',
                'deg',
                'grad',
                'cycle',
                'arcsec',
                'arcmin'
            ],
            defaults: ['deg', 'rad']
        },
        duration: {
            name: "Duration",
            units: [
                'nanosecond',
                'microsecond',
                'millisecond',
                'second',
                'minute',
                'hour',
                'day',
                'week',
                'month',
                'year',
                'decade',
                'century',
                'millennium'
            ],
            defaults: ['minute', 'second']
        },
        mass: {
            name: "Mass",
            units: [
                'microgram',
                'kilogram',
                'milligram',
                'gram',
                'ton',
                'grain',
                'dram',
                'ounce',
                'poundmass',
                'hundredweight',
                'stick',
                'stone'
            ],
            defaults: ['kilogram', 'gram']
        },
        temperature: {
            name: "Temperature",
            units: [
                'kelvin',
                'celsius',
                'fahrenheit',
                'rankine'
            ],
            defaults: ['celsius', 'fahrenheit']
        },
        force: {
            name: "Force",
            units: [
                'newton',
                'dyne',
                'poundforce',
                'kip'
            ],
            defaults: ['newton', 'dyne']
        },
        energy: {
            name: "Energy",
            units: [
                'joule',
                'Wh',
                'erg',
                'BTU',
                'electronvolt'
            ],
            defaults: ['joule', 'Wh']
        },
        power: {
            name: "Power",
            units: [
                'watt',
                'hp'
            ],
            defaults: ['watt', 'hp']
        },
        pressure: {
            name: "Pressure",
            units: [
                'Pa',
                'psi',
                'atm',
                'torr',
                'mmHg',
                'mmH2O',
                'cmH2O'
            ],
            defaults: ['Pa', 'psi']
        },
        electricity_magnetism: {
            name: "Electricity and magnetism",
            units: ['ampere', 'coulomb', 'watt', 'volt', 'ohm', 'farad', 'weber', 'tesla', 'henry', 'siemens', 'electronvolt'],
            defaults: ['ampere', 'coulomb']
        },
        // TODO: Support digital conversions. @pjhampton - there were math.js api issues
        // digital: {
        //     name: "Binary",
        //     units: ['bit', 'byte'],
        //     defaults: ['bit', 'byte']
        // }
    } // Units

    DDH.conversions.build = function(ops) {

        // just defaulting to `length` for now, will change when interacting with perl backend.
        var startBase = ops.data.physical_quantity || 'length';
        var leftUnit = ops.data.left_unit || Units[startBase].defaults[0];
        var rightUnit = ops.data.right_unit || Units[startBase].defaults[1];
        var rawInput = ops.data.raw_input || '1';
        var unitsSpecified = false;

        return {
            signal: "high",
            onShow: function() {
                DDG.require('math.js', function() {

                    if(!localDOMInitialized) {
                        Utils.setUpLocalDOM();
                    }

                    if(!initialized) {
                        Converter.updateUnitSelectors(startBase);
                        Converter.updateBaseUnitSelector(startBase);

                        // if no numbers provided, fall back on 1
                        if(!unitsSpecified) {
                            $convert_left.val(rawInput);
                            $select_left.val(leftUnit);
                            $select_right.val(rightUnit);
                            Converter.convert("right");
                        }

                        initialized = true;
                    }

                    $convert_left.keyup(function( _e ) {
                        if(this.value === "") {
                            $convert_right.val("");
                        }
                        if(this.value !== "" && $.isNumeric(this.value)) {
                            Converter.convert("right");
                        }
                    });

                    $convert_right.keyup(function( _e ) {
                        if(this.value === "") {
                            $convert_left.val("");
                        }
                        if(this.value !== "" && $.isNumeric(this.value)) {
                            Converter.convert("left");
                        }
                    });

                    $select_right.change(function() {
                        Converter.convert("right");
                    });

                    $select_left.change(function() {
                        Converter.convert("left");
                    });

                    // if the user changes the unit base
                    $unitSelector.change(function() {
                        Converter.updateUnitSelectors(this.value);
                        $convert_left.val("1");
                        Converter.convert("right");
                    });

                });

            }// on show
        }; // return
    }; // DDH.conversions.build

    // module.exports = { Converter: Converter, Utils: Utils };

})(DDH);

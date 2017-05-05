DDH.conversions = DDH.conversions || {};

(function(DDH) {
  "use strict";

    // flag variables for onShow functionality
    var localDOMInitialized = false;
    var initialized = false;

    // UI: the input / output fields
    var $convert_left,
        $convert_right,
        $select_right,
        $select_left,
        $unitSelector,
        $selects;

    // caches the local DOM vars
    function setUpLocalDOM() {

        var $root           = DDH.getDOM('conversions');
        $convert_left       = $root.find(".frm__input--left");
        $convert_right      = $root.find(".frm__input--right");
        $selects            = $root.find(".frm--bottom select");
        $select_right       = $root.find(".frm__select--right");
        $select_left        = $root.find(".frm__select--left");
        $unitSelector       = $root.find(".frm__select--bottom");
        localDOMInitialized = true;
    }

    /**
     * Converter
     *
     * The converter object is responsible for getting the values from
     * the UI and building the expression that is passed to the math object
     */
    var Converter = {

        // the local vars
        leftUnit:   "",
        rightUnit:  "",
        leftValue:  "",
        rightValue: "",

        customUnits: [
            // CUSTOM ENERGY UNITS
            {name: 'kilojoule', factor: '1000 joules'},
            {name: 'gramcalorie', factor: '4.184 joules' },
            {name: 'kilocalorie', factor: '4184 joules' },

            // CUSTOM DIGITAL UNITS
            {name: 'kbit',  factor: '1000 b'},
            {name: 'mbit',  factor: '1000000 b'},
            {name: 'gbit',  factor: '1000000000 b'},
            {name: 'tbit',  factor: '1000000000000 b'},
            {name: 'KB',    factor: '1000 B'},
            {name: 'MB',    factor: '1000000 B'},
            {name: 'GB',    factor: '1000000000 B'},
            {name: 'TB',    factor: '1000 GB'},
            {name: 'PB',    factor: '1000 TB'}
        ],

        // custom units that are not supported by math.js
        setUpCustomUnits: function() {
            for (var i = 0 ; i < this.customUnits.length ; i++) {
                math.createUnit(
                        this.customUnits[i].name,
                        this.customUnits[i].factor
                    )
            };
        },

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

            // if side isn't defined, default to right
            var side = side || "right"

            this.setValues();
            if(side === "right") {
                var expression = this.leftValue + " " + this.leftUnit + " to " + this.rightUnit;
                $convert_right.val(this.eval(expression));
            } else {
                var expression = this.rightValue + " " + this.rightUnit + " to " + this.leftUnit;
                $convert_left.val(this.eval(expression));
            }
        },

        // removes all the options
        emptySelects: function() {

            $select_left.empty();
            $select_right.empty();
        },

        updateUnitSelectors: function( key ) {

            // resets the selects state
            this.emptySelects();
            // sort the keys alphabetically
            if(key !== "digital") {
                Units[key].units.sort(function(a, b) {
                    var softA = a.name.toUpperCase();
                    var softB = b.name.toUpperCase();
                    return (softA < softB) ? -1 : (softA > softB) ? 1 : 0;
                });
            }

            // adds the new conversion units to the selects
            for(var i = 0 ; i < Units[key].units.length ; i++) {
                $selects.append(
                    '<option value="' + Units[key].units[i].symbol + '">'
                    + Units[key].units[i].name
                    + '</option>'
                );
            }

            // set defaults. these should match Units[key].units[i].symbol
            $select_left.val(Units[key].defaults[0]);
            $select_right.val(Units[key].defaults[1]);
        },

        // updates the list of bases to choose from. Should only be called once (on startup)
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

    /**
     * Units
     *
     * The bases and their units that we provide for the user
     */
    var Units = {
        angle: {
            name: "Angle",
            units: [
                { symbol: 'rad',        name: 'Radians' },
                { symbol: 'deg',        name: 'Degrees' },
                { symbol: 'grad',       name: 'Gradians' },
                { symbol: 'cycle',      name: 'Cycles' },
                { symbol: 'arcsec',     name: 'Arcsecond' },
                { symbol: 'arcmin',     name: 'Arcminute' },
                { symbol: 'millirad',   name: 'Milliradian' },
            ],
            defaults: ['deg', 'rad']
        },
        area: {
            name: "Area",
            units: [
                { symbol: 'm2',         name: 'Square Meter' },
                { symbol: 'sqin',       name: 'Square Inch' },
                { symbol: 'sqft',       name: 'Square Feet' },
                { symbol: 'sqyd',       name: 'Square Yard' },
                { symbol: 'sqmi',       name: 'Square Mile' },
                { symbol: 'acre',       name: 'Acre' },
                { symbol: 'hectare',    name: 'Hectare' }
            ],
            defaults: ['m2', 'sqin']
        },
        digital: {
            name: "Digital Storage",
            units: [
                { symbol: 'b', name: 'Bit' },
                { symbol: 'kbit', name: 'Kilobit' },
                { symbol: 'KiBit', name: 'Kibibit' },
                { symbol: 'mbit', name: 'Megabit'},
                { symbol: 'MiBit', name: 'Mebibit'},
                { symbol: 'gbit', name: 'Gigabit'},
                { symbol: 'GiBit', name: 'Gibibit'},
                { symbol: 'tbit', name: 'Terrabit'},
                { symbol: 'TiBit', name: 'Tebibit'},
                { symbol: 'pbit', name: 'Petabit'},
                { symbol: 'PiBit', name: 'Pebibit'},
                { symbol: 'B', name: 'Byte' },
                { symbol: 'KB', name: 'Kilobyte'},
                { symbol: 'KiB', name: 'Kibibyte'},
                { symbol: 'MB', name: 'Megabyte'},
                { symbol: 'MiB', name: 'Mebibyte'},
                { symbol: 'GB', name: 'Gigabyte'},
                { symbol: 'GiB', name: 'Gibibyte'},
                { symbol: 'TB', name: 'Terabyte'},
                { symbol: 'TiB', name: 'Tebibyte'},
                { symbol: 'PB', name: 'Petabyte'},
                { symbol: 'PiB', name: 'Pebibyte'}
            ],
            defaults: ['b', 'B']
        },
        duration: {
            name: "Duration",
            units: [
                { symbol: 'nanosecond',     name: 'Nanoseconds' },
                { symbol: 'microsecond',    name: 'Microseconds' },
                { symbol: 'millisecond',    name: 'Milliseconds' },
                { symbol: 'second',         name: 'Seconds' },
                { symbol: 'minute',         name: 'Minutes' },
                { symbol: 'hour',           name: 'Hours' },
                { symbol: 'day',            name: 'Days' },
                { symbol: 'week',           name: 'Weeks' },
                { symbol: 'month',          name: 'Months'},
                { symbol: 'year',           name: 'Years' },
                { symbol: 'decade',         name: 'Decade' },
                { symbol: 'century',        name: 'Century' },
                { symbol: 'millennium',     name: 'Millennium' },
            ],
            defaults: ['minute', 'second']
        },
        energy: {
            name: "Energy",
            units: [
                { symbol: 'joule',          name: 'Joule' },
                { symbol: 'kilojoule',      name: 'Kilojoule' },
                { symbol: 'gramcalorie',    name: 'Gram Calorie'},
                { symbol: 'kilocalorie',    name: 'Kilo Calorie'},
                { symbol: 'Wh',             name: 'Watt Hour' },
                { symbol: 'erg',            name: 'Erg' },
                { symbol: 'BTU',            name: 'BTU'},
                { symbol: 'electronvolt',   name: 'Electronvolt'},
            ],
            defaults: ['joule', 'Wh']
        },
        force: {
            name: "Force",
            units: [
                { symbol: 'newton',     name: 'Newton' },
                { symbol: 'dyne',       name: 'Dyne'},
                { symbol: 'poundforce', name: 'Pound Force'},
                { symbol: 'kip',        name: 'Kip'},
            ],
            defaults: ['newton', 'dyne']
        },
        length: {
            name: "Length",
            units: [
                { symbol: 'decameter',  name: 'Decameter' },
                { symbol: 'millimeter', name: 'Millimeter' },
                { symbol: 'micrometer', name: 'Micrometer' },
                { symbol: 'micrometer', name: 'Micrometer' },
                { symbol: 'nanometer',  name: 'Nanometer' },
                { symbol: 'picometer',  name: 'Picometer' },
                { symbol: 'kilometer',  name: 'Kilometer' },
                { symbol: 'meter',      name: 'Meter' },
                { symbol: 'cm',         name: 'Centimeter' },
                { symbol: 'hectometer', name: 'Hectometer' },
                { symbol: 'chains',     name: 'Chains' },
                { symbol: 'inch',       name: 'Inch' },
                { symbol: 'foot',       name: 'Feet' },
                { symbol: 'yard',       name: 'Yard' },
                { symbol: 'mile',       name: 'Mile' },
                { symbol: 'link',       name: 'Link' },
                { symbol: 'rod',        name: 'Rod' },
                { symbol: 'angstrom',   name: 'Angstrom' },
                { symbol: 'mil',        name: 'Mil'}
            ],
            defaults: ['meter', 'cm']
        },
        liquid_volume: {
            name: "Liquid Volume",
            units: [
                { symbol: 'minim',          name: 'Minim' },
                { symbol: 'fluiddram',      name: 'Fluid Dram' },
                { symbol: 'fluidounce',     name: 'Fluid Ounce' },
                { symbol: 'gill',           name: 'Gill' },
                { symbol: 'cup',            name: 'Cup' },
                { symbol: 'pint',           name: 'Pint'},
                { symbol: 'quart',          name: 'Quart'},
                { symbol: 'gallon',         name: 'Gallon'},
                { symbol: 'beerbarrel',     name: 'Beerbarrel'},
                { symbol: 'oilbarrel',      name: 'Oilbarrel'},
                { symbol: 'hogshead',       name: 'Hogshead'},
                { symbol: 'drop',           name: 'Drop'},
            ],
            defaults: ['minim', 'fluiddram']
        },
        mass: {
            name: "Mass",
            units: [
                { symbol: 'microgram',      name: 'Microgram' },
                { symbol: 'kilogram',       name: 'Kilogram' },
                { symbol: 'milligram',      name: 'Milligram' },
                { symbol: 'gram',           name: 'Gram' },
                { symbol: 'ton',            name: 'Ton' },
                { symbol: 'grain',          name: 'Grain' },
                { symbol: 'dram',           name: 'Dram' },
                { symbol: 'ounce',          name: 'Ounce' },
                { symbol: 'poundmass',      name: 'Pound' },
                { symbol: 'hundredweight',  name: 'Hundredweight' },
                { symbol: 'stick',          name: 'Stick' },
                { symbol: 'stone',          name: 'Stone' },
            ],
            defaults: ['kilogram', 'gram']
        },
        power: {
            name: "Power",
            units: [
                { symbol: 'watt', name: 'Watt'},
                { symbol: 'hp', name: 'HP' }
            ],
            defaults: ['watt', 'hp']
        },
        pressure: {
            name: "Pressure",
            units: [
                { symbol: 'Pa',     name: 'Pascal' },
                { symbol: 'psi',    name: 'PSI' },
                { symbol: 'atm',    name: 'Atmospheres' },
                { symbol: 'torr',   name: 'Torr' },
                { symbol: 'mmHg',   name: 'mmHg' },
                { symbol: 'mmH2O',  name: 'mmH2O' },
                { symbol: 'cmH2O',  name: 'cmH2O' },
                { symbol: 'bar',    name: 'Bars' },
            ],
            defaults: ['Pa', 'psi']
        },
        temperature: {
            name: "Temperature",
            units: [
                { symbol: 'kelvin',     name: 'Kelvin' },
                { symbol: 'celsius',    name: 'Celsius' },
                { symbol: 'fahrenheit', name: 'Fahrenheit' },
                { symbol: 'rankine',    name: 'Rankine' },
            ],
            defaults: ['celsius', 'fahrenheit']
        },
        volume: {
            name: "Volume",
            units: [
                { symbol: 'litre',      name: 'Litre' },
                { symbol: 'millilitre', name: 'Millilitre' },
                { symbol: 'hectolitre', name: 'Hectolitre' },
                { symbol: 'decalitre',  name: 'Decalitre' },
                { symbol: 'deciliter',  name: 'Deciliter' },
                { symbol: 'centilitre', name: 'Centilitre' },
                { symbol: 'cc',         name: 'CC' },
                { symbol: 'cuin',       name: 'Cuin' },
                { symbol: 'cuft',       name: 'Cuft' },
                { symbol: 'cups',       name: 'Cups' },
                { symbol: 'cuyd',       name: 'Cubic Yard' },
                { symbol: 'pints',      name: 'Pints' },
                { symbol: 'teaspoon',   name: 'Teaspoon' },
                { symbol: 'tablespoon', name: 'Tablespoon' },
            ],
            defaults: ['litre', 'millilitre']
        },
    } // Units

    DDH.conversions.build = function(ops) {

        // Defaults to length if no base is supported
        var startBase = ops.data.physical_quantity || 'length';
        var leftUnit = ops.data.left_unit || Units[startBase].defaults[0];
        var rightUnit = ops.data.right_unit || Units[startBase].defaults[1];
        var rawInput = ops.data.raw_input || '1';
        var unitsSpecified = false;

        return {
            // anytime this is triggered, we default to a high signal
            signal: "high",
            onShow: function() {
                DDG.require('math.js', function() {

                    // checks to see if custom units need set up and selectors cached
                    if(!localDOMInitialized) {
                        setUpLocalDOM();
                        Converter.setUpCustomUnits();
                    }

                    if(!initialized) {
                        Converter.updateUnitSelectors(startBase);
                        Converter.updateBaseUnitSelector(startBase);

                        // if no numbers provided, fall back on 1
                        if(!unitsSpecified) {
                            $convert_left.val(rawInput);
                            $select_left.val(leftUnit);
                            $select_right.val(rightUnit);
                            Converter.convert();
                        }

                        initialized = true;
                    }

                    $convert_left.keyup(function( _e ) {
                        if(this.value === "") {
                            $convert_right.val("");
                        }
                        if(this.value !== "" && $.isNumeric(this.value)) {
                            Converter.convert();
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

                    $convert_left.click(function() {
                        this.select()
                    });

                    $convert_right.click(function() {
                        this.select()
                    });

                    $select_right.change(function() {
                        Converter.convert();
                    });

                    $select_left.change(function() {
                        Converter.convert();
                    });

                    // if the user changes the unit base
                    $unitSelector.change(function() {
                        Converter.updateUnitSelectors(this.value);
                        $convert_left.val("1");
                        Converter.convert();
                    });


                });

            }// on show
        }; // return
    }; // DDH.conversions.build

    // checks we are not in the browser and exposes Converter for unit testing
    if (typeof window === 'undefined') {
        module.exports = Converter;
    }

})(DDH);

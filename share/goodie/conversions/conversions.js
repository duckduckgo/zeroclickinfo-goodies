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
        $unitSelector       = $root.find(".frm__select--top");
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
            // CUSTOM AREA UNITS
            {name: 'barn',          factor: '0.00000000000000000000000000000001 hectare'},
            {name: 'rood',          factor: '0.10117141 hectare'},
            {name: 'squarerod',     factor: '0.00252929 hectare'},
            {name: 'are',           factor: '0.01 hectare'},
            {name: 'sqdecimeter',   factor: '0.000001 hectare'},
            {name: 'sqcentimeter',  factor: '0.0001 m2'},
            {name: 'sqmillimeter',  factor: '0.01 sqcentimeter'},

             // CUSTOM DURATION UNITS
            {name: "femtosecond",   factor: "0.000000000000001 second"},
            {name: "picosecond",    factor: "0.000000000001 second"},
            {name: "fortnight",     factor: "2 week"},
            {name: "siderealyear",  factor: "1.00001741 year"},

            // CUSTOM DIGITAL UNITS
            {name: 'kbit',      factor: '1000 b'},
            {name: 'mbit',      factor: '1000000 b'},
            {name: 'gbit',      factor: '1000000000 b'},
            {name: 'tbit',      factor: '1000000000000 b'},
            {name: 'KB',        factor: '1000 B'},
            {name: 'MB',        factor: '1000000 B'},
            {name: 'GB',        factor: '1000000000 B'},
            {name: 'TB',        factor: '1000 GB'},
            {name: 'PB',        factor: '1000 TB'},
            {name: 'kibibit',   factor: '128 B'},
            {name: 'mebibit',   factor: '131072 B'},
            {name: 'gibibit',   factor: '1024 mebibit'},
            {name: 'tebibit',   factor: '1024 gibibit'},
            {name: 'pebibit',   factor: '1024 tebibit'},
            {name: 'kibibyte',  factor: '1024 B'},
            {name: 'mebibyte',  factor: '1024 kibibyte'},
            {name: 'gibibyte',  factor: '1024 mebibyte'},
            {name: 'tebibyte',  factor: '1024 gibibyte'},
            {name: 'pebibyte',  factor: '1024 tebibyte'},

            // CUSTOM DIGITAL TRANSFER UNITS
            {name: 'bitps',         factor: '1 b'},
            {name: 'kbitps',        factor: '1000 bitps'},
            {name: 'mbitps',        factor: '1000 kbitps'},
            {name: 'gbitps',        factor: '1000 mbitps'},
            {name: 'tbitps',        factor: '1000 gbitps'},
            {name: 'kilobyteps',    factor: '8000 bitps'},
            {name: 'megabyteps',    factor: '1000 kilobyteps'},
            {name: 'gigabyteps',    factor: '1000 megabyteps'},
            {name: 'terabyteps',    factor: '1000 gigabyteps'},
            {name: 'kibps',         factor: '1024 bitps'},
            {name: 'mibps',         factor: '1024 kibps'},
            {name: 'gibps',         factor: '1024 mibps'},
            {name: 'tibps',         factor: '1024 gibps'},

            // CUSTOM ANGLE UNITS
            {name: 'microarcsec', factor: '0.000000000004848 rad'},
            {name: 'milliarcsec', factor: '0.000000004848 rad'},
            {name: 'microrad',    factor: '0.000001 rad'},
            {name: 'rev',         factor: '6.2832 rad'},

            // CUSTOM ENERGY UNITS
            {name: 'ergfixed',              factor: '0.0000001 joules'}, // math.js bug workaround
            {name: 'kilojoule',             factor: '1000 joules'},
            {name: 'gramcalorie',           factor: '4.184 joules'},
            {name: 'kilocalorie',           factor: '4184 joules'},
            {name: 'footpound',             factor: '1.35581795 joules'},
            {name: 'decielectronvolt',      factor: '0.1 electronvolt'},
            {name: 'centielectronvolt',     factor: '0.01 electronvolt'},
            {name: 'millielectronvolt',     factor: '0.001 electronvolt'},
            {name: 'microelectronvolt',     factor: '0.000001 electronvolt'},
            {name: 'nanoelectronvolt',      factor: '0.000000001 electronvolt'},
            {name: 'picoelectronvolt',      factor: '0.000000000001 electronvolt'},
            {name: 'femtoelectronvolt',     factor: '0.000000000000001 electronvolt'},
            {name: 'attoelectronvolt',      factor: '0.000000000000000001 electronvolt'},
            {name: 'zeptoelectronvolt',     factor: '0.000000000000000000001 electronvolt'},
            {name: 'yoctoelectronvolt',     factor: '0.000000000000000000000001 electronvolt'},
            {name: 'decaelectronvolt',      factor: '10000000000000000 femtoelectronvolt'},
            {name: 'hectoelectronvolt',     factor: '100000000000000000 femtoelectronvolt'},
            {name: 'kiloelectronvolt',      factor: '1000000000000000000 femtoelectronvolt'},
            {name: 'megaelectronvolt',      factor: '1000 kiloelectronvolt'},
            {name: 'gigaelectronvolt',      factor: '1000000 kiloelectronvolt'},
            {name: 'teraelectronvolt',      factor: '1000 gigaelectronvolt'},
            {name: 'petaelectronvolt',      factor: '1000 teraelectronvolt'},
            {name: 'exaelectronvolt',       factor: '1000 petaelectronvolt'},
            {name: 'zettaelectronvolt',     factor: '1000 exaelectronvolt'},
            {name: 'yottaelectronvolt',     factor: '1000 zettaelectronvolt'},

            // CUSTOM LENGTH UNITS
            {name: 'nauticalmile',          factor: '1.15078 miles'},
            {name: 'astronomicalunit',      factor: '149597870700 meters'},
            {name: 'lightyear',             factor: '9460730472580800 meters'},
            {name: 'parsec',                factor: '30856775814913673 meters'},

            // CUSTOM FORCE UNITS
            {name: 'kilonewton',     factor: '1000 newton'},
            {name: 'gramforce',      factor: '0.00980665 newton'},
            {name: 'ounceforce',     factor: '0.0625 poundforce'},
            {name: 'kilogramforce',  factor: '1000 gramforce'},
            {name: 'metrictonforce', factor: '1000 kilogramforce'},

            // CUSTOM MASS UNITS
            {name: 'dekagram',          factor: '10 grams'},
            {name: 'metricton',         factor: '1 megagram'},
            {name: 'longton',           factor: '1016.05 kilograms'},
            {name: 'shortton',          factor: '907.185 kilograms'},
            {name: 'metricquintal',     factor: '100 kilograms'},
            {name: 'usquintal',         factor: '45.359237 kilograms'},
            {name: 'frenchquintal',     factor: '148.95 kilograms'},
            {name: 'troyounce',         factor: '31.1034768 grams'},
            {name: 'slug',              factor: '14.593903 kilograms'},
            {name: 'tola',              factor: '11.6638038 grams'},
            {name: 'carat',             factor: '0.2 grams'},
            {name: 'atomicmassunit',    factor: '0.000000001660538921 femtograms'},

            // CUSTOM POWER UNITS
            {name: 'kilowatt',    factor: '1000 watt'},
            {name: 'megawatt',    factor: '1000 kilowatt'},
            {name: 'gigawatt',    factor: '1000 megawatt'},
            {name: 'terawatt',    factor: '1000 gigawatt'},
            {name: 'petawatt',    factor: '1000 terawatt'},
            {name: 'exawatt',     factor: '1000 petawatt'},

            // CUSTOM PRESSURE UNITS
            {name: 'barye',     factor: '0.000001 bar'},
            {name: 'Satm',      factor: '1 atm'},
            {name: 'at',        factor: '0.980665 bar'},
            {name: 'mbar',      factor: '0.001 bar'},
            {name: 'cbar',      factor: '0.01 bar'},
            {name: 'dbar',      factor: '0.1 bar'},
            {name: 'kbar',      factor: '1000 bar'},
            {name: 'Mbar',      factor: '100000 bar'},
            {name: 'Gbar',      factor: '100000000 bar'},

            // CUSTOM SPEED UNITS
            {name: 'knot',     factor: '1.15078 mi/h'},

            // CUSTOM VOLUME UNITS
            {name: 'impgallon',     factor: '4.54609 liters'},
            {name: 'usgallon',      factor: '3.7854 liters'},
            {name: 'usfluidounce',  factor: '0.0078125 usgallon'},
            {name: 'impfluidounce', factor: '0.0284131 liters'},
            {name: 'usquart',       factor: '0.946353 liters'},
            {name: 'impquart',      factor: '1.13652 liters'},
            {name: 'uscup',         factor: '0.24 liters'},
            {name: 'impcup',        factor: '0.284131 liters'},
            {name: 'ustbsp',        factor: '0.0147868 liters'},
            {name: 'imptbsp',       factor: '0.0177582 liters'},
            {name: 'ustsp',         factor: '0.00492892 liters'},
            {name: 'imptsp',        factor: '0.00591939 liters'},
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

        // determines the precision of number / number in e-notation
        // 0.23 --> 2, 0.32214 --> 5, 1 --> 0
        determinePrecision: function( number ) {

            var match = (''+number).match(/(?:\.(\d+))?(?:[eE]([+-]?\d+))?$/);
            if (!match) { return 0; }
            return Math.max(
                0,
                // Number of digits right of decimal point.
                (match[1] ? match[1].length : 0)
                    // Adjusts for scientific notation.
                    - (match[2] ? +match[2] : 0));
        },

        // evaluates the function using math.js
        // the length of the input is used to determine precision unless it's more than 7
        eval: function( expression, precision ) {

            var prec = Math.max(precision, 7);
            var ans = math.eval(expression).format({ precision: prec }).split(" ")[0];
            return parseFloat(ans).toFixed(this.determinePrecision(ans));
        },

        convert: function( side ) {

            // if side isn't defined, default to right
            var side = side || "right"

            this.setValues();
            if(side === "right") {
                var expression = this.leftValue + " " + this.leftUnit + " to " + this.rightUnit;
                $convert_right.val(this.eval(expression, this.leftValue.length));
            } else {
                var expression = this.rightValue + " " + this.rightUnit + " to " + this.leftUnit;
                $convert_left.val(this.eval(expression, this.rightValue.length));
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
            Units[key].units.sort(function(a, b) {
                var softA = a.name.toUpperCase();
                var softB = b.name.toUpperCase();
                return (softA < softB) ? -1 : (softA > softB) ? 1 : 0;
            });

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
                { symbol: 'rad',           name: 'Radians' },
                { symbol: 'deg',           name: 'Degrees' },
                { symbol: 'grad',          name: 'Gradians' },
                { symbol: 'cycle',         name: 'Cycles' },
                { symbol: 'arcsec',        name: 'Arcsecond' },
                { symbol: 'arcmin',        name: 'Arcminute' },
                { symbol: 'millirad',      name: 'Milliradian' },
                { symbol: 'microrad',      name: 'Microradian' },
                { symbol: 'milliarcsec',   name: 'Milliarcsecond' },
                { symbol: 'microarcsec',   name: 'Microarcsecond' },
                { symbol: 'rev',           name: 'Revolution' }
            ],
            defaults: ['deg', 'rad']
        },
        area: {
            name: "Area",
            units: [
                { symbol: 'm2',             name: 'Square Meter' },
                { symbol: 'sqin',           name: 'Square Inch' },
                { symbol: 'sqft',           name: 'Square Feet' },
                { symbol: 'sqyd',           name: 'Square Yard' },
                { symbol: 'sqmi',           name: 'Square Mile' },
                { symbol: 'acre',           name: 'Acre' },
                { symbol: 'hectare',        name: 'Hectare' },
                { symbol: 'barn',           name: 'Barn' },
                { symbol: 'rood',           name: 'Rood' },
                { symbol: 'squarerod',      name: 'Square Rod' },
                { symbol: 'are',            name: 'Are' },
                { symbol: 'sqdecimeter',    name: 'Square Decimeter' },
                { symbol: 'sqcentimeter',   name: 'Square Centimeter' },
                { symbol: 'sqmillimeter',   name: 'Square Millimeter' },
            ],
            defaults: ['m2', 'sqin']
        },
        data_transfer: {
            name: "Data Transfer Rate",
            units: [
                { symbol: 'bitps',       name: 'Bits per second'},
                { symbol: 'kbitps',      name: 'Kilobit per second'},
                { symbol: 'mbitps',      name: 'Megabit per second'},
                { symbol: 'gbitps',      name: 'Gigabit per second'},
                { symbol: 'tbitps',      name: 'Terabit per second'},
                { symbol: 'kilobyteps',  name: 'Kilobyte per second'},
                { symbol: 'megabyteps',  name: 'Megabyte per second'},
                { symbol: 'gigabyteps',  name: 'Gigabyte per second'},
                { symbol: 'terabyteps',  name: 'Terabyte per second'},
                { symbol: 'kibps',       name: 'Kibibit per second'},
                { symbol: 'mibps',       name: 'Mebibit per second'},
                { symbol: 'gibps',       name: 'Gibibit per second'},
                { symbol: 'tibps',       name: 'Tebibit per second'},
            ],
            defaults: ['bitps', 'kbitps']
        },
        digital: {
            name: "Digital Storage",
            units: [
                { symbol: 'b',          name: 'Bit' },
                { symbol: 'B',          name: 'Byte' },
                { symbol: 'kbit',       name: 'Kilobit' },
                { symbol: 'mbit',       name: 'Megabit' },
                { symbol: 'gbit',       name: 'Gigabit' },
                { symbol: 'tbit',       name: 'Terrabit' },
                { symbol: 'KB',         name: 'Kilobyte' },
                { symbol: 'MB',         name: 'Megabyte' },
                { symbol: 'GB',         name: 'Gigabyte' },
                { symbol: 'TB',         name: 'Terabyte' },
                { symbol: 'PB',         name: 'Petabyte' },
                { symbol: 'kibibit',    name: 'Kibibit' },
                { symbol: 'mebibit',    name: 'Mebibit' },
                { symbol: 'gibibit',    name: 'Gibibit' },
                { symbol: 'tebibit',    name: 'Tebibit' },
                { symbol: 'pebibit',    name: 'Pebibit' },
                { symbol: 'kibibyte',   name: 'Kibibyte' },
                { symbol: 'mebibyte',   name: 'Mebibyte' },
                { symbol: 'gibibyte',   name: 'Gibibyte' },
                { symbol: 'tebibyte',   name: 'Tebibyte' },
                { symbol: 'pebibyte',   name: 'Pebibyte' },
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
                { symbol: 'month',          name: 'Months' },
                { symbol: 'year',           name: 'Years' },
                { symbol: 'decade',         name: 'Decade' },
                { symbol: 'century',        name: 'Century' },
                { symbol: 'millennium',     name: 'Millennium' },
                { symbol: 'femtosecond',    name: 'Femtosecond'},
                { symbol: 'picosecond',     name: 'Picosecond'},
                { symbol: 'fortnight',      name: 'Fortnight'},
                { symbol: 'siderealyear',   name: 'Sidereal Year'},
            ],
            defaults: ['minute', 'second']
        },
        energy: {
            name: "Energy",
            units: [
                { symbol: 'joule',                  name: 'Joule' },
                { symbol: 'kilojoule',              name: 'Kilojoule' },
                { symbol: 'gramcalorie',            name: 'Gramcalorie' },
                { symbol: 'kilocalorie',            name: 'Kilocalorie' },
                { symbol: 'Wh',                     name: 'Watt Hour' },
                { symbol: 'ergfixed',               name: 'Erg' },
                { symbol: 'BTU',                    name: 'BTU' },
                { symbol: 'electronvolt',           name: 'Electronvolt' },
                { symbol: 'footpound',              name: 'Foot Pound'},
                { symbol: 'decielectronvolt',       name: 'Decielectron volt'},
                { symbol: 'centielectronvolt',      name: 'Centielectron volt'},
                { symbol: 'millielectronvolt',      name: 'Millielectron volt'},
                { symbol: 'microelectronvolt',      name: 'Microelectron volt'},
                { symbol: 'nanoelectronvolt',       name: 'Nanoelectron volt'},
                { symbol: 'picoelectronvolt',       name: 'Picoelectron volt'},
                { symbol: 'femtoelectronvolt',      name: 'Femtoelectron volt'},
                { symbol: 'attoelectronvolt',       name: 'Attoelectron volt'},
                { symbol: 'zeptoelectronvolt',      name: 'Zeptoelectron volt'},
                { symbol: 'yoctoelectronvolt',      name: 'Yoctoelectron volt'},
                { symbol: 'decaelectronvolt',       name: 'Decaelectron volt'},
                { symbol: 'hectoelectronvolt',      name: 'Hectoelectron volt'},
                { symbol: 'kiloelectronvolt',       name: 'Kiloelectron volt'},
                { symbol: 'megaelectronvolt',       name: 'Megaelectron volt'},
                { symbol: 'gigaelectronvolt',       name: 'Gigaelectron volt'},
                { symbol: 'teraelectronvolt',       name: 'Teraelectron volt'},
                { symbol: 'petaelectronvolt',       name: 'Petaelectron volt'},
                { symbol: 'exaelectronvolt',        name: 'Exaelectron volt'},
                { symbol: 'zettaelectronvolt',      name: 'Zettaelectron volt'},
                { symbol: 'yottaelectronvolt',      name: 'Yottaelectron volt'},
            ],
            defaults: ['joule', 'Wh']
        },
        force: {
            name: "Force",
            units: [
                { symbol: 'newton',         name: 'Newton' },
                { symbol: 'dyne',           name: 'Dyne' },
                { symbol: 'poundforce',     name: 'Pound Force' },
                { symbol: 'kip',            name: 'Kip' },
                { symbol: 'kilonewton',     name: 'Kilo Newton' },
                { symbol: 'gramforce',      name: 'Gram Force' },
                { symbol: 'ounceforce',     name: 'Ounce Force' },
                { symbol: 'kilogramforce',  name: 'Kilogram Force' },
                { symbol: 'metrictonforce', name: 'Ton Force Metric' },
            ],
            defaults: ['newton', 'dyne']
        },
        frequency: {
            name: "Frequency",
            units: [
                { symbol: 'microhertz',     name: 'Microhertz' },
                { symbol: 'millihertz',     name: 'Millihertz' },
                { symbol: 'hertz',          name: 'Hertz' },
                { symbol: 'kilohertz',      name: 'Kilohertz' },
                { symbol: 'megahertz',      name: 'Megahertz' },
                { symbol: 'gigahertz',      name: 'Gigahertz' },
                { symbol: 'terahertz',      name: 'Terahertz' },
                { symbol: 'petahertz',      name: 'Petahertz' },
                { symbol: 'exahertz',       name: 'Exahertz' },
            ],
            defaults: ['hertz', 'megahertz']
        },
        length: {
            name: "Length",
            units: [
                { symbol: 'decameter',        name: 'Decameter' },
                { symbol: 'millimeter',       name: 'Millimeter' },
                { symbol: 'decimeter',        name: 'Decimeter' },
                { symbol: 'micrometer',       name: 'Micrometer' },
                { symbol: 'nanometer',        name: 'Nanometer' },
                { symbol: 'picometer',        name: 'Picometer' },
                { symbol: 'kilometer',        name: 'Kilometer' },
                { symbol: 'meter',            name: 'Meter' },
                { symbol: 'cm',               name: 'Centimeter' },
                { symbol: 'hectometer',       name: 'Hectometer' },
                { symbol: 'chains',           name: 'Chains' },
                { symbol: 'inch',             name: 'Inch' },
                { symbol: 'foot',             name: 'Feet' },
                { symbol: 'yard',             name: 'Yard' },
                { symbol: 'mile',             name: 'Mile' },
                { symbol: 'nauticalmile',     name: 'Nautical mile'},
                { symbol: 'link',             name: 'Link' },
                { symbol: 'rod',              name: 'Rod' },
                { symbol: 'astronomicalunit', name: 'Astronomical unit'},
                { symbol: 'lightyear',        name: 'Light year'},
                { symbol: 'parsec',           name: 'Parsec'},
                { symbol: 'angstrom',         name: 'Angstrom' },
                { symbol: 'mil',              name: 'Mil' },
            ],
            defaults: ['meter', 'cm']
        },
        mass: {
            name: "Mass",
            units: [
                { symbol: 'microgram',      name: 'Microgram' },
                { symbol: 'kilogram',       name: 'Kilogram' },
                { symbol: 'milligram',      name: 'Milligram' },
                { symbol: 'gram',           name: 'Gram' },
                { symbol: 'decigram',       name: 'Decigram' },
                { symbol: 'centigram',      name: 'Centigram'},
                { symbol: 'picogram',       name: 'Picogram'},
                { symbol: 'femtogram',      name: 'Femtogram'},
                { symbol: 'dekagram',       name: 'Dekagram'},
                { symbol: 'hectogram',      name: 'Hectogram'},
                { symbol: 'megagram',       name: 'Megagram'},
                { symbol: 'ton',            name: 'Ton' },
                { symbol: 'metricton',      name: 'Metric Ton'},
                { symbol: 'longton',        name: 'Long Ton'},
                { symbol: 'shortton',       name: 'Short Ton'},
                { symbol: 'grain',          name: 'Grain' },
                { symbol: 'dram',           name: 'Dram' },
                { symbol: 'ounce',          name: 'Ounce' },
                { symbol: 'poundmass',      name: 'Pound' },
                { symbol: 'hundredweight',  name: 'Hundredweight' },
                { symbol: 'stick',          name: 'Stick' },
                { symbol: 'stone',          name: 'Stone' },
                { symbol: 'metricquintal',  name: 'Metric Quintal'},
                { symbol: 'usquintal',      name: 'US Quintal'},
                { symbol: 'frenchquintal',  name: 'French Quintal'},
                { symbol: 'troyounce',      name: 'Troy Ounce'},
                { symbol: 'slug',           name: 'Slug'},
                { symbol: 'tola',           name: 'Tola'},
                { symbol: 'carat',          name: 'Carat'},
                { symbol: 'atomicmassunit', name: 'Atomic Mass Unit'},
            ],
            defaults: ['kilogram', 'gram']
        },
        power: {
            name: "Power",
            units: [
                { symbol: 'watt',       name: 'Watt'},
                { symbol: 'hp',         name: 'HP' },
                { symbol: 'kilowatt',   name: 'Kilowatt' },
                { symbol: 'megawatt',   name: 'Megawatt' },
                { symbol: 'gigawatt',   name: 'Gigawatt' },
                { symbol: 'terawatt',   name: 'Terawatt' },
                { symbol: 'petawatt',   name: 'Petawatt' },
                { symbol: 'exawatt',    name: 'Exawatt' },
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
                { symbol: 'barye',  name: 'Barye' },
                { symbol: 'mPa',    name: 'Millipascal' },
                { symbol: 'hPa',    name: 'Hectopascal' },
                { symbol: 'kPa',    name: 'Kilopascal' },
                { symbol: 'MPa',    name: 'Megapascal' },
                { symbol: 'Satm',   name: 'Standard Atmosphere' },
                { symbol: 'at',     name: 'Technical Atmosphere' },
                { symbol: 'mbar',   name: 'Millibar' },
                { symbol: 'cbar',   name: 'Centibar' },
                { symbol: 'dbar',   name: 'Decibar' },
                { symbol: 'kbar',   name: 'Kilobar' },
                { symbol: 'Mbar',   name: 'Megabar' },
                { symbol: 'Gbar',   name: 'Gigabar' },
                { symbol: 'GPa',    name: 'Gigapascal' },
            ],
            defaults: ['Pa', 'psi']
        },
        speed: {
            name: "Speed",
            units: [
                { symbol: 'mi/h',   name: 'Miles per hour' },
                { symbol: 'ft/s',   name: 'Feet per second' },
                { symbol: 'm/s',    name: 'Metres per second' },
                { symbol: 'km/h',   name: 'Kilometres per hour'},
                { symbol: 'knot',   name: 'Knot'},
            ],
            defaults: ['mi/h', 'km/h']
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
                { symbol: 'litre',          name: 'Litre' },
                { symbol: 'millilitre',     name: 'Millilitre' },
                { symbol: 'hectolitre',     name: 'Hectolitre' },
                { symbol: 'decalitre',      name: 'Decalitre' },
                { symbol: 'decilitre',      name: 'Decilitre' },
                { symbol: 'centilitre',     name: 'Centilitre' },
                { symbol: 'cc',             name: 'Cubic Centimeter' },
                { symbol: 'cuin',           name: 'Cubic Inch' },
                { symbol: 'cuft',           name: 'Cubic Foot' },
                { symbol: 'impcup',         name: 'Cup (Imperial)' },
                { symbol: 'uscup',          name: 'Cup (US Legal)' },
                { symbol: 'cuyd',           name: 'Cubic Yard' },
                { symbol: 'pints',          name: 'Pint (US)' },
                { symbol: 'imptsp',         name: 'Teaspoon (Imperial)' },
                { symbol: 'ustsp',          name: 'Teaspoon (US)' },
                { symbol: 'imptbsp',        name: 'Tablespoon (Imperial)' },
                { symbol: 'ustbsp',         name: 'Tablespoon (US)' },
                { symbol: 'minim',          name: 'Minim' },
                { symbol: 'fluiddram',      name: 'Fluid Dram' },
                { symbol: 'impfluidounce',  name: 'Fluid Ounce (Imperial)' },
                { symbol: 'usfluidounce',   name: 'Fluid Ounce (US)' },
                { symbol: 'gill',           name: 'Gill' },
                { symbol: 'impquart',       name: 'Quart (Imperial)'},
                { symbol: 'usquart',        name: 'Quart (US)'},
                { symbol: 'usgallon',       name: 'Gallon (US)'},
                { symbol: 'impgallon',      name: 'Gallon (Imperial)'},
                { symbol: 'beerbarrel',     name: 'Beerbarrel'},
                { symbol: 'oilbarrel',      name: 'Oilbarrel'},
                { symbol: 'hogshead',       name: 'Hogshead'},
                { symbol: 'drop',           name: 'Drop'},
            ],
            defaults: ['litre', 'millilitre']
        },
    } // Units

    DDH.conversions.build = function(ops) {

        // Defaults to length if no base is supported
        var startBase = ops.data.physical_quantity || 'length';
        var rawInput = ops.data.raw_input || '1';
        var unitsSpecified = false;

        // default units
        var leftUnit = ops.data.left_unit || Units[startBase].defaults[0];
        var rightUnit = ops.data.right_unit || Units[startBase].defaults[1];

        // swaps the default unit if they are the same.
        // This conditional fires when a query such as 1 gram is entered
        if(rightUnit === leftUnit) {
            rightUnit = Units[startBase].defaults[0];
        }

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
                        try {
                            if(this.value !== "" && $.isNumeric(eval(this.value))) { Converter.convert() }
                        } catch(e) {}
                    });

                    $convert_right.keyup(function( _e ) {
                        if(this.value === "") {
                            $convert_left.val("");
                        }
                        try {
                            if(this.value !== "" && $.isNumeric(eval(this.value))) { Converter.convert("left") }
                        } catch(e) {}
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

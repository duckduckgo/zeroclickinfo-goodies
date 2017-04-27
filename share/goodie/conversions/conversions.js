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
        
        getLeftUnit: function() {
            return this.leftUnit;
        },
        
        setLeftUnit: function() {
            this.leftUnit = $select_left.val();
        },
        
        getLeftValue: function() {
            return this.leftValue;
        },
        
        setLeftValue: function() {
            this.leftValue = $convert_left.val();  
        },
        
        getRightUnit: function() {
            return this.rightUnit;  
        },
        
        setRightUnit: function() {
            this.rightUnit = $select_right.val();
        },
        
        getRightValue: function() {
            return this.rightValue;  
        },
        
        setRightValue: function() {
            this.rightValue = $convert_right.val();  
        },
        
        eval: function( expression ) {
            return math.eval(expression).format({notation: 'fixed'}).split(" ")[0];
        },
        
        convert: function( side ) {
            
            this.setValues();
            if(side === "right") {
                var expression = this.getLeftValue() + " " + this.getLeftUnit() + " to " + this.getRightUnit();
                $convert_right.val(this.eval(expression));
            } else {
                var expression = this.getRightValue() + " " + this.getRightUnit() + " to " + this.getLeftUnit();
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

            // adds the new conversion units to the selects
            for(var i = 0 ; i < Units[key].units.length ; i++) {
                $selects.append(
                    '<option value="' + Units[key].units[i] + '">' + 
                    Units[key].units[i].capitalize() + 
                    '</option>'
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
            $convert_left       = $root.find(".zci__conversions_left input"); 
            $convert_right      = $root.find(".zci__conversions_right input");
            $selects            = $root.find("span select");
            $select_right       = $root.find(".zci__conversions_right-select");
            $select_left        = $root.find(".zci__conversions_left-select");
            $unitSelector       = $root.find(".zci__conversions_bottom-select");
            localDOMInitialized = true;
        },
        
        // a function to get if is a number
        isNumber: function( n ) {
            return !isNaN(parseFloat(n)) && isFinite(n);
        }
    } // Utils
    
    var Units = {
        length: {
            name: "Length",
            units: ['meter', 'cm', 'inch', 'foot', 'yard', 'mile', 'link', 'rod', 'angstrom', 'mil'],
            defaults: ['meter', 'cm']
        },
        surface: {
            name: "Surface",
            units: ['m2', 'sqin', 'sqft', 'sqyd', 'sqmi', 'sqrd', 'sqch', 'sqmil', 'acre', 'hectare'],
            defaults: ['m2', 'sqin']
        },
        volume: {
            name: "Volume",
            units: ['litre', 'millilitre', 'cc', 'cuin', 'cuft', 'cuyd', 'teaspoon', 'tablespoon'],
            defaults: ['litre', 'millilitre']
        },
        liquid_volume: {
            name: "Liquid Volume",
            units: ['minim', 'fluiddram', 'fluidounce', 'gill', 'cup', 'pint', 'quart', 'gallon', 'beerbarrel', 'oilbarrel', 'hogshead', 'drop'],
            defaults: ['minim', 'fluiddram']
        },
        angles: {
            name: "Angles",
            units: ['rad', 'deg', 'grad', 'cycle', 'arcsec', 'arcmin'],
            defaults: ['deg', 'rad']
        },
        time: {
            name: "Time",
            units: ['second', 'minute', 'hour', 'day', 'week', 'month', 'year', 'decade', 'century', 'millennium'],
            defaults: ['minute', 'second']
        },
        mass: {
            name: "Mass",
            units: ['kilogram', 'gram', 'tonne', 'ton', 'grain', 'dram', 'ounce', 'poundmass', 'hundredweight', 'stick', 'stone'],
            defaults: ['kilogram', 'gram']
        },
        temperature: {
            name: "Temperature",
            units: ['kelvin', 'celsius', 'fahrenheit', 'rankine'],
            defaults: ['celsius', 'fahrenheit']
        },
        force: {
            name: "Force",
            units: ['newton', 'dyne', 'poundforce', 'kip'],
            defaults: ['newton', 'dyne']
        },
        energy: {
            name: "Energy",
            units: ['joule', 'Wh', 'erg', 'Wh', 'BTU', 'electronvolt'],
            defaults: ['joule', 'Wh']
        },
        power: {
            name: "Power",
            units: ['watt', 'hp'],
            defaults: ['watt', 'hp']
        },
        pressure: {
            name: "Pressure",
            units: ['Pa', 'psi', 'atm', 'torr', 'bar', 'mmHg', 'mmH2O', 'cmH2O'],
            defaults: ['Pa', 'psi']
        },
        electricity_magnetism: {
            name: "Electricity and magnetism",
            units: ['ampere', 'coulomb', 'watt', 'volt', 'ohm', 'farad', 'weber', 'tesla', 'henry', 'siemens', 'electronvolt'],
            defaults: ['ampere', 'coulomb']
        },
        binary: {
            name: "Binary",
            units: ['bit', 'byte'],
            defaults: ['bit', 'byte']
        }
    } // Units
    

    DDH.conversions.build = function(ops) {
        
        // just defaulting to `length` for now, will change when interacting with perl backend.
        var startBase = 'length'; // replace with ternery op
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
                            $convert_left.val("1");
                            Converter.convert("right");
                        }
                        
                        initialized = true;
                    }
                    
                    $convert_left.keyup(function(_e) {
                        if(this.value === "") {
                            $convert_right.val("");
                        }
                        if(this.value !== "" && Utils.isNumber(this.value)) {
                            Converter.convert("right");   
                        }
                    });
                    
                    $convert_right.keyup(function(_e) {
                        if(this.value === "") {
                            $convert_left.val("");
                        }
                        if(this.value !== "" && Utils.isNumber(this.value)) {
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
})(DDH);
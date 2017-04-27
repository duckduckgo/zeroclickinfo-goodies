DDH.conversions = DDH.conversions || {};

(function(DDH) {
    "use strict";
  
    // UI: the input / output fields
    var $convert_left;
    var $convert_right;
    var $selects;
    
    // a capitalize method to string literals
    String.prototype.capitalize = function() {
        return this.charAt(0).toUpperCase() + this.slice(1);
    }
    
    var Converter = {
        
        // caching the root node of the IA
        DOM: DDH.getDOM("conversions"),
        
        // the local vars
        leftUnit:   "",
        rightUnit:  "",
        leftValue:  "",
        rightValue: "",
        
        setup: function() {
            this.setLeftUnit();
            this.setRightUnit();
            this.setLeftValue();
            this.setRightValue();
        },
        
        getLeftUnit: function() {
            return this.leftUnit;
        },
        
        setLeftUnit: function() {
            this.leftUnit = $(".zci__conversions_left-select").val();
        },
        
        getLeftValue: function() {
            return this.leftValue;
        },
        
        setLeftValue: function() {
            this.leftValue = $("#zci__conversions-left-in").val();  
        },
        
        getRightUnit: function() {
            return this.rightUnit;  
        },
        
        setRightUnit: function() {
            this.rightUnit = $(".zci__conversions_right-select").val();
        },
        
        getRightValue: function() {
            return this.rightValue;  
        },
        
        setRightValue: function() {
            this.rightValue = $("#zci__conversions-right-in").val();  
        },
        
        eval: function(expression) {
            return math.eval(expression).format({precision: 6}).split(" ")[0]
        },
        
        convert: function(side) {
            this.setup();
            if(side === "right") {
                var expression = this.getLeftValue() + " " + this.getLeftUnit() + " to " + this.getRightUnit();
                $convert_right.val(this.eval(expression));
            } else {
                var expression = this.getRightValue() + " " + this.getRightUnit() + " to " + this.getLeftUnit();
                $convert_left.val(this.eval(expression));
            }
        },
        
        updateUnitSelectors: function(key) {

            // removes all the options
            $(".zci__conversions_left-select").empty();
            $(".zci__conversions_right-select").empty();

            // adds the new conversion units to the selects
            for(var i = 0 ; i < Units[key].units.length ; i++) {
                $selects.append(
                    '<option value="' + Units[key].units[i] + '">' + 
                    Units[key].units[i].capitalize() + 
                    '</option>'
                );
            }

            // set defaults. written this way for readability
            $(".zci__conversions_left-select").val(Units[key].defaults[0]);
            $(".zci__conversions_right-select").val(Units[key].defaults[1]);
        }
    
    } // Converter
    

    var Utils = {
        
        // a function to get if is a number
        isNumber: function(n) {
            return !isNaN(parseFloat(n)) && isFinite(n);
        }
    } // Utils
    
    var Units = {
        length: {
            name: "Length",
            units: ['meter', 'cm', 'inch', 'foot', 'yard', 'mile', 'link', 'rod', 'chain', 'angstrom', 'mil'],
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
        
        return {
            signal: "high",
            onShow: function() {
                DDG.require('math.js', function() {

                    $convert_left = $(".zci__conversions_left input"); 
                    $convert_right = $(".zci__conversions_right input");
                    $selects = $("span select");
                    var $select_right = $(".zci__conversions_right-select");
                    var $select_left  = $(".zci__conversions_left-select");
                    var $unitSelector = $(".zci__conversions_bottom-select");
                    
                    // just defaulting to `length` for now, will change when interacting with perl backend.
                    var startBase = 'length';
                    var unitsSpecified = false;
                    Converter.updateUnitSelectors(startBase);
                    
                    // adds the different unit types to the selector
                    var unitKeys = Object.keys(Units);
                    $.each(unitKeys.sort(), function(_key, value) {
                         $unitSelector.append(
                             '<option value="'+value+'"' + (value === startBase ? " selected='selected'" : "") + '>'
                             + Units[value].name +
                             '</option>'
                         );
                    });
                    
                    // if no numbers provided, fall back on 1
                    if(!unitsSpecified) {
                        $convert_left.val("1");
                        Converter.convert("right");
                    }
                    
                    $convert_left.keyup(function(e) {
                        if(this.value === "") {
                            $convert_right.val("");
                        }
                        if(this.value !== "" && Utils.isNumber(this.value)) {
                            Converter.convert("right");   
                        }
                    });
                    
                    $convert_right.keyup(function(e) {
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
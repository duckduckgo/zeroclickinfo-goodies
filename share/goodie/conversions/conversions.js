DDH.conversions = DDH.conversions || {};

(function(DDH) {
    "use strict";
    
    String.prototype.capitalize = function() {
        return this.charAt(0).toUpperCase() + this.slice(1);
    }
    
    // the input / output fields
    var $convert_left,
        $convert_right;
    
    var $selects;
    
    // conversion classes and units
    var Units = {
        length: {
            name: "Length",
            units: ['meter', 'cm', 'inch', 'foot', 'yard', 'mile', 'link', 'rod', 'chain', 'angstrom', 'mil'],
            defaults: ['cm', 'meter']
        },
        surface: {
            name: "Surface",
            units: ['m2', 'sqin', 'sqft', 'sqyd', 'sqmi', 'sqrd', 'sqch', 'sqmil', 'acre', 'hectare'],
            defaults: ['m2', 'sqin']
        },
        volume: {
            name: "Volume",
            units: ['litre', 'cc', 'cuin', 'cuft', 'cuyd', 'teaspoon', 'tablespoon'],
            defaults: ['tablespoon', 'litre']
        },
        liquid_volume: {
            name: "Liquid Volume",
            units: ['minim', 'fluiddram', 'fluidounce', 'gill', 'cup', 'pint', 'quart', 'gallon', 'beerbarrel', 'oilbarrel', 'hogshead', 'drop'],
            defaults: ['minim', 'fluiddram']
        },
        angles: {
            name: "Angles",
            units: ['rad', 'deg', 'grad', 'cycle', 'arcsec', 'arcmin'],
            defaults: ['rad', 'deg']
        },
        time: {
            name: "Time",
            units: ['second', 'minute', 'hour', 'day', 'week', 'month', 'year', 'decade', 'century', 'millennium'],
            defaults: ['second', 'minute']
        },
        mass: {
            name: "Mass",
            units: ['gram', 'tonne', 'ton', 'grain', 'dram', 'ounce', 'poundmass', 'hundredweight', 'stick', 'stone'],
            defaults: ['gram', 'tonne']
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
            units: ['joule', 'erg', 'Wh', 'BTU', 'electronvolt'],
            defaults: ['joule', 'erg']
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
    }

    // Convertor: the object that handles the conversions
    var Converter = {
        firstUnit: "",
        secondUnit: "",
        firstValue: "",
        secondValue: "",
        
        getFirstUnit: function() {
            this.firstUnit = $("select.zci__conversions_left-select").val();
        },
        
        getFirstValue: function() {
            this.firstValue = $("#zci__conversions-left-in").val();  
        },
        
        getSecondUnit: function() {
            this.secondUnit = $("select.zci__conversions_right-select").val();
        },
        
        getSecondValue: function() {
            this.secondValue = $("#zci__conversions-right-in").val();  
        },
        
        setup: function() {
            this.getFirstUnit();
            this.getSecondUnit();
            this.getFirstValue();
            this.getSecondValue();
        },
        
        convert: function(side) {
            this.setup();
            if(side === "right") {
                var expression = this.firstValue + " " + this.firstUnit + " to " + this.secondUnit;
                var conversion = math.eval(expression).toString().replace(/[^\d.-]/g, '').trim();
                $convert_right.val(conversion);
            } else {
                var expression = this.secondValue + " " + this.secondUnit + " to " + this.firstUnit;
                var conversion = math.eval(expression).toString().replace(/[^\d.-]/g, '').trim();
                $convert_left.val(conversion);
            }
        }
    }
    
    function updateSelects(key) {
        
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
    
    function resetToOne() {
        // sets the left unit to 1
        $convert_left.val("1");
    }
    
    DDH.conversions.build = function(ops) {
        
        return {
            signal: "high",
            onShow: function() {
                DDG.require('math.js', function() {

                    $convert_left = $(".zci__conversions_left input"); 
                    $convert_right = $(".zci__conversions_right input");
                    $selects = $(".zci__conversion-container select");
                    var $select_right = $(".zci__conversions_right-select");
                    var $select_left  = $(".zci__conversions_left-select");
                    var $unitSelector = $(".zci__conversions_bottom-select");
                    
                    updateSelects('length');
                    
                    // adds the different unit types to the selector
                    var unitKeys = Object.keys(Units);
                    $.each(unitKeys, function(_key, value) {
                         $unitSelector.append('<option value="'+value+'">'+Units[value].name+'</option>');
                    });
                    
                    $convert_left.keyup(function(e) {
                        if(this.value === "") {
                            $convert_right.val("");
                        }
                        if(this.value !== "") {
                            Converter.convert("right");   
                        }
                    });
                    
                    $convert_right.keyup(function(e) {
                        if(this.value === "") {
                            $convert_left.val("");
                        }
                        if(this.value !== "") {
                            Converter.convert("left");   
                        }
                    });
                    
                    $select_right.change(function() {
                        Converter.convert("right");
                    });
                    
                    $select_left.change(function() {
                        Converter.convert("left"); 
                    });
                    
                    $unitSelector.change(function() {
                        updateSelects(this.value);
                        $convert_right.val("1");
                        Converter.convert("left");
                    });
                    
                });
                
            }// on show
        }; // return
    }; // DDH.conversions.build
})(DDH);
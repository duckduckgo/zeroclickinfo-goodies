DDH.conversions = DDH.conversions || {};

(function(DDH) {
    "use strict";
    
    String.prototype.capitalize = function() {
        return this.charAt(0).toUpperCase() + this.slice(1);
    }
    
    // the input / output fields
    var $convert_from,
        $convert_to;
    
    var $selects;
    
    // conversion classes and units
    var Units = {
        length: {
            name: "Length",
            units: ['meter', 'inch', 'foot', 'yard', 'mile', 'link', 'rod', 'chain', 'angstrom', 'mil']
        },
        surface: {
            name: "Surface",
            units: ['m2', 'sqin', 'sqft', 'sqyd', 'sqmi', 'sqrd', 'sqch', 'sqmil', 'acre', 'hectare']
        },
        volume: {
            name: "Volume",
            units: ['m3', 'litre', 'cc', 'cuin', 'cuft', 'cuyd', 'teaspoon', 'tablespoon']
        },
        liquid_volume: {
            name: "Liquid Volume",
            units: ['minim', 'fluiddram', 'fluidounce', 'gill', 'cup', 'pint', 'quart', 'gallon', 'beerbarrel', 'oilbarrel', 'hogshead', 'drop']
        },
        angles: {
            name: "Angles",
            units: ['rad', 'deg', 'grad', 'cycle', 'arcsec', 'arcmin']
        },
        time: {
            name: "Time",
            units: ['second', 'minute', 'hour', 'day', 'week', 'month', 'year', 'decade', 'century', 'millennium']
        },
        mass: {
            name: "Mass",
            units: ['gram', 'tonne', 'ton', 'grain', 'dram', 'ounce', 'poundmass', 'hundredweight', 'stick', 'stone']
        },
        temperature: {
            name: "Temperature",
            units: ['kelvin', 'celsius', 'fahrenheit', 'rankine']
        },
        force: {
            name: "Force",
            units: ['newton', 'dyne', 'poundforce', 'kip']
        },
        energy: {
            name: "Energy",
            units: ['joule', 'erg', 'Wh', 'BTU', 'electronvolt']
        },
        power: {
            name: "Power",
            units: ['watt', 'hp']
        },
        pressure: {
            name: "Pressure",
            units: ['Pa', 'psi', 'atm', 'torr', 'bar', 'mmHg', 'mmH2O', 'cmH2O']
        },
        electricity_magnetism: {
            name: "Electricity and magnetism",
            units: ['ampere', 'coulomb', 'watt', 'volt', 'ohm', 'farad', 'weber', 'tesla', 'henry', 'siemens', 'electronvolt']
        },
        binary: {
            name: "Binary",
            units: ['bit', 'byte']
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
        
        convert: function() {
            this.setup();
            var expression = this.firstValue + " " + this.firstUnit + " to " + this.secondUnit;
            console.log("Expression: " + expression);
            var conversion = math.eval(expression).toString();;
            console.log("Conversion " + conversion);
            $convert_to.val(conversion);
        }
    }
    
    function updateSelects(key) {
        
        $(".zci__conversions_left-select").empty();
        $(".zci__conversions_right-select").empty();
        
        for(var i = 0 ; i < Units[key].units.length ; i++) {
            $selects.append('<option value="'+Units[key].units[i]+'">'+Units[key].units[i].capitalize()+'</option>');
            console.log(Units[key].units[i]);
        }
        
    } 
    
    function resetToOne() {
        $("input#zci__conversions-left-in").val("1");
    }
    
    DDH.conversions.build = function(ops) {
        
        return {
            signal: "high",
            onShow: function() {
                DDG.require('math.js', function() {

                    $convert_from = $(".zci__conversions_left input"); 
                    $convert_to   = $(".zci__conversions_right input");
                    $selects = $(".zci__conversion-container select");
                    var $unitSelector = $(".zci__conversions_bottom-select");
                    
                    for(var i = 0 ; i < Units.length.units.length ; i++) {
                        $selects.append('<option value="'+Units.length.units[i]+'">'+Units.length.units[i]+'</option>');
                    }
                    
                    // adds the different unit types to the selector
                    var unitKeys = Object.keys(Units);
                    $.each(unitKeys, function(_key, value) {
                         $unitSelector.append('<option value="'+value+'">'+Units[value].name+'</option>');
                    });
                    
                    $unitSelector.change(function() {
                        resetToOne();
                        updateSelects(this.value);
                        Converter.convert();
                    });
                    
                    $convert_from.keyup(function(e) {
                        if(this.value !== "") {
                            Converter.convert();   
                        } else {
                            $convert_to.val("");
                        }
                    });
                    
                    $selects.change(function() {
                        Converter.convert();
                    });
                    
                });
                
            }// on show
        }; // return
    }; // DDH.conversions.build
})(DDH);
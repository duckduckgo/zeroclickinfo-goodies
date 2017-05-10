GLOBAL.DDH = {};

var math = require('mathjs');
var Converter = require("../share/goodie/conversions/conversions.js");

/**
 * conversions_spec.js
 *
 * This file is for testing custom units defined in Converter.customUnits
 */

// custom units that are not supported by math.js
function setUpCustomUnits() {
    for (var i = 0 ; i < Converter.customUnits.length ; i++) {
        math.createUnit(
                Converter.customUnits[i].name,
                Converter.customUnits[i].factor
            )
    };
}

// removes the unit
function stripUnit( string ) {
    return string.toString().split(" ")[0];
}

describe("Conversion of Custom Units", function() {

    setUpCustomUnits();

    /**
     * CUSTOM DIGITAL UNITS
     */
    it("should convert gb to mb", function() { 
        var conversion = stripUnit(math.eval("2GB to MB"));
        expect(conversion).toEqual("2000");
    });

    it("should convert TB to MB", function() { 
        var conversion = stripUnit(math.eval("8TB to MB"));
        expect(conversion).toEqual("8e+6");
    });

    it("should convert GB to TB", function() { 
        var conversion = stripUnit(math.eval("1000GB to TB"));
        expect(conversion).toEqual("1");
    });

    it("should convert GB to TB", function() { 
        var conversion = stripUnit(math.eval("100GB to TB"));
        expect(conversion).toEqual("0.1");
    });

    it("should convert TB to GB", function() { 
        var conversion = stripUnit(math.eval("1TB to GB"));
        expect(conversion).toEqual("1000");
    });

    it("should convert MB to TB", function() { 
        var conversion = stripUnit(math.eval("3500MB to TB"));
        expect(conversion).toEqual("0.0035");
    });

    it("should convert PB to TB", function() { 
        var conversion = stripUnit(math.eval("5PB to TB"));
        expect(conversion).toEqual("5000");
    });

    it("should convert PB to GB", function() { 
        var conversion = stripUnit(math.eval("7PB to GB"));
        expect(conversion).toEqual("7e+6");
    });

    it("should convert PB to GB", function() { 
        var conversion = stripUnit(math.eval("7PB to GB"));
        expect(conversion).toEqual("7e+6");
    });

    it("should convert MB to gbits", function() { 
        var conversion = stripUnit(math.eval("6500MB to gbit"));
        expect(conversion).toEqual("52");
    });

    it("should convert mbits to gbits", function() { 
        var conversion = stripUnit(math.eval("100000mbit to gbit"));
        expect(conversion).toEqual("100");
    });

    it("should convert tbits to mbits", function() { 
        var conversion = stripUnit(math.eval(".5tbit to mbit"));
        expect(conversion).toEqual("5e+5");
    });

    /**
     * CUSTOM ENERGY UNITS
     */
    it("should convert joules to kilojoules", function() { 
        var conversion = stripUnit(math.eval("8888joules to kilojoule"));
        expect(conversion).toEqual("8.888");
    });

    it("should convert joules to kilojoules", function() { 
        var conversion = stripUnit(math.eval("34311joules to kilojoule"));
        expect(conversion).toEqual("34.311");
    });

    it("should convert gram calories to kilojoules", function() { 
        var conversion = stripUnit(math.eval("34311323gramcalorie to kilojoule"));
        expect(conversion).toEqual("1.43558575432e+5");
    });

    it("should convert kilocalorie to kilojoules", function() { 
        var conversion = stripUnit(math.eval("6543kilocalorie to kilojoule"));
        expect(conversion).toEqual("27375.912");
    });

    /**
     * CUSTOM POWER UNITS
     */
    it("should convert watt to kilowatt", function() {
        var conversion = stripUnit(math.eval("12345watt to kilowatt"));
        expect(conversion).toEqual("12.345");
    });

    it("should convert watt to megawatt", function() {
        var conversion = stripUnit(math.eval("12345000watt to megawatt"));
        expect(conversion).toEqual("12.345");
    });

    it("should convert gigawatt to kilowatt", function() {
        var conversion = stripUnit(math.eval("12345gigawatt to kilowatt"));
        expect(conversion).toEqual("1.2345e+10");
    });

    it("should convert terawatt to gigawatt", function() {
        var conversion = stripUnit(math.eval("12345terawatt to gigawatt"));
        expect(conversion).toEqual("1.2345e+7");
    });

    it("should convert terawatt to petawatt", function() {
        var conversion = stripUnit(math.eval("12345000terawatt to petawatt"));
        expect(conversion).toEqual("12345");
    });

    it("should convert petawatt to exawatt", function() {
        var conversion = stripUnit(math.eval("12345petawatt to exawatt"));
        expect(conversion).toEqual("12.345");
    });
});

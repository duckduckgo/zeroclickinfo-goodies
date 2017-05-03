GLOBAL.DDH = {};

var math = require("mathjs");

var Converter = require("../share/goodie/conversions/conversions.js");

describe("Conversion of Custom Units", function() {

    // set up the custom units
    Converter.setUpCustomUnits();

    /**
     * CUSTOM DIGITAL UNITS
     */
    it("should convert gb to mb", function() { 
        var conversion = Converter.eval("2GB to MB");
        expect(conversion).toEqual("2000");
    });

    it("should convert TB to MB", function() { 
        var conversion = Converter.eval("8TB to MB");
        expect(conversion).toEqual("8e+6");
    });

    it("should convert GB to TB", function() { 
        var conversion = Converter.eval("1000GB to TB");
        expect(conversion).toEqual("1");
    });

    it("should convert GB to TB", function() { 
        var conversion = Converter.eval("100GB to TB");
        expect(conversion).toEqual("0.1");
    });

    it("should convert TB to GB", function() { 
        var conversion = Converter.eval("1TB to GB");
        expect(conversion).toEqual("1000");
    });

    it("should convert MB to TB", function() { 
        var conversion = Converter.eval("3500MB to TB");
        expect(conversion).toEqual("0.0035");
    });

    it("should convert PB to TB", function() { 
        var conversion = Converter.eval("5PB to TB");
        expect(conversion).toEqual("5000");
    });

    it("should convert PB to GB", function() { 
        var conversion = Converter.eval("7PB to GB");
        expect(conversion).toEqual("7e+6");
    });

    it("should convert PB to GB", function() { 
        var conversion = Converter.eval("7PB to GB");
        expect(conversion).toEqual("7e+6");
    });

    it("should convert MB to gbits", function() { 
        var conversion = Converter.eval("6500MB to gbit");
        expect(conversion).toEqual("52");
    });

    it("should convert mbits to gbits", function() { 
        var conversion = Converter.eval("100000mbit to gbit");
        expect(conversion).toEqual("100");
    });

    it("should convert tbits to mbits", function() { 
        var conversion = Converter.eval(".5tbit to mbit");
        expect(conversion).toEqual("5e+5");
    });

    /**
     * CUSTOM ENERGY UNITS
     */
    it("should convert joules to kilojoules", function() { 
        var conversion = Converter.eval("8888joules to kilojoule");
        expect(conversion).toEqual("8.888");
    });

    it("should convert joules to kilojoules", function() { 
        var conversion = Converter.eval("34311joules to kilojoule");
        expect(conversion).toEqual("34.311");
    });

    it("should convert gram calories to kilojoules", function() { 
        var conversion = Converter.eval("34311323gramcalorie to kilojoule");
        expect(conversion).toEqual("1.43559e+5");
    });

    it("should convert kilocalorie to kilojoules", function() { 
        var conversion = Converter.eval("6543kilocalorie to kilojoule");
        expect(conversion).toEqual("27375.9");
    });

});
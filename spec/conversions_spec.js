GLOBAL.DDH = {};

var Converter = require("../share/goodie/conversions/conversions.js");

describe("Converter", function() {

    // set up the custom units
    Converter.setUpCustomUnits();

    it("should convert gb to mb", function() { 
        var conversion = Converter.eval("2GB to MB");
        expect(conversion).toEqual("2000");
    });

    it("should convert gb to mb", function() { 
        var conversion = Converter.eval("8TB to MB");
        expect(conversion).toEqual("8e+6");
    });

});
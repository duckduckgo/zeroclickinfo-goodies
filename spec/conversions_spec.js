GLOBAL.DDH = {};

// Imports / Obj References
var conversions_goodie = require("../share/goodie/conversions/conversions.js");
var Converter = conversions_goodie.Converter;
var Utils = conversions_goodie.Utils;

//
// Utils
// 
describe("Conversion Utils", function() {
   
    it("The string `20` should be a number", function() {
        expect(Utils.isNumber("20")).toEqual(true);
    });

    it("The string `-50` should be a number", function() {
        expect(Utils.isNumber("-50")).toEqual(true);
    });

    it("The string `50.321` should be a number", function() {
        expect(Utils.isNumber("50.321")).toEqual(true);
    });

    it("The string `dax` shouldn't be a number", function() {
        expect(Utils.isNumber("dax")).toEqual(false);
    });

    it("The string `DuckDuckGo.com` shouldn't be a number", function() {
        expect(Utils.isNumber("DuckDuckGo.com")).toEqual(false);
    });

    it("The raw number `60` should be a number", function() {
        expect(Utils.isNumber(60)).toEqual(true);
    });
    
    it("The raw boolean true shouldn't be a number", function() {
        expect(Utils.isNumber(true)).toEqual(false);
    });
});
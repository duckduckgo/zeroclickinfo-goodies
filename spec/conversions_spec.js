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
     * CUSTOM AREA UNITS
     */
    it("should convert barns to are", function() {
        var conversion = stripUnit(math.eval("1barn to are"));
        expect(conversion).toEqual("1e-30");
    });

    it("should convert rood to square feet", function() {
        var conversion = stripUnit(math.eval("7rood to sqft"));
        expect(conversion).toEqual("76229.9995780547");
    });

    it("should convert square decimeter to are", function() {
        var conversion = stripUnit(math.eval("323412sqdecimeter to are"));
        expect(conversion).toEqual("32.3412");
    });

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
     * CUSTOM DURATION UNITS
     */
    it("should convert picoseconds to femtoseconds", function() {
        var conversion = stripUnit(math.eval("6picosecond to femtosecond"));
        expect(conversion).toEqual("6000");
    });

    it("should convert fortnight to days", function() {
        var conversion = stripUnit(math.eval("2fortnight to day"));
        expect(conversion).toEqual("28");
    });

    it("should sidereal years to years", function() {
        var conversion = stripUnit(math.eval("2siderealyear to year"));
        expect(conversion).toEqual("2.00003482");
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
     * CUSTOM LENGTH UNITS
     */
    it("should convert nautical mile to meters", function() {
       var conversion = stripUnit(math.eval("1nauticalmile to meter"));
       expect(conversion).toEqual("1852");
    });

    it("should convert one li to meters", function() {
       var conversion = stripUnit(math.eval("1li to meter"));
       expect(conversion).toEqual("500");
    });

    it("should convert one marathon to kilometers", function() {
       var conversion = stripUnit(math.eval("1marathon to kilometer"));
       expect(conversion).toEqual("42.195");
    });

    it("should convert one nauticalmile to 1852 metres", function() {
      var conversion = stripUnit(math.eval("nauticalmile to metres"));
      expect(conversion).toBe("1852")
    });
  
    it("should convert one halfmarathon to 21.0975 kilometres", function() {
      var conversion = stripUnit(math.eval("halfmarathon to kilometres"));
      expect(conversion).toBe("21.0975")
    });
  
    it("should convert one marathon to 42.195 kilometres", function() {
      var conversion = stripUnit(math.eval("marathon to kilometres"));
      expect(conversion).toBe("42.195")
    });
  
    it("should convert one li to 500 metres", function() {
      var conversion = stripUnit(math.eval("li to metres"));
      expect(conversion).toBe("500")
    });
  
    it("should convert one attometre to 0.000000000000001 metres", function() {
      var conversion = stripUnit(math.eval("attometre to metres"));
      expect(conversion).toBe("0.000000000000001")
    });
  
    it("should convert one femtometre to metres", function() {
      var conversion = stripUnit(math.eval("femtometre to metres"));
      expect(conversion).toBe("0.0000000000000001")
    });
  
    it("should convert one zeptometre to 10^-21 metres", function() {
      var conversion = stripUnit(math.eval("zeptometre to metres"));
      expect(conversion).toBe("0.0000000000000000000001")
    });
  
    it("should convert one yoctometre to 10^-23 metres", function() {
      var conversion = stripUnit(math.eval("yoctometre to metres"));
      expect(conversion).toBe("23")
    });
  
    it("should convert one dekametre to 10 metres", function() {
      var conversion = stripUnit(math.eval("dekametre to metres"));
      expect(conversion).toBe("10")
    });
  
    it("should convert one hectometre to 100 metres", function() {
      var conversion = stripUnit(math.eval("hectometre to metres"));
      expect(conversion).toBe("100")
    });
  
    it("should convert one megametre to 1000 kilometres", function() {
      var conversion = stripUnit(math.eval("megametre to kilometres"));
      expect(conversion).toBe("1000")
    });
  
    it("should convert one gigametre to 1000000 kilometres", function() {
      var conversion = stripUnit(math.eval("gigametre to kilometres"));
      expect(conversion).toBe("1000000")
    });
  
    it("should convert one terametre to 1000000000 kilometres", function() {
      var conversion = stripUnit(math.eval("terametre to kilometres"));
      expect(conversion).toBe("1000000000")
    });
  
    it("should convert one petametre to 10^15 metres", function() {
      var conversion = stripUnit(math.eval("petametre to metres"));
      expect(conversion).toBe("1000000000000000")
    });
  
    it("should convert one exametre to 10^18 metres", function() {
      var conversion = stripUnit(math.eval("exametre to metres"));
      expect(conversion).toBe("1000000000000000000")
    });
  
    it("should convert one zettametre to 10^21 metres", function() {
      var conversion = stripUnit(math.eval("zettametre to metres"));
      expect(conversion).toBe("1000000000000000000000")
    });
  
    it("should convert one yottametre to 10^24 metres", function() {
      var conversion = stripUnit(math.eval("yottametre to metres"));
      expect(conversion).toBe("1000000000000000000000000")
    });
  
    it("should convert one parsec to 3.0856776 * 10^13 kilometres", function() {
      var conversion = stripUnit(math.eval("parsec kilometres"));
      expect(conversion).toBe("30856776000000")
    });
  
    it("should convert one nanoparsec to 30.857 megametres", function() {
      var conversion = stripUnit(math.eval("nanoparsec to megametres"));
      expect(conversion).toBe("30857")
    });
  
    it("should convert one picoparsec to 30.856776 kilometres", function() {
      var conversion = stripUnit(math.eval("picoparsec to kilometres"));
      expect(conversion).toBe("30.856776")
    });
  
    it("should convert one kiloparsec to 1000 parsecs", function() {
      var conversion = stripUnit(math.eval("kiloparsec to parsecs"));
      expect(conversion).toBe("1000")
    });
  
    it("should convert one megaparsec to 1000 kiloparsecs", function() {
      var conversion = stripUnit(math.eval("megaparsec to kiloparsecs"));
      expect(conversion).toBe("1000")
    });
  
    it("should convert one gigaparsec to 1000 megaparsecs", function() {
      var conversion = stripUnit(math.eval("gigaparsec to megaparsecs"));
      expect(conversion).toBe("1000")
    });
  
    it("should convert one teraparsec to 10^12 parsecs", function() {
      var conversion = stripUnit(math.eval("teraparsec to parsecs"));
      expect(conversion).toBe("1000000000000")
    });
  
    it("should convert one astronomicalunit to 149597870700 metres", function() {
      var conversion = stripUnit(math.eval("astronomicalunit to metres"));
      expect(conversion).toBe("149597870700")
    });
  
    it("should convert one lightyear to 9460730472580800 metres", function() {
      var conversion = stripUnit(math.eval("lightyear to metres"));
      expect(conversion).toBe("9460730472580800")
    });
  
    it("should convert one league to 15840 feet", function() {
      var conversion = stripUnit(math.eval("league to feet"));
      expect(conversion).toBe("15840")
    });
  
    it("should convert one fathom to 6 feet", function() {
      var conversion = stripUnit(math.eval("fathom to feet"));
      expect(conversion).toBe("6")
    });
  
    it("should convert one smoot to 1.7018 metres", function() {
      var conversion = stripUnit(math.eval("smoot to metres"));
      expect(conversion).toBe("1.7018")
    });
  
    it("should convert one cubit to 457.2 mm", function() {
      var conversion = stripUnit(math.eval("cubit to mm"));
      expect(conversion).toBe("457.2")
    });
  
    it("should convert one furlong to 660 feet", function() {
      var conversion = stripUnit(math.eval("furlong to feet"));
      expect(conversion).toBe("660")
    });
  
    it("should convert one megafurlong to 1000000 furlongs", function() {
      var conversion = stripUnit(math.eval("megafurlong to furlongs"));
      expect(conversion).toBe("1000000")
    });
  
    it("should convert one beardsecond to 10 nanometres", function() {
      var conversion = stripUnit(math.eval("beardsecond to nanometres"));
      expect(conversion).toBe("10")
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
    
    /**
     * CUSTOM FORCE UNITS
     */
    it("should convert kilonewton to newton", function() {
        var conversion = stripUnit(math.eval("22kilonewton to newton"));
        expect(conversion).toEqual("22000");
    });

    it("should convert gramforce to newton", function() {
        var conversion = stripUnit(math.eval("1100gramforce to newton"));
        expect(conversion).toEqual("10.787315");
    });

    it("should convert ounceforce to poundforce", function() {
        var conversion = stripUnit(math.eval("10ounceforce to poundforce"));
        expect(conversion).toEqual("0.625");
    });

	   it("should convert kilogramforce to gramforce", function() {
        var conversion = stripUnit(math.eval("500kilogramforce to gramforce"));
        expect(conversion).toEqual("5e+5");
    });

    it("should convert metrictonforce to kilogramforce", function() {
        var conversion = stripUnit(math.eval("50metrictonforce to kilogramforce"));
        expect(conversion).toEqual("50000");
    });

});

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
	  * CUSTOM PRESSURE UNITS
	  */
    it("should convert barye to Satm", function() {
        var conversion = stripUnit(math.eval("10132.5barye to Satm"));
        expect(conversion).toEqual("0.009999999999999998");
    });

    it("should convert mbar to at", function() {
        var conversion = stripUnit(math.eval("1000mbar to at"));
        expect(conversion).toEqual("1.0197162129779282");
    });

    it("should convert cbar to kbar", function() {
        var conversion = stripUnit(math.eval("1000cbar to kbar"));
        expect(conversion).toEqual("0.01");
    });

    it("should convert Mbar to Gbar", function() {
        var conversion = stripUnit(math.eval("1000Mbar to Gbar"));
        expect(conversion).toEqual("1");
    });

    it("should convert dbar to cbar", function() {
        var conversion = stripUnit(math.eval("10dbar to cbar"));
        expect(conversion).toEqual("100");
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
     * CUSTOM ANGLE UNITS
     */
    it("should convert radians to microarcseconds", function() {
        var conversion = stripUnit(math.eval("5rad to microarcsec"));
        expect(conversion).toEqual("1.0313531353135312e+12");
    });

    it("should convert microarcseconds to radians", function() {
        var conversion = stripUnit(math.eval("8microarcsec to rad"));
        expect(conversion).toEqual("3.8784e-11");
    });

    it("should convert radians to milliarcseconds", function() {
        var conversion = stripUnit(math.eval("12rad to milliarcsec"));
        expect(conversion).toEqual("2.4752475247524753e+9");
    });

    it("should convert milliarcseconds to radians", function() {
        var conversion = stripUnit(math.eval("9milliarcsec to rad"));
        expect(conversion).toEqual("4.3631999999999997e-8");
    });

    it("should convert radians to microradians", function() {
        var conversion = stripUnit(math.eval("4rad to microrad"));
        expect(conversion).toEqual("4e+6");
    });

    it("should convert microradians to radians", function() {
        var conversion = stripUnit(math.eval("26microrad to rad"));
        expect(conversion).toEqual("2.6e-5");
    });

    it("should convert radians to revolutions", function() {
        var conversion = stripUnit(math.eval("16rad to rev"));
        expect(conversion).toEqual("2.546473134708429");
    });

    it("should convert revolutions to radians", function() {
        var conversion = stripUnit(math.eval("7rev to rad"));
        expect(conversion).toEqual("43.9824");
    });

    /**
     *  CUSTOM MASS UNITS
     */
    it("should convert dekagrams to grams", function() {
        var conversion = stripUnit(math.eval("143dekagram to gram"));
        expect(conversion).toEqual("1430");
    });

    it("should convert metric tons to grams", function() {
        var conversion = stripUnit(math.eval("12metricton to gram"));
        expect(conversion).toEqual("1.2e+7");
    });

    it("should convert long tons to grams", function() {
        var conversion = stripUnit(math.eval("90longton to gram"));
        expect(conversion).toEqual("9.14445e+7");
    });

    it("should convert short tons to grams", function() {
        var conversion = stripUnit(math.eval("1.892shortton to gram"));
        expect(conversion).toEqual("1.7163940199999998e+6");
    });

    it("should convert metric quintals to grams", function() {
        var conversion = stripUnit(math.eval("23metricquintal to gram"));
        expect(conversion).toEqual("2.3e+6");
    });

    it("should convert us quintals to grams", function() {
        var conversion = stripUnit(math.eval("41usquintal to gram"));
        expect(conversion).toEqual("1.859728717e+6");
    });

    it("should convert french quintals to grams", function() {
        var conversion = stripUnit(math.eval("32frenchquintal to gram"));
        expect(conversion).toEqual("4.7664e+6");
    });

    it("should convert troy ounces to grams", function() {
        var conversion = stripUnit(math.eval("1287troyounce to gram"));
        expect(conversion).toEqual("40030.174641599995");
    });

    it("should convert slugs to grams", function() {
        var conversion = stripUnit(math.eval("94slug to gram"));
        expect(conversion).toEqual("1.3718268819999998e+6");
    });

    it("should convert tolas to grams", function() {
        var conversion = stripUnit(math.eval("82tola to gram"));
        expect(conversion).toEqual("956.4319116");
    });

    it("should convert carats to grams", function() {
        var conversion = stripUnit(math.eval("423carat to gram"));
        expect(conversion).toEqual("84.60000000000001");
    });

    it("should convert atomic mass units to grams", function() {
        var conversion = stripUnit(math.eval("8734.12atomicmassunit to gram"));
        expect(conversion).toEqual("1.4503346200684524e-20");
    });

    /**
     * CUSTOM LENGTH UNITS
     */
    it("should convert nautical mile to meter", function() {
       var conversion = stripUnit(math.eval("1nauticalmile to meter"));
       expect(conversion).toEqual("1852");
    });

    it("should convert one marathon to kilometers", function() {
       var conversion = stripUnit(math.eval("1marathon to kilometer"));
       expect(conversion).toEqual("42.195");
    });

    it("should convert one nauticalmile to 1852 meters", function() {
      var conversion = stripUnit(math.eval("nauticalmile to meter"));
      expect(conversion).toBe("1852");
    });

    it("should convert one halfmarathon to 21.0975 kilometers", function() {
      var conversion = stripUnit(math.eval("halfmarathon to kilometers"));
      expect(conversion).toBe("21.0975");
    });

    it("should convert one marathon to 42.195 kilometers", function() {
      var conversion = stripUnit(math.eval("marathon to kilometers"));
      expect(conversion).toBe("42.195");
    });

    it("should convert one chinese li to 500 meters", function() {
      var conversion = stripUnit(math.eval("chineseli to meter"));
      expect(conversion).toBe("500");
    });

    it("should convert one attometre to meters", function() {
      var conversion = stripUnit(math.eval("attometre to meter"));
      expect(conversion).toBe("1e-18");
    });

    it("should convert one femtometre to meter", function() {
      var conversion = stripUnit(math.eval("femtometre to meter"));
      expect(conversion).toBe("1e-15");
    });

    it("should convert one zeptometre to 10^-21 meters", function() {
      var conversion = stripUnit(math.eval("zeptometre to meter"));
      expect(conversion).toBe("1e-21");
    });

    it("should convert one yoctometre to 10^-24 meters", function() {
      var conversion = stripUnit(math.eval("yoctometre to meter"));
      expect(conversion).toBe("1e-24");
    });

    it("should convert one dekametre to 10 meters", function() {
      var conversion = stripUnit(math.eval("dekametre to meter"));
      expect(conversion).toBe("10");
    });

    it("should convert one hectometre to 100 meters", function() {
      var conversion = stripUnit(math.eval("hectometre to meter"));
      expect(conversion).toBe("100");
    });

    it("should convert one megametre to 1000 kilometers", function() {
      var conversion = stripUnit(math.eval("megametre to kilometers"));
      expect(conversion).toBe("1000");
    });

    it("should convert one gigametre to 1000000 kilometers", function() {
      var conversion = stripUnit(math.eval("gigametre to kilometers"));
      expect(conversion).toBe("1e+6");
    });

    it("should convert one terametre to 1000000000 kilometers", function() {
      var conversion = stripUnit(math.eval("terametre to kilometers"));
      expect(conversion).toBe("1e+9");
    });

    it("should convert one petametre to meters", function() {
      var conversion = stripUnit(math.eval("petametre to meter"));
      expect(conversion).toBe("1e+15");
    });

    it("should convert one exametre to meters", function() {
      var conversion = stripUnit(math.eval("exametre to meter"));
      expect(conversion).toBe("1e+18");
    });

    it("should convert one zettametre to 10^21 meters", function() {
      var conversion = stripUnit(math.eval("zettametre to meter"));
      expect(conversion).toBe("1e+21");
    });

    it("should convert one yottametre to 10^24 meters", function() {
      var conversion = stripUnit(math.eval("yottametre to meter"));
      expect(conversion).toBe("1e+24");
    });

    it("should convert one parsec to meters", function() {
      var conversion = stripUnit(math.eval("1parsec to meter"));
      expect(conversion).toBe("3.0856776e+16");
    });

    it("should convert one nanoparsec to parsec", function() {
      var conversion = stripUnit(math.eval("nanoparsec to parsec"));
      expect(conversion).toBe("1e-9");
    });

    it("should convert one picoparsec to parsec", function() {
      var conversion = stripUnit(math.eval("picoparsec to parsec"));
      expect(conversion).toBe("1e-12");
    });

    it("should convert one kiloparsec to 1000 parsecs", function() {
      var conversion = stripUnit(math.eval("1kiloparsec to parsec"));
      expect(conversion).toBe("1000");
    });

    it("should convert one megaparsec to 1000 kiloparsecs", function() {
      var conversion = stripUnit(math.eval("1megaparsec to kiloparsec"));
      expect(conversion).toBe("1000");
    });

    it("should convert one gigaparsec to 1000 megaparsecs", function() {
      var conversion = stripUnit(math.eval("1gigaparsec to megaparsec"));
      expect(conversion).toBe("1000");
    });

    it("should convert one teraparsec to 10^12 parsecs", function() {
      var conversion = stripUnit(math.eval("1teraparsec to parsec"));
      expect(conversion).toBe("1e+12");
    });

    it("should convert one astronomicalunit to 149597870700 meters", function() {
      var conversion = stripUnit(math.eval("astronomicalunit to meter"));
      expect(conversion).toBe("1.495978707e+11");
    });

    it("should convert one lightyear to 9460730472580800 meters", function() {
      var conversion = stripUnit(math.eval("1lightyear to meter"));
      expect(conversion).toBe("9.4607304725808e+15");
    });

    it("should convert one league to 15840 feet", function() {
      var conversion = stripUnit(math.eval("league to feet"));
      expect(conversion).toBe("15840");
    });

    it("should convert one fathom to 6 feet", function() {
      var conversion = stripUnit(math.eval("fathom to feet"));
      expect(conversion).toBe("6");
    });

    it("should convert one smoot to 1.7018 meters", function() {
      var conversion = stripUnit(math.eval("smoot to meter"));
      expect(conversion).toBe("1.7018");
    });

    it("should convert one cubit to 457.2 mm", function() {
      var conversion = stripUnit(math.eval("cubit to mm"));
      expect(conversion).toBe("457.2");
    });

    it("should convert one furlong to 660 feet", function() {
      var conversion = stripUnit(math.eval("furlong to feet"));
      expect(conversion).toBe("660");
    });

    it("should convert one megafurlong to 1000000 furlong", function() {
      var conversion = stripUnit(math.eval("megafurlong to furlong"));
      expect(conversion).toBe("1e+6");
    });

    it("should convert one beardsecond to 10 nanometer", function() {
      var conversion = stripUnit(math.eval("beardsecond to nanometer"));
      expect(conversion).toBe("10");
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

    /*
     * CUSTOM ENERGY UNITS
     */
    it("should convert decielectronvolt to centielectronvolt", function() {
        var conversion = stripUnit(math.eval("50decielectronvolt to centielectronvolt"));
        expect(conversion).toEqual("500.00000000000006");
    });

    it("should convert millielectronvolt to microelectronvolt", function() {
        var conversion = stripUnit(math.eval("5millielectronvolt to microelectronvolt"));
        expect(conversion).toEqual("5000");
    });

    it("should convert nanoelectronvolt to picoelectronvolt", function() {
        var conversion = stripUnit(math.eval("5nanoelectronvolt to picoelectronvolt"));
        expect(conversion).toEqual("5000.000000000001");
    });

    it("should convert femtoelectronvolt to attoelectronvolt", function() {
        var conversion = stripUnit(math.eval("5femtoelectronvolt to attoelectronvolt"));
        expect(conversion).toEqual("5000");
    });

    it("should convert zeptoelectronvolt to yoctoelectronvolt", function() {
        var conversion = stripUnit(math.eval("5zeptoelectronvolt to yoctoelectronvolt"));
        expect(conversion).toEqual("5000.000000000001");
    });

    it("should convert decaelectronvolt to hectoelectronvolt", function() {
        var conversion = stripUnit(math.eval("5decaelectronvolt to hectoelectronvolt"));
        expect(conversion).toEqual("0.5");
    });

    it("should convert kiloelectronvolt to megaelectronvolt", function() {
        var conversion = stripUnit(math.eval("5kiloelectronvolt to megaelectronvolt"));
        expect(conversion).toEqual("0.005");
    });

    it("should convert gigaelectronvolt to teraelectronvolt", function() {
        var conversion = stripUnit(math.eval("5gigaelectronvolt to teraelectronvolt"));
        expect(conversion).toEqual("0.004999999999999999");
    });

    it("should convert petaelectronvolt to exaelectronvolt", function() {
        var conversion = stripUnit(math.eval("5petaelectronvolt to exaelectronvolt"));
        expect(conversion).toEqual("0.004999999999999999");
    });

    it("should convert zettaelectronvolt to yottaelectronvolt", function() {
        var conversion = stripUnit(math.eval("5zettaelectronvolt to yottaelectronvolt"));
        expect(conversion).toEqual("0.005");
    });
});

GLOBAL.DDH = {};
var calculator = require("../share/goodie/calculator/calculator.js");


describe("Expression Normalizer", function() {
    
  it("+ shouldn't be swapped out", function() {
    expect(calculator.normalizeExpression("2 + 2")).toEqual("2 + 2");
  });
    
  it("× should be swapped out for *", function() {
    expect(calculator.normalizeExpression("77 × 341")).toEqual("77 * 341");
  });
    
  it("`,`'s should be removed from expression", function() {
    expect(calculator.normalizeExpression("100,100,000 / 12341")).toEqual("100100000 / 12341");
  });
    
  it("`,`'s should be removed from expression", function() {
    expect(calculator.normalizeExpression("100,100,000 / 12341")).toEqual("100100000 / 12341");
  });
    
  it("`÷`'s should be swapped out for `/`", function() {
    expect(calculator.normalizeExpression("100 ÷ 12")).toEqual("100 / 12");
  });
    
  it("`π`'s should be swapped out for `(pi)`", function() {
    expect(calculator.normalizeExpression("π * 12 - 10")).toEqual("(pi) * 12 - 10");
  });

  it("`e`'s shouldn't be swapped out", function() {
    expect(calculator.normalizeExpression("e + 12 - 10")).toEqual("e + 12 - 10");
  });
    
  it("ln should be rewritten to log", function() {
    expect(calculator.normalizeExpression("ln(10) - 10")).toEqual("log(10) - 10");
  });
    
  it("ln should be rewritten to log", function() {
    expect(calculator.normalizeExpression("5 + 2! + log(55)")).toEqual("5 + 2! + log(55, 10)");
  });
    
  it("exponents should be rewritten", function() {
    expect(calculator.normalizeExpression("5<sup>3<\/sup> + 6<sup>6<\/sup> + 8<sup>2<\/sup>")).toEqual("5^3 + 6^(6) + 8^2");
  });
    
  it("There should be no empty <sup>□<\/sup>", function() {
    expect(calculator.normalizeExpression("10<sup>□<\/sup> * 10")).toEqual("10 * 10");
  });

  it("plus percentage should be rewritten", function() {
    expect(calculator.normalizeExpression("150 + 10%")).toEqual("150 * 1.10");
  });
    
  it("plus percentage should be rewritten", function() {
    expect(calculator.normalizeExpression("150 + 10% + 20%")).toEqual("150 * 1.10 * 1.20");
  });
    
  // below will pass when phase 4 merged
  it("plus percentage should be rewritten", function() {
    expect(calculator.normalizeExpression("150 + 510%")).toEqual("150 * 6.10");
  });
    
  it("minus percentage should be rewritten", function() {
    expect(calculator.normalizeExpression("140 - 10%")).toEqual("-((140*10/100) -140)");
  });  
    
});

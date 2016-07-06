DDH.formula_one_calendar = DDH.formula_one_calendar || {};

(function(DDH) {
    "use strict";

    console.log("DDH.formula_one_calendar.build"); // remove this before submitting pull request

    // define private variables and functions here
    //
    // function helper () { ... }
    //
    // var a = '',
    //     b = '',
    //     c = '';

    DDH.formula_one_calendar.build = function(ops) {

                $.each(ops.data.list, function(k,v){
                
                ops.data.list[k] = {
                    pic: v.gp[0],
                    gp: v.gp[1],
                    city: v.gp[2],
                    date: v.gp[3]
                    
                };
                });
        var date = new Date();
   
        console.log("look here:");
        console.log(date);
        
        
        return{
            
            meta: {
                sourceName: "Formula one",
                sourceUrl:"http://www.formula1.com/en/championship/races/2016.html"
            }
            
        };
        
  
        
        
        /*
        console.log("look here:");
        console.log(ops.data.list.length);
        if(ops.data.list.length <=1){
        return {
               templates:{
                   group: "text"
               }
        };
        }*/
    };
})(DDH);

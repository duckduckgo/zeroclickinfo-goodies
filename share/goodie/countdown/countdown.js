DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";

    var hasShown = false;
    var countdown;
    var loaded = false;    
    var days = 0, hours = 0, dayOfWeek = 1;
    var now,then;
    
    DDG.require('moment.js', function() {
           loaded = true;                
           //getCountdown();   
           getDiff(days,hours,dayOfWeek);            
    });       
    
    function getCountdown() {
        //console.log("getcountdown");
        var current = moment();
        var ms = moment(then,"DD/MM/YYYY HH:mm:ss").diff(moment(current,"DD/MM/YYYY HH:mm:ss"));
        var d = moment.duration(ms);
        var s = Math.floor(d.asDays()) + moment.utc(ms).format(":HH:mm:ss");			
        countdown = s;        
        //console.log(countdown);
    }
    
    function getDiff(days,hours,dayOfWeek) {
        //var now = moment();
        //var then;
        console.log("getdiff called");
        now = moment();
        console.log("today's day " + now.days());
        if(dayOfWeek < 7) {
            if(now.days() > dayOfWeek) {
                dayOfWeek += 7;
            }				
            then = moment().day(dayOfWeek);
        }
        else if(now.hours() > hours) {
            days += 1;
            then = moment().add(days,'days');
        }				
        then = moment(then).hours(hours);//.format("DD/MM/YYYY HH:mm:ss");
        //now = moment(now).format("DD/MM/YYYY HH:mm:ss");
        var ms = moment(then,"DD/MM/YYYY HH:mm:ss").diff(moment(now,"DD/MM/YYYY HH:mm:ss"));
        //var ms = moment(then).diff(moment(now,"DD/MM/YYYY HH:mm:ss"));
        var d = moment.duration(ms);
        var s = Math.floor(d.asDays()) + moment.utc(ms).format(":HH:mm:ss");			
        countdown = s;
        console.log("now " + now);			
        console.log("then " + then);
        console.log("diff " + s);
        //return countdown;
    }

    function getDayOfWeek(day) {
        switch(day) {
            case 'Sunday': 
                    return 0;
            case 'Monday':							
                    return 1;
            case 'Tuesday':
                    return 2;
            case 'Wednesday': 
                    return 3;
            case 'Thursday': 
                    return 4;
            case 'Friday': 
                    return 5;
            case 'Saturday': 
                    return 6;					
            default:
                    return 7;
        }
    }
    
    function parseQueryForTime() {
        var query = DDG.get_query();
        //var query = " 12 pm Friday"; // query of form : digits am/pm today/tomorrow/day of week
        console.log("query " + query);
        var regex = new RegExp(/[\s]+(\d{1,2})[\s]+([Aa|Pp][Mm])[\s]+(today|tomorrow|((Mon|Tues|Wednes|Thurs|Fri|Satur|Sun)(day)))?/);

        var match;//, days = 0, hours = 0, dayOfWeek = 1;
        while(true) {
            match = regex.exec(query);                                                                      
            if(match) {
                console.log(match);
                hours = parseInt(match[1]); //set number of hours from query
                if(hours == 12) {
                    hours = 0;
                }
                if(match[3] === 'tomorrow') {  //move to next day
                    days = 1;
                } else {
                    dayOfWeek = getDayOfWeek(match[3]);  //move to day specified 
                }                                                                                          
                if(match[2] === 'pm' || match[2] === 'PM') { //user will not generally write pM or Pm
                    hours += 12;
                }
                query = query.replace(match[0],'');
            } else {
                break;
                //console.log("in else");
            }
        }
        //getDiff(days,hours,dayOfWeek);
    }
    
    DDH.countdown.build = function(ops) {                
        
        return {
            id: 'countdown',
            
            templates: {
                group: 'text',
                options: {
                    content: DDH.countdown.countdown
                },
            },
            
            onShow: function() {
                if(hasShown) {
                    return;
                }                                
                console.log("in on show");
                hasShown = true;          
                
                parseQueryForTime();
                //if(loaded)
                  //  getDiff(days,hours,dayOfWeek);
                $(".time_display").html(countdown);                
                setInterval(function() {
                    getCountdown();
                    $(".time_display").html(countdown);
                }, 1000);
            }
        };
    };
})(DDH);
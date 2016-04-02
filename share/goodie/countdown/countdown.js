DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";

    var hasShown = false;
    var countdown = "";
    var loaded = false;        
    var days = 0, hours = 0, minutes = 0, dayOfWeek = 8;   
    var now,then;
    var date;
    var parsed = false;
    
    DDG.require('moment.js', function() {
           loaded = true;                           
           parseQueryForTime();
           getDiff(date,days,hours,minutes,dayOfWeek);                  
           displayCountdown();
    });       
    
    function getCountdown() {        
        var current = moment();
        var ms = moment(then,"DD/MM/YYYY HH:mm:ss").diff(moment(current,"DD/MM/YYYY HH:mm:ss"));
        if(ms <= 0) {
            countdown = "";
            return;
        }
        var d = moment.duration(ms);
        var s = Math.floor(d.asDays()) + moment.utc(ms).format(":HH:mm:ss");			
        countdown = s;                
    }
    
    function getDiff(date,days,hours,minutes,dayOfWeek) {                
        now = moment();   
        if(date) {            
            then = moment(date);
        } else {                    
            if(dayOfWeek < 7) {
                if(now.days() > dayOfWeek) {
                    dayOfWeek += 7;
                }				
                then = moment().day(dayOfWeek);
            }
            else if(now.hours() > hours || (days == 1)) {            
                days > 0 ? {} : days +=1;
                then = moment().add(days,'days');
            } else if(now.hours() == hours && now.minutes() >= minutes) {            
                return;
                //don't show countdown
            }
        }        
        then = moment(then).hours(hours).minutes(minutes).seconds(0);        
        var ms = moment(then,"DD/MM/YYYY HH:mm:ss").diff(moment(now,"DD/MM/YYYY HH:mm:ss"));
        if(ms > 0) {
            var d = moment.duration(ms);
            var s = Math.floor(d.asDays()) + moment.utc(ms).format(":HH:mm:ss");			
            countdown = s;            
        }
    }

    function getDayOfWeek(day) {
        
        switch(day) {
            case 'sunday': 
                    return 0;
            case 'monday':							
                    return 1;
            case 'tuesday':
                    return 2;
            case 'wednesday': 
                    return 3;
            case 'thursday': 
                    return 4;
            case 'friday': 
                    return 5;
            case 'saturday': 
                    return 6;					
            default:
                    return 7;
        }
    }
    
    function getMonth(month){        
        switch(true) {
            case month === 'january'   || month === 'jan':
                                                return 1;
            case month === 'february'  || month === 'feb':
                                                return 2;
            case month === 'march'     || month === 'mar':
                                                return 3;
            case month === 'april'     || month === 'apr':
                                                return 4;
            case month === 'may':
                                                return 5;
            case month === 'june'      || month === 'jun':
                                                return 6;
            case month === 'july'      || month === 'jul':
                                                return 7;
            case month === 'august'    || month === 'aug':
                                                return 8;
            case month === 'september' || month === 'sept':
                                                return 9;
            case month === 'october'   || month === 'oct':
                                                return 10;
            case month === 'november'  || month === 'nov':
                                                return 11;
            case month === 'december'  || month === 'dec':
                                                return 12;
        }
    }
    
    function parseQueryForTime() {        
        if(parsed) {
            return;
        }
        parsed = true;
        var query = DDG.get_query().replace('countdown to', '').replace('time until', ''); // query of form : digits am/pm today/tomorrow/day of week        
                        
        var regex = new RegExp(/[\s]+(?:(\d{1,2})\.?(\d{1,2})?)[\s]+([Aa|Pp][Mm])[\s]*(today|tomorrow|(?:(?:Mon|Tues|Wednes|Thurs|Fri|Satur|Sun)(?:day)?))?/i);
        var match;
        
        match = regex.exec(query);                                                                      
        if(match) {                
            hours = parseInt(match[1]); //set number of hours from query
            if(match[2])
                minutes = parseInt(match[2]);
            if(hours == 12) {
                hours = 0;
            }
            if(match[4] === 'tomorrow') {  //move to next day
                days = 1;
            } else if(match[4]) {
                dayOfWeek = getDayOfWeek(match[4].toLowerCase());  //move to day specified 
            }                                                                                          
            if(match[3] === 'pm' || match[3] === 'PM' || match[3] === 'Pm' || match[3] === 'pM') { 
                hours += 12;
            }
            query = query.replace(match[0],'');
        } else {
            regex = new RegExp(/[\s]+([\d]{1,2})[\s]*(?:st|th|nd)?[\s]*(?:[\s]+|[\/|-]?)[\s]*(?:(Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sept(?:ember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?|[\d]{1,2}))[\s]*(?:[\s]+|[\/|-]?)[\s]*([\d]{4})[\s]*/i);
            match = regex.exec(query);
            console.log(match);
            if(match) {                
                if(isNaN(match[2])) {                    
                    date = match[3]+"/"+getMonth(match[2].toLowerCase())+"/"+match[1];                    
                } else {
                    date = match[3]+"/"+match[2]+"/"+match[1];    
                }                                              
            }
        }
    }
    
    function displayCountdown() {                
        var parts = countdown.split(":");
        if(parts.length > 1) {
            $(".time_display .days").html(parts[0]);
            $(".time_display .hours").html(" :"+parts[1]);
            $(".time_display .minutes").html(" :"+parts[2]);
            $(".time_display .seconds").html(" :"+parts[3]);    
        }                
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
                hasShown = true;          
                
                parseQueryForTime();
                $(".name_input").html(DDG.get_query());
                setInterval(function() {
                    getCountdown();
                    displayCountdown();                
                }, 1000);
            }
        };
    };
})(DDH);
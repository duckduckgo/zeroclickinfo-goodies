DDH.countdown = DDH.countdown || {};

(function(DDH) {
    "use strict";

    var hasShown = false;
    var countdown = "";
    var loaded = false;    
    var days = 0, hours = 0, minutes = 0, dayOfWeek = 8, ms;
    var now,then;
    var parsed = false;
    
    DDG.require('moment.js', function() {
           loaded = true;                           
           parseQueryForTime();
           getDiff(days,hours,minutes,dayOfWeek);             
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
    
    function getDiff(days,hours,minutes,dayOfWeek) {
                
        now = moment();        
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
        then = moment(then).hours(hours).minutes(minutes).seconds(0);        
        ms = moment(then,"DD/MM/YYYY HH:mm:ss").diff(moment(now,"DD/MM/YYYY HH:mm:ss"));
        if(ms > 0) {
            var d = moment.duration(ms);
            var s = Math.floor(d.asDays()) + moment.utc(ms).format(":HH:mm:ss");			
            countdown = s;            
        }                
    }

    function getDayOfWeek(day) {
        
        switch(day.toLowerCase()) {
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
    
    function parseQueryForTime() {        
        if(parsed) {
            return;
        }
        parsed = true;
        var query = DDG.get_query().replace('countdown to', ''); // query of form : digits am/pm today/tomorrow/day of week        
        
        var regex = new RegExp(/[\s]+((\d{1,2})\.?(\d{1,2})?)[\s]+([Aa|Pp][Mm])[\s]*(today|tomorrow|((Mon|Tues|Wednes|Thurs|Fri|Satur|Sun)(day)))?/i);

        var match;//, days = 0, hours = 0, dayOfWeek = 1;
        while(true) {
            match = regex.exec(query);                                                                      
            if(match) {                
                hours = parseInt(match[2]); //set number of hours from query
                if(match[3])
                    minutes = parseInt(match[3]);
                if(hours == 12) {
                    hours = 0;
                }
                if(match[5] === 'tomorrow') {  //move to next day
                    days = 1;
                } else if(match[5]) {
                    dayOfWeek = getDayOfWeek(match[5]);  //move to day specified 
                }                                                                                          
                if(match[4] === 'pm' || match[4] === 'PM') { 
                    hours += 12;
                }
                query = query.replace(match[0],'');
            } else {
                break;
            }
        }
    }
    
    function displayCountdown() {                
        var parts = countdown.split(":");
        if(parts.length > 1) {
            $(".time_display .hours_minutes").html(parts[0]+":"+parts[1]+":"+parts[2]);
            $(".time_display .seconds").html(parts[3]);    
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
                setInterval(function() {
                    getCountdown();
                    displayCountdown();                
                }, 1000);
            }
        };
    };
})(DDH);
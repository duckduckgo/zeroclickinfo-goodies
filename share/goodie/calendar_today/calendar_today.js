DDH.calendar_today = DDH.calendar_today || {}; // create the namespace in case it doesn't exist

DDH.calendar_today.build = function(ops) {

    Spice.registerHelper('calendar_table', function(options, context) { 
       var data = options.hash; 
        var days = data.days,
            daysOfTheWeek = data.daysOfTheWeek,
            numberOfRows = data.numberOfRows,
            month_name = data.month_name,
            year = data.year;
        // create header
        var ret = '<table class="calendar"><tbody><tr><th colspan="7"><span class="calendar__header"><b>'+ month_name + ' ' + year + '</b></span></th></tr><tr class="header-days">';
        // make column table heads for days of week
        for (var i = 0; i < daysOfTheWeek.length; i++){
            ret = ret + '<td class="header-day">' + daysOfTheWeek[i] + '</td>';
        }
        // end table head and start table body
        ret = ret + '</tr><tbody>';
        // write out rows 
        for (var i = 0; i < numberOfRows; i++) {
            ret = ret + '<tr>';
            // restrict rows to 7 columns each
            for (var j = 0; j < 7; j++){
                var d = j + i * 7;
                ret = ret + '<td class="'+ days[d].classes +'"><div class="day-contents">' + days[d].day + '</div></td>';
            }
            // close row
            ret = ret + '</tr>';
        }
        // close table body and table
        ret = ret + '</tbody></table>';
        // return html 
        return ret;
    });

    DDG.require('moment.js', function(){
        var classes = {
                        today: 'today circle',
                        lastMonth: 'last-month',
                        nextMonth: 'next-month',
                        weekend: 'weekend'
                    };

        createDayObject = function(day) {
            var now = moment();

            // validate moment date
            if (!day.isValid() && day.hasOwnProperty('_d') && day._d != undefined) {
                day = moment(day._d);
            }

            var properties = {
                isInactive: false,
                isAdjacentMonth: false,
                isToday: false,
            };

            var extraClasses = '';

            if(now.format('YYYY-MM-DD') == day.format('YYYY-MM-DD')) {
                extraClasses += (" " + classes.today);
                properties.isToday = true;
            }
            if (currentIntervalStart.month() > day.month()){
                extraClasses += (' ' + classes.lastMonth);
            }
            if (currentIntervalStart.month() < day.month()){
                extraClasses += (' ' + classes.nextMonth);
            }
            

            // validate moment date
            if (!day.isValid() && day.hasOwnProperty('_d') && day._d !== undefined) {
                day = moment(day._d);
            }

        
            extraClasses += ' calendar-day-' + day.format('YYYY-MM-DD');

            // day of week
            extraClasses += ' calendar-dow-' + day.weekday();

            return {
            day: day.date(),
            classes:extraClasses,
            date: day
            };
                
        };
            
        var items = [];
        for (var z = 0; z < ops.data.length; z++){
            var item = ops.data[z];
            var month = item.month;
            var year = item.year; 
            var daysOfTheWeek = [];
            for (var i = 0; i < 7; i++) {
                daysOfTheWeek.push( moment().weekday(i).format('dd').charAt(0) );
            }
            item.daysOfTheWeek = daysOfTheWeek;
            var daysArray = [];
            // month in moment is 0 based, so 9 is actually october, subtract 1 to compensate
            // array is 'year', 'month', 'day', etc
            var startDate = moment([year, month - 1]);
            // Clone the value before .endOf()
            var endDate = moment(startDate).endOf('month');        
            var startOfLastMonth = startDate.clone().subtract(1, 'months').startOf('month');
            var endOfLastMonth = startOfLastMonth.clone().endOf('month');
            var startOfNextMonth = endDate.clone().add(1, 'months').startOf('month');
            var endOfNextMonth = startOfNextMonth.clone().endOf('month');

            currentIntervalStart = startDate.clone();
            // this array will hold numbers for the entire grid (even the blank spaces)
                        
            // get diff between start day and 7
            var diff = startDate.weekday();
            if (diff < 0) diff += 7;
            // push previous days
            for (var i = 0; i < diff; i++) {
            var day = moment([startDate.year(), startDate.month(), i - diff + 1]);
                daysArray.push(createDayObject(day));
            }

            // now we push all of the days in the interval
            var dateIterator = startDate.clone();
            while (dateIterator.isBefore(endDate) || dateIterator.isSame(endDate, 'day')) {
                daysArray.push( createDayObject(dateIterator.clone()) );
                dateIterator.add(1, 'days');
            }

            while(daysArray.length % 7 !== 0) {
                daysArray.push( this.createDayObject(dateIterator.clone()));
                dateIterator.add(1, 'days');
            }

            // if we want to force six rows of calendar, now's our Last Chance to add another row.
            // if the 42 seems explicit it's because we're creating a 7-row grid and 6 rows of 7 is always 42!
            if(daysArray.length !== 42 ) {
                while(daysArray.length < 42) {
                        daysArray.push( createDayObject(dateIterator.clone()) );
                        dateIterator.add(1, 'days');
                    }
            }

            item.days = daysArray;
            item.month = month;
            item.daysOfTheWeek = daysOfTheWeek;
            item.numberOfRows = Math.ceil(daysArray.length / 7);
            item.year = year;
            items.push(item);
        }

        Spice.add({
            id: "calendar",
            name: "Answer",
            meta:{
                selectedItem: items[2]
            },
            data: items,
            templates: {
                group: 'base',
                detail: 0,
                options: {
                    content: 'DDH.calendar_today.content'  
                }
            }
        });
    });

};

DDH.calendar_today = DDH.calendar_today || {}; // create the namespace in case it doesn't exist

DDH.calendar_today.build = DDH.calendar_today.build_async =  function(ops, DDH_async_add) {
    Spice.registerHelper('calendar_table', function(options, context) { 
       var data = options.hash; 
        var days = data.days,
            daysOfTheWeek = data.daysOfTheWeek,
            numberOfRows = data.numberOfRows,
            month_name = data.month_name,
            year = data.year;
        // create header
        var ret = '<table class="calendar"><tbody><tr><th colspan="7"><div class="calendar__header"><div class="month-name">'+ month_name + '</div><div class="year">' + year + '</div></div></th></tr><tr class="header-days">';
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
    var data = ops.data;
    var currentMonth = data.month,
            currentYear = data.year,
            currentDay = data.day;
    DDG.require('moment.js', function(){
        var classes = {
            today: 'today circle',
            weekend: 'weekend',
            adjacentMonth: 'adj-month'
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

            if (currentIntervalStart.month() !== day.month()){
                extraClasses += (' ' + classes.adjacentMonth);
            } else {
                if(now.format('YYYY-MM-DD') == day.format('YYYY-MM-DD')) {
                    extraClasses += (" " + classes.today);
                    properties.isToday = true;
                }
            }
            
            extraClasses += ' calendar-day-' + day.format('YYYY-MM-DD');

            var weekday = day.weekday();
            if (weekday === 0 || weekday === 6){
                extraClasses += ' weekend';
            } else {
                extraClasses += ' weekday';
            }
            
            return {
                day: day.date(),
                classes:extraClasses,
                date: day
            };
                
        };
            
        var items = [],
            item = {};
            
        var startDate = moment([currentYear, 0]);
        var currentMonthName = moment([currentYear, currentMonth - 1]).format('MMMM');
        for (var z = 0; z < 12; z++){
            var month_name = startDate.format('MMMM'),
                month = startDate.month(),
                year = startDate.format('YYYY'),
                daysOfTheWeek = [];
            for (var i = 0; i < 7; i++) {
                daysOfTheWeek.push( moment().weekday(i).format('dd').charAt(0) );
            }
            item.daysOfTheWeek = daysOfTheWeek;
            var daysArray = [];
            // Clone the value before .endOf()
            var endDate = moment(startDate).endOf('month'),
                startOfLastMonth = startDate.clone().subtract(1, 'months').startOf('month'),
                endOfLastMonth = startOfLastMonth.clone().endOf('month'),
                startOfNextMonth = endDate.clone().add(1, 'months').startOf('month'),
                endOfNextMonth = startOfNextMonth.clone().endOf('month');

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
                daysArray.push(createDayObject(dateIterator.clone()) );
                dateIterator.add(1, 'days');
            }

            while(daysArray.length % 7 !== 0) {
                daysArray.push(this.createDayObject(dateIterator.clone()));
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
            item.month_name = month_name;
            item.month = String(month+1);
            item.daysOfTheWeek = daysOfTheWeek;
            item.numberOfRows = Math.ceil(daysArray.length / 7);
            item.year = year;
            item.id = month;
            items.push(item);
            item = {};
            startDate = startDate.add(1, 'months');
        }
        
        DDH.add({
            id: "calendar",
            name: "Answer",
            meta:{
                selectedItem: String(currentMonth),
                scrollToSelectedItem: true,
                itemsHighlight: false 
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

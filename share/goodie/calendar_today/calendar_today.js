DDH.calendar_today = DDH.calendar_today || {}; // create the namespace in case it doesn't exist

DDH.calendar_today.build_async = function(ops, DDH_async_add) {
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

        /* creates a day object
         * @param {moment object} day
         * @return {Object} day, classes, date
         */
        createDayObject = function(day) {
            var now = moment();

            // validate moment date
            if (!day.isValid() && day.hasOwnProperty('_d') && day._d !== undefined) {
                day = moment(day._d);
            }
            
            // start with no extra day classes
            var extraClasses = '';

            // check if day is not from this month
            if (currentIntervalStart.month() !== day.month()){
                extraClasses += (' ' + classes.adjacentMonth);
            } else {
                // check if day is today
                if(now.format('YYYY-MM-DD') == day.format('YYYY-MM-DD')) {
                    extraClasses += (" " + classes.today);
                }
            }

            // check if weekday or weekend
            var weekday = day.weekday();
            if (weekday === 0 || weekday === 6){
                extraClasses += ' weekend';
            } else {
                extraClasses += ' weekday';
            }
           
            // return day object
            return {
                day: day.date(),
                classes:extraClasses,
                date: day
            };
                
        };
            
        var items = [], // to hold all months
            item = {}; // to hold a month at a time
           
        // get january of the given year
        var startDate = moment([currentYear, 0]);
        // for 12 months
        for (var z = 0; z < 12; z++) {
            var month_name = startDate.format('MMMM'),
                month = startDate.month(),
                year = startDate.format('YYYY'),
                daysOfTheWeek = [];
            // get days of week
            for (var i = 0; i < 7; i++) {
                daysOfTheWeek.push( moment().weekday(i).format('dd').charAt(0) );
            }
            // save days of week
            item.daysOfTheWeek = daysOfTheWeek;
            // make array for days
            var daysArray = [];
            //get start and end of this month and last month
            var endDate = moment(startDate).endOf('month'),
                startOfLastMonth = startDate.clone().subtract(1, 'months').startOf('month'),
                endOfLastMonth = startOfLastMonth.clone().endOf('month'),
                startOfNextMonth = endDate.clone().add(1, 'months').startOf('month'),
                endOfNextMonth = startOfNextMonth.clone().endOf('month');

            // get start date to iterate from
            currentIntervalStart = startDate.clone();
                        
            // get diff between start day and 7
            var diff = startDate.weekday();
            if (diff < 0) diff += 7;

            // push previous days
            for (var i = 0; i < diff; i++) {
            var day = moment([startDate.year(), startDate.month(), i - diff + 1]);
                daysArray.push(createDayObject(day));
            }

            // push all of the days in the interval
            var dateIterator = startDate.clone();
            while (dateIterator.isBefore(endDate) || dateIterator.isSame(endDate, 'day')) {
                daysArray.push(createDayObject(dateIterator.clone()) );
                dateIterator.add(1, 'days');
            }

            // pad last row until it has a full 7 days
            while (daysArray.length % 7 !== 0) {
                daysArray.push(this.createDayObject(dateIterator.clone()));
                dateIterator.add(1, 'days');
            }

            // make sure we have 5 rows of 7 days (42) so each tile is even
            if (daysArray.length !== 42 ) {
                while(daysArray.length < 42) {
                    daysArray.push( createDayObject(dateIterator.clone()) );
                    dateIterator.add(1, 'days');
                }
            }

            // make 7 day long rows
            var rows = [];
            var q,r,week,chunk = 7;
            for (q=0,r=daysArray.length; q<r; q+=chunk) {
                week = daysArray.slice(q,q+chunk);
                rows.push(week);
            }
           
            // attach needed data to item for rendering
            item.month_name = month_name;
            item.month = month;
            item.daysOfTheWeek = daysOfTheWeek;
            item.year = year;
            // add 1 since perl does. this is used for selected item
            item.id = month + 1;
            item.rows = rows;
            // push item into items
            items.push(item);
            // clear item
            item = {};
            // iterate to next month
            startDate = startDate.add(1, 'months');
        }
        // add spice
       DDH_async_add({
            id: "calendar",
            name: "Calendar",
            meta:{
                idField: 'id',
                selectedItem: currentMonth,
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

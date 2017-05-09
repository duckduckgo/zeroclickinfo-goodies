DDH.days_between = DDH.days_between || {};

DDH.days_between.build_async = function(ops, DDH_async_add) {

    console.log("DDH.days_between.build"); // remove this before submitting pull request

    // functions
    // determine wheter to use regex or not
    function monthNameNotInQuery() {
        for (var i = 0; i < months.length; i++) {
            if (QUERY.indexOf(months[i]) > -1) {
                return false;
            }
        }
        return true;
    }


    // return seconds, minutes, hours, days, years between starting and
    // ending date
    function returnValues(startingDate, endingDate) {

        if (startingDate.isBefore(endingDate)) {
            var temp = endingDate;
            endingDate = startingDate;
            startingDate = temp;
        }
        var days = startingDate.diff(endingDate, 'days');

        return days;
    }

    // determine if string is valid number
    function isNumber(num) {
        return !isNaN(num);
    }

    // end of functions

    // variables
    var QUERY = DDG.get_query().toLowerCase();
    var queryWords = QUERY.split(' ');
    var months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun',
        'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
    ];

    var dates;
    var start;
    var end;
    var startDay;
    var startMonth;
    var startYear;
    var endDay;
    var endMonth;
    var endYear;
    var startingDate;
    var endingDate;
    var outputArray;

    DDG.require('moment.js', function() {

        if (monthNameNotInQuery()) {
            // we can use regex and remove all alphabetic characters
            for (var i = 0; i < queryWords.length; i++) {
                queryWords[i] = queryWords[i].replace(/[^0-9/.-]/g, "");
            }
            // filter non empty places
            dates = queryWords.filter(function(e) {
                return e;
            });

            // if query does not contain numbers, return
            if (dates.length < 1) {
                return;
            }

            start = moment(dates[0], 'DD-MM-YYYY').toArray();
            end = moment(dates[1], 'DD-MM-YYYY').toArray();

        } else {

            // if query contains month name
            dates = [];
            for (var j = 0; j < queryWords.length; j++) {
                if (isNumber(queryWords[j])) {
                    dates.push(queryWords[j]);
                } else {
                    word = queryWords[j].slice(0, 3);
                    if (months.indexOf(word) > -1) {
                        dates.push(word);
                    }
                }
            }

            start = moment(dates.splice(0, 3), 'DD-MMM-YYYY').toArray();
            end = moment(dates.splice(0, 3), 'DD-MMM-YYYY').toArray();
        }

        startDay = start[2];
        startMonth = start[1];
        startYear = start[0];
        endDay = end[2];
        endMonth = end[1];
        endYear = end[0];

        startingDate = moment([startYear, startMonth, startDay]);
        endingDate = moment([endYear, endMonth, endDay]);
        total_days = returnValues(startingDate, endingDate);

        DDH_async_add({

            data: {
                title: "Days between",
                subtitle: 'Number of days: '
            },
            templates: {
                group: "text",
                options: {
                    subtitle_content: DDH.days_between.content,
                }
            },
            normalize: function(item) {
                return {
                    subtitle: "Days between: " + total_days
                };
            },

            onShow: function() {

                // insert numbers into text boxes
                var $startDay = $('.start_day');
                var $startMonth = $('.start_month');
                var $startYear = $('.start_year');
                var $endDay = $('.end_day');
                var $endMonth = $('.end_month');
                var $endYear = $('.end_year');

                $startDay.val(startDay);
                $startMonth.val(startMonth + 1);
                $startYear.val(startYear);
                $endDay.val(endDay);
                $endMonth.val(endMonth + 1);
                $endYear.val(endYear);


                // calculate button clicked
                $('.calculate').click(function() {
                    // get numbers from text boxes
                    startDay = $startDay.val();
                    startMonth = $startMonth.val();
                    startYear = $startYear.val();
                    endDay = $endDay.val();
                    endMonth = $endMonth.val();
                    endYear = $endYear.val();

                    startingDate = moment([startYear, startMonth - 1, startDay]);
                    endingDate = moment([endYear, endMonth - 1, endDay]);
                    output = returnValues(startingDate, endingDate);

                    $('.c-base__sub').html('Days between: ' + output);
                });
            }
        });
    });
};
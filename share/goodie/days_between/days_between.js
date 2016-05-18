DDH.days_between = DDH.days_between || {};

DDH.days_between.build = function(ops) {

    console.log("DDH.days_between.build"); // remove this before submitting pull request

    // functions
    // determine wheter to use regex or not
    function monthNameInQuery() {
        for (var i = 0; i < months.length; i++) {
            if (QUERY.indexOf(months[i]) > -1) {
                return false;
            }
        }
        return true;
    }

    function splitDates(str) {
        var dateArr;
        if (str.indexOf('/') > -1) {
            dateArr = str.split('/');
        } else if (str.indexOf('-') > -1) {
            dateArr = str.split('-');
        } else if (str.indexOf('.') > -1) {
            dateArr = str.split('.');
        }
        return dateArr;
    }

    function isDate(value) {
        if (typeof value === "number" ||
            toBeRemoved.join('').indexOf(value) == -1) {
            return true;
        } else {
            return false;
        }
    }

    function convertToMonthInt(value) {
        if (value.length > 3) {
            value = value.slice(0, 3);
        }
        var monthNumber = months.indexOf(value) + 1;
        return monthNumber;
    }

    function getDateFormat(dateArray) {
        var day;
        var month;
        var year;
        for (i = 0; i < dateArray.length; i++) {
            if (dateArray[i].length === 1 || dateArray[i].length === 2) {
                day = parseInt(dateArray[i]);
            } else if (typeof dateArray[i] == 'string' && i === 0 || i === 1) {
                month = convertToMonthInt(dateArray[i]);
            } else {
                year = parseInt(dateArray[i]);
            }
        }
        return {
            day: day,
            month: month,
            year: year
        };
    }

    // return seconds, minutes, hours, days, years between starting and
    // ending date
    function returnValues(startingDate, endingDate) {
        var seconds = Math.abs(startingDate.diff(endingDate, 'seconds'));
        var minutes = Math.abs(startingDate.diff(endingDate, 'minutes'));
        var hours = Math.abs(startingDate.diff(endingDate, 'hours'));
        var days = Math.abs(startingDate.diff(endingDate, 'days'));
        var years = Math.abs(startingDate.diff(endingDate, 'years'));
        var outputArray = [years, days, hours, minutes, seconds];

        return outputArray;
    }


    // output numbers to table
    function writeToTable(outputArray) {
        var j = 0;
        $('.record__body tr').each(function() {
            //console.log($(this).find('.record__cell--key').html());
            $(this).find('.record__cell--value').html(outputArray[j]);
            j++;
        });
    }

    // end of functions

    // variables
    var QUERY = DDG.get_query().toLowerCase();
    var queryWords = QUERY.split(' ');
    var months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun',
        'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
    ];

    // words to be removed from QUERY
    var toBeRemoved = ['between', 'from', 'to', 'and', 'in',
        'seconds', 'minutes', 'hours', 'days', 'day', 'years', 'calculator'
    ];

    var dates;
    var firstDate;
    var secondDate;
    var startDay;
    var startMonth;
    var startYear;
    var endDay;
    var endMonth;
    var endYear;

    var regexAllowed = monthNameInQuery();

    if (regexAllowed) {
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
        } else {
            firstDate = splitDates(dates[0]);
            secondDate = splitDates(dates[1]);

            startDay = parseInt(firstDate[0]);
            startMonth = parseInt(firstDate[1]);
            startYear = parseInt(firstDate[2]);
            endDay = parseInt(secondDate[0]);
            endMonth = parseInt(secondDate[1]);
            endYear = parseInt(secondDate[2]);
        }


    } else {
        // if query contains names of months filter query to dates only
        dates = queryWords.filter(isDate);

        if (dates.length === 6) {
            firstDate = dates.splice(0, 3);
            secondDate = dates.splice(0, 3);
        }

        firstDate = getDateFormat(firstDate);
        secondDate = getDateFormat(secondDate);

        startDay = firstDate.day;
        startMonth = firstDate.month;
        startYear = firstDate.year;

        endDay = secondDate.day;
        endMonth = secondDate.month;
        endYear = secondDate.year;
    }


    return {
        data: {
            record_data: {
                years: '',
                days: '',
                hours: '',
                minutes: '',
                seconds: '',
            }
        },

        onShow: function() {
            DDG.require('moment.js', function() {

                // insert numbers into text boxes
                $('#zci--days_between--start_day').val(startDay);
                $('#zci--days_between--start_month').val(startMonth);
                $('#zci--days_between--start_year').val(startYear);
                $('#zci--days_between--end_day').val(endDay);
                $('#zci--days_between--end_month').val(endMonth);
                $('#zci--days_between--end_year').val(endYear);

                var startingDate = moment([startYear, startMonth - 1, startDay]);
                var endingDate = moment([endYear, endMonth - 1, endDay]);

                var outputArray = returnValues(startingDate, endingDate);

                writeToTable(outputArray);


                // calculate button clicked
                $('#zci--days_between--calculate').click(function() {

                    console.log('CLICKED');

                    // get numbers from text boxes
                    startDay = $('#zci--days_between--start_day').val();
                    startMonth = $('#zci--days_between--start_month').val();
                    startYear = $('#zci--days_between--start_year').val();
                    endDay = $('#zci--days_between--end_day').val();
                    endMonth = $('#zci--days_between--end_month').val();
                    endYear = $('#zci--days_between--end_year').val();

                    if (startDay > 31) {
                        startDay = 31;
                        $('#zci--days_between--start_day').val(31);
                    }

                    if (startMonth > 12) {
                        startMonth = 12;
                        $('#zci--days_between--start_month').val(12);
                    }

                    if (endDay > 31) {
                        endDay = 31;
                        $('#zci--days_between--end_day').val(31);
                    }

                    if (endMonth > 12) {
                        endMonth = 12;
                        $('#zci--days_between--end_month').val(12);
                    }

                    startingDate = moment([startYear, startMonth - 1, startDay]);
                    endingDate = moment([endYear, endMonth - 1, endDay]);

                    outputArray = returnValues(startingDate, endingDate);

                    writeToTable(outputArray);

                    // end of button click
                });
            }); // closing tag of require moment.js
        },
    };
};

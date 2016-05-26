DDH.days_between = DDH.days_between || {};

DDH.days_between.build_async = function (ops, DDH_async_add) {

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
        $('.record__body tr').each(function () {
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

      if (monthNameInQuery()) {
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

        startDay = start[2];
        startMonth = start[1];
        startYear = start[0];
        endDay = end[2];
        endMonth = end[1];
        endYear = end[0];
      }

        DDH_async_add({

            data: {
                title: "Date Math",
                record_data: {
                    years: '',
                    days: '',
                    hours: '',
                    minutes: '',
                    seconds: '',
                }
            },
            templates: {
                group: "list",
                options: {
                    subtitle_content: DDH.days_between.content,
                    content: "record",
                    rowHighlight: 'true'
                }
            },

            onShow: function () {

                // insert numbers into text boxes
                $('#zci--days_between--start_day').val(startDay);
                $('#zci--days_between--start_month').val(startMonth + 1);
                $('#zci--days_between--start_year').val(startYear);
                $('#zci--days_between--end_day').val(endDay);
                $('#zci--days_between--end_month').val(endMonth + 1);
                $('#zci--days_between--end_year').val(endYear);

                startingDate = moment([startYear, startMonth, startDay]);
                endingDate = moment([endYear, endMonth, endDay]);

                outputArray = returnValues(startingDate, endingDate);

                writeToTable(outputArray);


                // calculate button clicked
                $('#zci--days_between--calculate').click(function () {

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

                });
            }
        });
    });
};

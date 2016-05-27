DDH.days_between = DDH.days_between || {};

DDH.days_between.build_async = function (ops, DDH_async_add) {

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

        var out = {
          seconds: 0,
          minutes: 0,
          hours: 0,
          days: 0,
          years: 0
        };

        $.each(out, function(k,v) {
          out[k] = Math.abs(startingDate.diff(endingDate, k));
        });

        console.log(out);

        var seconds = startingDate.diff(endingDate, 'seconds');
        var minutes = startingDate.diff(endingDate, 'minutes');
        var hours = startingDate.diff(endingDate, 'hours');
        var days = startingDate.diff(endingDate, 'days');
        var years = startingDate.diff(endingDate, 'years');

        var outputArray = [years, days, hours, minutes, seconds];
        return outputArray;
    }


    // output numbers to table
    function writeToTable(outputArray) {
        var j = 0;
        $('.record__body tr').each(function () {
            $(this).find('.record__cell--value').html(outputArray[j]);
            j++;
        });
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

        start = moment(dates.splice(0,3), 'DD-MMM-YYYY').toArray();
        end = moment(dates.splice(0,3), 'DD-MMM-YYYY').toArray();
      }

      startDay = start[2];
      startMonth = start[1];
      startYear = start[0];
      endDay = end[2];
      endMonth = end[1];
      endYear = end[0];

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
                    content: "record"
                }
            },

            onShow: function () {

                // insert numbers into text boxes
                $('.start_day').val(startDay);
                $('.start_month').val(startMonth + 1);
                $('.start_year').val(startYear);
                $('.end_day').val(endDay);
                $('.end_month').val(endMonth + 1);
                $('.end_year').val(endYear);

                startingDate = moment([startYear, startMonth, startDay]);
                endingDate = moment([endYear, endMonth, endDay]);

                outputArray = returnValues(startingDate, endingDate);

                writeToTable(outputArray);


                // calculate button clicked
                $('.calculate').click(function () {
                    // get numbers from text boxes
                    startDay = $('.start_day').val();
                    startMonth = $('.start_month').val();
                    startYear = $('.start_year').val();
                    endDay = $('.end_day').val();
                    endMonth = $('.end_month').val();
                    endYear = $('.end_year').val();

                    startingDate = moment([startYear, startMonth - 1, startDay]);
                    endingDate = moment([endYear, endMonth - 1, endDay]);

                    outputArray = returnValues(startingDate, endingDate);

                    writeToTable(outputArray);

                });
            }
        });
    });
};

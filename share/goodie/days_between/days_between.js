DDH.days_between = DDH.days_between || {};

DDH.days_between.build = function(ops, DDH_async_add) {

  console.log("DDH.days_between.build"); // remove this before submitting pull request

  // functions
  function inYears(startDate, endDate) {
    var seconds = Math.round(endDate - startDate);
    var years = Math.round(seconds / (60 * 60 * 24 * 365));
    return years;
  }

  function inDays(startDate, endDate) {
    var seconds = Math.round(endDate - startDate);
    var days = (seconds / (60 * 60 * 24));
    return days;
  }

  function inHours(startDate, endDate) {
    var seconds = Math.round(endDate - startDate);
    var hours = (seconds / (60 * 60));
    return hours;
  }

  function inMinutes(startDate, endDate) {
    var seconds = Math.round(endDate - startDate);
    var minutes = (seconds / 60);
    return minutes;
  }

  function inSeconds(startDate, endDate) {
    var seconds = Math.round(endDate - startDate);
    return seconds;
  }

  function exactTime(startDate, endDate) {
    var seconds = Math.round(endDate - startDate);
    var years = seconds / (60 * 60 * 24 * 365);
    seconds = seconds % (60 * 60 * 24 * 365);
    years = Math.floor(years);

    var days = seconds / (60 * 60 * 24);
    seconds = seconds % (60 * 60 * 24);
    days = Math.floor(days);

    var hours = seconds / (60 * 60);
    seconds = seconds % (60 * 60);
    hours = Math.floor(hours);

    var minutes = seconds / 60;
    seconds = seconds % 60;
    minutes = Math.floor(minutes);

    return {
      years: years,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds
    };
  }

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


  // function to write numbers to output table
  function writeToTable(outputArray) {
    var j = 0;
    $('.record__body tr').each(function() {
      console.log($(this).find('.record__cell--key').html());
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

  if (regexAllowed === true) {
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


  } else if (regexAllowed === false) {
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

  //DDG.require('moment.js', function () {
  //DDH_async_add({
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

      // insert dates into inputs
      $('#zci--days_between--start_day').val(startDay);
      $('#zci--days_between--start_month').val(startMonth);
      $('#zci--days_between--start_year').val(startYear);
      $('#zci--days_between--end_day').val(endDay);
      $('#zci--days_between--end_month').val(endMonth);
      $('#zci--days_between--end_year').val(endYear);

      // dates in seconds
      var startingDate = new Date(startYear, startMonth - 1, startDay).getTime() / 1000;
      var endingDate = new Date(endYear, endMonth - 1, endDay).getTime() / 1000;

      if (endingDate < startingDate) {
        var temp = startingDate;
        startingDate = endingDate;
        endingDate = temp;
      }

      var seconds = inSeconds(startingDate, endingDate);
      var minutes = inMinutes(startingDate, endingDate);
      var hours = inHours(startingDate, endingDate);
      var days = inDays(startingDate, endingDate);
      var years = inYears(startingDate, endingDate);

      var outputArray = [years, days, hours, minutes, seconds];

      writeToTable(outputArray);


      // calculate button clicked
      $('#zci--days_between--calculate').click(function() {
        console.log('CLICKED');
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

        startingDate = new Date(startYear, startMonth - 1,
          startDay).getTime() / 1000;
        endingDate = new Date(endYear, endMonth - 1,
          endDay).getTime() / 1000;

        if (endingDate < startingDate) {
          var temp = startingDate;
          startingDate = endingDate;
          endingDate = temp;
        }

        seconds = inSeconds(startingDate, endingDate);
        minutes = inMinutes(startingDate, endingDate);
        hours = inHours(startingDate, endingDate);
        days = inDays(startingDate, endingDate);
        years = inYears(startingDate, endingDate);

        outputArray = [years, days, hours, minutes, seconds];

        writeToTable(outputArray);

        // end of button click
      });
    },
  };
  //});
};

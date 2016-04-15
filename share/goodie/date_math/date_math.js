// jshint jquery: true, browser: true, devel: true
DDH.date_math = DDH.date_math || {};

/* global DDG, DDH, Goodie, isNumber */
(function(DDH) {
    "use strict";

    console.log("DDH.date_math.build"); // remove this before submitting pull request

    // define private variables and functions here
    //
    // fuction helper () { ... }
    //
    // var a = '',
    //     b = '',
    //     c = '';

    DDH.date_math.build = function(ops) {

        return {

            meta: {
                sourceName: "Source Domain",
                sourceUrl: "https://source.website.com"
            },

            // data: {
            //     already defined in Perl Package
            //     you can re-define it here
            //     or access/modify 'ops.data'
            // },

            // normalize: function(item){
            //     use this to map your 'data'
            //     to the properties required for your chosen template
            //
            //     return {
            //         title: item.myTitle,
            //         subtitle: item.foo.subtitle
            //     };
            // },

            // templates: {
            //     group: 'text',
            //
            //     options: {
            //
            //     },
            //
            //     variants: {
            //
            //     }
            // },

            // Function that executes after template content is displayed
            onShow: function() {
                var $dom = $(".zci--date_math"),
                    $month = $dom.find('.month-select'),
                    $day = $dom.find('.day-select'),
                    $year = $dom.find('.input--year'),
                    $result = $dom.find('.date-result'),
                    $calculate = $dom.find('.date-btn');

                function getMonth() { $month.val(); }

                function getDay() { return $day.val(); }

                function getYear() { return $year.val(); }

                function isValidYear(yearText) {
                    if (yearText.match(/^\d{4}$/)) {
                        return true;
                    }
                    return false;
                }

                $year.keyup(function() {
                    var yearText = $(this).val();
                    if (isValidYear(yearText)) {
                        $(this).removeClass('input--invalid bg-clr--red');
                    } else {
                        $(this).addClass('input--invalid bg-clr--red');
                    }
                });

                function getNumDaysMonthYear() {
                    var month = getMonth();
                    var year = getYear();
                    return moment(year + '-' + month, 'YYYY-MM').daysInMonth();
                }

                DDG.require('moment.js', function() {
                    function calculateResult() {
                        var month = getMonth();
                        var day = getDay();
                        var year = getYear();
                        var date = moment(year + "-" + month + "-" + day, "YYYY-MM-DD");
                        var dateText = year + '-' + month + '-' + day;
                        console.log("Date Text: " + dateText);
                        $result.text(date.format('dddd MMMM Do YYYY'));
                        return date;
                    }

                    $calculate.click(function() {
                        calculateResult();
                    });

                    // var fr = moment().locale('fr');
                    // var locData = fr.localeData();
                    // $dom.find('.jan').text(fr.localeData().months(moment([2012, 0])));
                });
            }
        };
    };
})(DDH);

Handlebars.registerHelper('padZero', function(context, options) {
    var num = context;
    var zeros = options.hash.zeros || 2;
    var requiredZeros = zeros - String(num).length;
    if (requiredZeros >= 1) {
        return '0'.repeat(requiredZeros) + num;
    }
    return num;
});

Handlebars.registerHelper('lc', function(context, options) {
    return context.toLowerCase();
});

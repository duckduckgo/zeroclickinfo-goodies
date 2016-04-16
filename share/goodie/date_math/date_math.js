// jshint jquery: true, browser: true, devel: true
DDH.date_math = DDH.date_math || {};

/* global DDG, DDH, Goodie, isNumber */
(function(DDH) {
    "use strict";

    DDH.date_math.build = function(ops) {

        return {

            meta: {
                sourceName: "Source Domain",
                sourceUrl: "https://source.website.com"
            },

            // Function that executes after template content is displayed
            onShow: function() {
                var $dom = $(".zci--date_math"),
                    $month = $dom.find('.input--month'),
                    $day = $dom.find('.input--day'),
                    $year = $dom.find('.input--year'),
                    $startDate = $dom.find('.date--start'),
                    $resultDate = $dom.find('.date--result'),
                    $opTemplate = $dom.find('.template--op').clone();

                function initializeForm($par) {
                    $par.find('form').submit(function(e) {
                        e.preventDefault();
                    });
                }
                $dom.find('form').submit(function(e) {
                    e.preventDefault();
                });
                function getMonth() { return $month.val(); }

                function getDay() { return $day.val(); }

                function getYear() { return $year.val(); }

                function isValidYear(yearText) {
                    if (yearText.match(/^\d{4}$/)) {
                        return true;
                    }
                    return false;
                }

                $dom.find('.op--add').click(function() {
                    var $newOp = $opTemplate.clone();
                    $newOp.removeClass('template--op hide');
                    $newOp.appendTo('.op--container');
                    initializeForm($newOp);
                    $newOp.find('.input--op-op').click(function() {
                        if ($(this).hasClass('ddgsi-plus')) {
                            $(this).removeClass('ddgsi-plus');
                            $(this).addClass('ddgsi-minus');
                        } else {
                            $(this).removeClass('ddgsi-minus');
                            $(this).addClass('ddgsi-plus');
                        }
                    });
                });

                $year.keyup(function() {
                    var yearText = $(this).val();
                    if (isValidYear(yearText)) {
                        $(this).removeClass('input--invalid bg-clr--red');
                    } else {
                        $(this).addClass('input--invalid bg-clr--red');
                    }
                });

                DDG.require('moment.js', function() {
                    function getDate() {
                        var month = getMonth();
                        var day = getDay();
                        var year = getYear();
                        var date = moment(year + "-" + month + "-" + day, "YYYY-MM-DD");
                        return date;
                    }

                    function calculateResult(date) {
                        var seconds = 0;
                        $dom.find('.op--container .date--form').each(function() {
                            var amount = $(this).find('.input--op-amt').val();
                            var modifier = $(this).find('.input--op-type').val();
                            amount *= modifier;
                            if ($(this).find('.input--op-op').hasClass('ddgsi-plus')) {
                                seconds += amount;
                            } else {
                                seconds -= amount;
                            }
                        });
                        return moment(date).add(seconds, 'seconds');
                    }

                    function formatDate(date) {
                        return date.format('dddd MMMM Do YYYY HH:mm:ss');
                    }

                    function performCalculation() {
                        var date = getDate();
                        if (date === undefined) {
                            return;
                        }
                        var result = calculateResult(date);
                        $startDate.text(formatDate(date));
                        $resultDate.text(formatDate(result));
                    }

                    function getNumDaysMonthYear() {
                        var month = getMonth();
                        var year = getYear();
                        return moment(year + '-' + month, 'YYYY-MM').daysInMonth();
                    }

                    $day.change(function() {
                        $day.parent().removeClass('bg-clr--red');
                    });

                    $('.input--year,.input--month').change(function() {
                        var numDays = getNumDaysMonthYear();
                        $day.find('option[value="28"] ~ option').show();
                        $day.find('option[value="' + numDays + '"] ~ option').hide();
                        if ($day.find('option:selected').is(':hidden')) {
                            $day.parent().addClass('bg-clr--red');
                        } else {
                            $day.parent().removeClass('bg-clr--red');
                        }
                    });
                    $('.date--form *').change(function() {
                        performCalculation();
                    });
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

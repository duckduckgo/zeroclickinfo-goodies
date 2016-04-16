// jshint jquery: true, browser: true, devel: true
DDH.date_math = DDH.date_math || {};

/* global DDG, DDH, Goodie, isNumber */
(function(DDH) {
    "use strict";

    DDH.date_math.build = function(ops) {

        var modifier_order = ops.data.modifiers.map(function(elt) {
            return elt.display;
        });

        function setFieldInvalid($field) {
            $field.addClass('input--invalid bg-clr--red');
        }

        function setFieldValid($field) {
            $field.removeClass('input--invalid bg-clr--red');
        }

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

                function isAmountValid(amountText) {
                    if (amountText.match(/^\d+$/)) {
                        return true;
                    }
                    return false;
                }

                $year.keyup(function() {
                    var yearText = $(this).val();
                    if (isValidYear(yearText)) {
                        setFieldValid($(this));
                    } else {
                        setFieldInvalid($(this));
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
                        var resultDate = moment(date);
                        var modifiers = {};
                        // Grab any modifiers and track amounts
                        $dom.find('.op--container .date--form').each(function() {
                            var amount = Number($(this).find('.input--op-amt').val());
                            var modifier = $(this).find('.input--op-type').val();
                            if (modifiers[modifier] === undefined) {
                                modifiers[modifier] = 0;
                            }
                            if ($(this).find('.input--op-op').hasClass('ddgsi-plus')) {
                                resultDate.add(amount, modifier);
                                modifiers[modifier] += amount;
                            } else {
                                resultDate.subtract(amount, modifier);
                                modifiers[modifier] -= amount;
                            }
                        });
                        // Update the 'start' date to include modifiers
                        $startDate.find('.date--start-modifiers').empty();
                        $.each(modifiers, function(modifier, amount) {
                            if (amount === 0) {
                                return;
                            }
                            var displayOp = '+';
                            if (amount < 0) {
                                displayOp = '-';
                            }
                            $('<span> ' + displayOp + ' ' +  Math.abs(amount) + ' ' + modifier + '</span>')
                                .appendTo($startDate.find('.date--start-modifiers'));
                        });
                        return resultDate;
                    }

                    function formatDate(date) {
                        return date.format('dddd MMMM Do YYYY HH:mm:ss');
                    }

                    function allFieldsValid() {
                        if ($dom.find('.date--form .input--invalid').length !== 0) {
                            return false;
                        }
                        return true;
                    }

                    function performCalculation() {
                        if (allFieldsValid() !== true) {
                            return;
                        }
                        var date = getDate();
                        if (date === undefined) {
                            return;
                        }
                        var result = calculateResult(date);
                        $startDate.find('.date--start-date').text(formatDate(date));
                        $resultDate.text(formatDate(result));
                    }

                    function initializeForm($par) {
                        $par.find('form').submit(function(e) {
                            e.preventDefault();
                        });
                        $par.find('.date--form *').change(function() {
                            performCalculation();
                        });
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
                            performCalculation();
                        });
                        $newOp.find('.input--op-amt').keyup(function() {
                            if (isAmountValid($(this).val())) {
                                setFieldValid($(this));
                            } else {
                                setFieldInvalid($(this));
                            }
                        });
                        performCalculation();
                    });

                    function getNumDaysMonthYear() {
                        var month = getMonth();
                        var year = getYear();
                        return moment(year + '-' + month, 'YYYY-MM').daysInMonth();
                    }

                    $day.change(function() {
                        setFieldValid($day.parent());
                    });

                    // Ensure day is within range
                    $('.input--year,.input--month').change(function() {
                        var numDays = getNumDaysMonthYear();
                        $day.find('option[value="28"] ~ option').show();
                        $day.find('option[value="' + numDays + '"] ~ option').hide();
                        if ($day.find('option:selected').is(':hidden')) {
                            setFieldInvalid($day.parent());
                        } else {
                            setFieldValid($day.parent());
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

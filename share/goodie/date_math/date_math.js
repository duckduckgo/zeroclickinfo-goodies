// jshint jquery: true, browser: true, devel: true
DDH.date_math = DDH.date_math || {};

/* global DDG, DDH, Goodie, isNumber */
(function(DDH) {
    "use strict";

    var modifier_order = [
        'Second', 'Minute', 'Hour',
        'Day', 'Week', 'Month', 'Year'
    ];
    function pad(text, padChar, padWidth) {
        var numPad = padWidth - text.length;
        if (numPad <= 0) {
            return text;
        }
        return padChar.repeat(numPad) + text;
    }

    function padZero(text, padWidth) {
        return pad(text, '0', padWidth);
    }

    var monthFormat = 'MMMM';
    var dayFormat   = 'Do';
    var weekdayFormat = 'dddd';
    var yearFormat = 'YYYY';

    var dateFormat = weekdayFormat + ' ' +
        dayFormat + ' ' + monthFormat + ' ' + yearFormat;

    function revertVal($elt) {
        $elt.val($elt.data('prev'));
    }

    function updateVal($elt, val) {
        $elt.val(val);
        $elt.data('prev', val);
    }

    function addModifier(name) {
        var lcName = name.toLowerCase();
        var id = 'input--op-' + lcName;
        $('<option value="' + lcName + '">' +
                name + 's</option>').appendTo($('.input--op-type'));
    }

    DDH.date_math.build = function(ops) {

        var saData = ops.data;
        var isInitialized = false;

        return {

            // Function that executes after template content is displayed
            onShow: function() {
                if (isInitialized) {
                    return;
                }
                isInitialized = true;
                var $dom = $(".zci--date_math"),
                    $month = $dom.find('.input--month'),
                    $day = $dom.find('.input--day'),
                    $year = $dom.find('.input--year'),
                    $startDate = $dom.find('.date--start'),
                    $resultDate = $dom.find('.date--result'),
                    $hour = $dom.find('.input--hour'),
                    $minute = $dom.find('.input--minute'),
                    $second = $dom.find('.input--second');

                DDG.require('moment.js', function() {
                    function getDate() {
                        var hour = $hour.val();
                        var minute = $minute.val();
                        var second = $second.val();
                        var date = moment(
                            $startDate.val(), dateFormat
                        );
                        date.set({
                            'hour': hour,
                            'minute': minute,
                            'second': second
                        });
                        return date;
                    }

                    var months = moment.months();

                    function setAmountInvalid() {
                        $('.input--op-amt').map(function() {
                            $(this)[0].setCustomValidity('Date out of range');
                        });
                    }

                    function setAmountValid() {
                        $('.input--op-amt').map(function() {
                            $(this)[0].setCustomValidity('');
                        });
                    }

                    function calculateResult(date) {
                        var resultDate = moment(date);
                        $dom.find('.input--op-amt').each(function() {
                            var amount = Number($(this).val());
                            var modifier = $(this).data('type');
                            resultDate.add(amount, modifier);
                        });
                        if (!isNaN(resultDate)) {
                            setAmountValid();
                        } else {
                            return;
                        }
                        return resultDate;
                    }

                    function formatDate(date) {
                        return date.format('dddd ' + dayFormat + ' ' + monthFormat + ' YYYY HH:mm:ss');
                    }

                    function dateFieldsValid() {
                        if ($dom.find('.input--date').find(':invalid').length > 0) {
                            return false;
                        }
                        return true;
                    }

                    $('input').focusout(function() {
                        if ($(this).val() === '') {
                            $(this).val($(this).data('prev'));
                        } else {
                            $(this).data('prev', $(this).val());
                        }
                    });

                    $month.change(function() {
                        var monthDate = moment($(this).val(), 'MMM');
                        if (!monthDate.isValid()) {
                            revertVal($(this));
                        } else {
                            updateVal($(this), (months[monthDate.month()]));
                        }
                    });

                    $('.input--date').change(function() {
                        if ($(this).is(':invalid')) {
                            $(this).val($(this).data('prev'));
                        }
                    });

                    $day.change(function() {
                        $(this).val($(this).val().replace(/\D/g, ''));
                        var dayDate = moment($(this).val(), 'D');
                        if (!dayDate.isValid()) {
                            revertVal($(this));
                        }
                    });

                    $day.focusin(function() {
                        $(this).val(function(idx, value) {
                            return value.replace(/\D/g, '');
                        });
                    });

                    $day.focusout(function() {
                        $day.val(function(idx, value) {
                            if ($day.is(':valid')) {
                                return DDG.getOrdinal(value.replace(/\D/g, ''));
                            } else {
                                return $(this).data('prev');
                            }
                        });
                    });

                    function updateStartDate(date) {
                        $startDate.find('.date--start-weekday').text(date.format('dddd'));
                        updateVal($month, date.format(monthFormat));
                        updateVal($day, date.format(dayFormat));
                        updateVal($year, date.format('YYYY'));
                        updateVal($hour, date.format('HH'));
                        updateVal($minute, date.format('mm'));
                        updateVal($second, date.format('ss'));
                    }

                    $('.date--start input').change(function() {
                        var date = getDate();
                        $startDate.find('.date--start-weekday').text(date.format('dddd'));
                    });

                    function performCalculation() {
                        if (dateFieldsValid() !== true) {
                            return;
                        }
                        var date = getDate();
                        if (date === undefined || !date.isValid()) {
                            return;
                        }
                        var result = calculateResult(date);
                        if (result === undefined || !result.isValid()) {
                            return;
                        }
                        $resultDate.text(formatDate(result));
                    }

                    function classForOp(op) {
                        if (op === '+') {
                            return 'ddgsi-plus';
                        }
                        if (op === '-') {
                            return 'ddgsi-minus';
                        }
                    }
                    function initializeForms() {
                        modifier_order.map(function(elt) {
                            addModifier(elt);
                        });
                        $('.input--date, .input--op-amt').change(function() {
                            performCalculation();
                        });
                        saData.actions.map(function(modifier) {
                            $('.input--op-' + modifier.type.toLowerCase()).val(modifier.amount);
                        });
                        updateStartDate(moment.unix(saData.start_date));
                        $month.attr('maxlength', Math.max.apply(null, months.map(function(month) {
                            return month.length;
                        })));
                    }

                    $dom.find('.input--time input').change(function() {
                        $(this).val(function(idx, value) {
                            return padZero(value, 2);
                        });
                    });

                    DDG.require('pikaday', function() {
                        var picker = new Pikaday({
                            field: $('.date--start')[0],
                            format: dateFormat,
                            firstDay: 1,
                            yearRange: [1, 9999],
                            defaultDate: moment.unix(saData.start_date)
                        });
                    });

                    // Edit indication for start date fields

                    function getNumDaysMonthYear() {
                        var month = getMonth();
                        var year = getYear();
                        return moment({
                            'year': year,
                            'month': month
                        }).daysInMonth();
                    }

                    initializeForms();
                    performCalculation();
                });
            }
        };
    };
})(DDH);

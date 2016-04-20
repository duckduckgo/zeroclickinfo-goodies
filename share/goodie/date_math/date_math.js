// jshint jquery: true, browser: true, devel: true
DDH.date_math = DDH.date_math || {};

/* global DDG, DDH, Goodie, isNumber */
(function(DDH) {
    "use strict";

    DDH.date_math.build = function(ops) {

        var saData = ops.data;
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
                    $opTemplate = $dom.find('.template--op').clone(),
                    $ops = $dom.find('.op--container'),
                    $hour = $dom.find('.input--hour'),
                    $minute = $dom.find('.input--minute'),
                    $second = $dom.find('.input--second');

                $dom.find('form').submit(function(e) {
                    e.preventDefault();
                });
                function getMonth() { return $month.val(); }

                function getDay() { return $day.val(); }

                function getYear() { return $year.val(); }

                function isAmountValid(amountText) {
                    if (amountText.match(/^\d+$/)) {
                        return true;
                    }
                    return false;
                }

                var monthFormat = 'MMMM';
                var dayFormat   = 'Do';
                DDG.require('moment.js', function() {
                    function getDate() {
                        var month = getMonth();
                        var day = getDay();
                        var year = getYear();
                        var hour = $hour.val();
                        var minute = $minute.val();
                        var second = $second.val();
                        var time = hour + ':' + minute + ':' + second;
                        var date = moment(year + "-" + month + "-" + day +
                                ' ' + time, "YYYY-" + monthFormat + '-' + dayFormat + ' HH:mm:ss');
                        return date;
                    }

                    var months = moment.months();

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
                            amount = Math.abs(amount);
                            $('<span> ' + displayOp + ' ' +  amount + ' ' + DDG.pluralize(amount, modifier) + '</span>')
                                .appendTo($startDate.find('.date--start-modifiers'));
                        });
                        return resultDate;
                    }

                    function formatDate(date) {
                        return date.format('dddd ' + monthFormat + ' ' + dayFormat + ' YYYY HH:mm:ss');
                    }

                    function allFieldsValid() {
                        if ($dom.find('.date--form .input--invalid').length !== 0) {
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

                    function revertVal($elt) {
                        $elt.val($elt.data('prev'));
                    }

                    function updateVal($elt, val) {
                        $elt.val(val);
                        $elt.data('prev', val);
                    }

                    $month.change(function() {
                        var monthDate = moment($(this).val(), 'MMM');
                        if (!monthDate.isValid()) {
                            revertVal($(this));
                        } else {
                            updateVal($(this), (months[monthDate.month()]));
                        }
                    });

                    $('input .input--date').change(function() {
                        if ($(this).hasClass('.input--invalid')) {
                            $(this).val($(this).data('prev'));
                            setFieldValid($(this));
                        }
                    });
                    $day.focusin(function() {
                        $(this).val(function(idx, value) {
                            return value.replace(/\D/g, '');
                        });
                    });
                    var savedDate = {};

                    $day.focusout(function() {
                        $day.val(function(idx, value) {
                            return DDG.getOrdinal(value);
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
                        if (allFieldsValid() !== true) {
                            return;
                        }
                        var date = getDate();
                        if (date === undefined || !date.isValid()) {
                            return;
                        }
                        var result = calculateResult(date);
                        $resultDate.text(formatDate(result));
                    }

                    function initializeForm($par) {
                        $par.find('.date--form *').change(function() {
                            performCalculation();
                        });
                    }
                    function classForOp(op) {
                        if (op === '+') {
                            return 'ddgsi-plus';
                        }
                        if (op === '-') {
                            return 'ddgsi-minus';
                        }
                    }
                    function addModifier(op, amount, type) {
                        var $newOp = $opTemplate.clone();
                        $newOp.removeClass('template--op hide');
                        $newOp.appendTo('.op--container');
                        initializeForm($newOp);
                        $newOp.find('.input--op-op').addClass(classForOp(op));
                        $newOp.find('.input--op-amt').val(amount);
                        $newOp.find('.input--op-type').val(type);
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
                        $newOp.find('.input--op-amt').on('change keyup', function() {
                            if (isAmountValid($(this).val())) {
                                setFieldValid($(this));
                            } else {
                                setFieldInvalid($(this));
                            }
                        });
                        $newOp.find('.op--delete').click(function() {
                            $newOp.remove();
                            performCalculation();
                        });
                        performCalculation();
                    }
                    function initializeForms() {
                        modifier_order.map(function(elt) {
                            $('<option value="' + elt.toLowerCase() + '">' +
                                    elt + 's</option>').appendTo($opTemplate.find('.input--op-type'));
                        });
                        saData.actions.map(function(modifier) {
                            addModifier(modifier.operation, modifier.amount, modifier.type);
                        });
                        updateStartDate(moment.unix(saData.start_date));
                        $month.attr('maxlength', Math.max.apply(null, months.map(function(month) {
                            return month.length;
                        })));
                        $dom.find('.input--date').addClass('tx-clr--slate-light');
                        $dom.find('.input--numeric, .input--numeric .input--date').data('reject', '\\D');
                        $dom.find('.input--time *').attr('pattern', '\\d{1,2}');
                    }
                    $dom.find('.op--add').click(function() {
                        var $lastOp = $ops.find('.date--form').last();
                        if ($lastOp.length === 0) {
                            addModifier('+', '1', 'day');
                        } else {
                            var amount = $lastOp.find('.input--op-amt').val();
                            var type   = $lastOp.find('.input--op-type').val();
                            var op     = $lastOp.find('.input--op-op')
                                .hasClass('ddgsi-plus') ? '+' : '-';
                            addModifier(op, amount, type);
                        }
                    });

                    $dom.find('input[pattern!=""]').keyup(function() {
                        var patt = $(this).attr('pattern');
                        if (!$(this).val().match(patt)) {
                            setFieldInvalid($(this));
                        } else {
                            setFieldValid($(this));
                        }
                    });
                    $dom.find('input[data-reject!=""]').keyup(function() {
                        var patt = new RegExp($(this).data('reject'), 'g');
                        $(this).val(function(idx, value) {
                            return value.replace(patt, '');
                        });
                    });

                    $dom.find('input[max!=""]').keyup(function() {
                        var max = $(this).attr('max');
                        $(this).val(function(idx, value) {
                            if (Number(value) > Number($(this).attr('max'))) {
                                return value.substr(0, value.length - 1);
                            }
                            return value;
                        });
                    });

                    $dom.find('.date--start-date').click(function() {
                        var $popup = $dom.find('.date--popup');
                        if ($popup.hasClass('is-showing')) {
                            $popup.removeClass('is-showing');
                        } else {
                            $popup.addClass('is-showing');
                        }
                    });

                    $dom.find('.input--time input').change(function() {
                        $(this).val(function(idx, value) {
                            return padZero(value, 2);
                        });
                    });

                    function getNumDaysMonthYear() {
                        var month = getMonth();
                        var year = getYear();
                        return moment(year + '-' + month, 'YYYY-' + monthFormat).daysInMonth();
                    }

                    // Ensure day is within range
                    $('.input--year,.input--month').change(function() {
                        var numDays = getNumDaysMonthYear();
                        $day.attr('max', numDays);
                        if (Number($day.val()) > numDays) {
                            setFieldInvalid($day);
                        } else {
                            setFieldValid($day);
                        }
                    });
                    $('.input--date, .date--form *').change(function() {
                        performCalculation();
                    });
                    initializeForms();
                });
            }
        };
    };
})(DDH);

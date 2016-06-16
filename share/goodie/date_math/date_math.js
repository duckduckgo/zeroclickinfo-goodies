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

    function addModifier(name) {
        var lcName = name.toLowerCase();
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
                    $startDate = $dom.find('.date--start'),
                    $resultDate = $dom.find('.date--result'),
                    $amount = $dom.find('.input--op-amt'),
                    $type = $dom.find('.input--op-type'),
                    $sign = $dom.find('.input--op-sign'),
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

                    function setAmountInvalid() {
                        $amount[0].setCustomValidity('Date out of range');
                    }

                    function setAmountValid() {
                        $amount[0].setCustomValidity('');
                    }

                    function getSign() {
                        return $sign.hasClass('ddgsi-plus') ? '+' : '-';
                    }

                    function calculateResult(date) {
                        var resultDate = moment(date);
                        var amount = Number($amount.val());
                        amount = getSign() === '+' ?
                            amount : -amount;
                        var type = $type.val();
                        resultDate.add(amount, type);
                        if (!isNaN(resultDate)) {
                            setAmountValid();
                        } else {
                            setAmountInvalid();
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

                    function initializeOp(amount, type) {
                        $amount.val(amount);
                        $type.val(type);
                    }
                    $sign.click(function() {
                        if ($(this).hasClass('ddgsi-plus')) {
                            $(this).removeClass('ddgsi-plus')
                                .addClass('ddgsi-minus');
                        } else {
                            $(this).removeClass('ddgsi-minus')
                                .addClass('ddgsi-plus');
                        }
                        performCalculation();
                    });
                    function initializeForms() {
                        modifier_order.map(function(elt) {
                            addModifier(elt);
                        });
                        var startDate = moment.unix(saData.start_date);
                        $hour.val(startDate.format('HH'));
                        $minute.val(startDate.format('mm'));
                        $second.val(startDate.format('ss'));
                        $('.input--date *, .input--op *').change(function() {
                            performCalculation();
                        });
                        initializeOp(saData.operation.amount, saData.operation.type);
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
                        });
                        picker.setMoment(moment.unix(saData.start_date));
                    });

                    initializeForms();
                    performCalculation();
                });
            }
        };
    };
})(DDH);

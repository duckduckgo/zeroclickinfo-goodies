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

    function buildModifierOption(name, active) {
        var lcName = name.toLowerCase();
        return '<option value="' + lcName + '"' +
            (active ? ' selected>' : '>') + name + 's</option>';
    }

    function buildModifierOptions(startElt) {
        return modifier_order.map(function(elt) {
            return buildModifierOption(elt, (elt.toLowerCase() === startElt));
        }).join('');
    }

    function signToText(sign) {
        return sign === '+' ? 'plus' : 'minus';
    }

    DDH.date_math.build_async = function(ops, DDH_build_async) {

        var saData = ops.data;
        var isInitialized = false;

        DDG.require(['moment.js', 'pikaday'], function() {
            var startDate = moment.unix(saData.start_date);
            DDH_build_async({
                templates: {
                    group: 'base',
                    options: {
                        content: 'DDH.date_math.content',
                    },
                },
                meta: {
                    rerender: ["result"]
                },
                normalize: function(item) {
                    return {
                        hour: startDate.format('HH'),
                        minute: startDate.format('MM'),
                        second: startDate.format('ss'),
                        amount: saData.operation.amount,
                        modifierOptions: buildModifierOptions(
                            saData.operation.type
                        ),
                        startDate: startDate.format(dateFormat),
                        sign: signToText(saData.operation.sign),
                        result: ''
                    };
                },
                // Function that executes after template content is displayed
                onShow: function() {
                    if (isInitialized) {
                        return;
                    }
                    isInitialized = true;
                    var $dom = $(".zci--date_math"),
                        $sign = $dom.find('.input--op-sign');

                    $dom.find('.input--time input').change(function() {
                        $(this).val(function(idx, value) {
                            return padZero(value, 2);
                        });
                    });
                    $sign.click(function() {
                        if ($(this).hasClass('ddgsi-plus')) {
                            $(this).removeClass('ddgsi-plus')
                                .addClass('ddgsi-minus');
                        } else {
                            $(this).removeClass('ddgsi-minus')
                                .addClass('ddgsi-plus');
                        }
                    });

                },
                onItemShown: function(item) {
                    var $dom = $(".zci--date_math"),
                        $startDate = $dom.find('.date--start'),
                        $amount = $dom.find('.input--op-amt'),
                        $type = $dom.find('.input--op-type'),
                        $sign = $dom.find('.input--op-sign'),
                        $hour = $dom.find('.input--hour'),
                        $minute = $dom.find('.input--minute'),
                        $second = $dom.find('.input--second');

                    var picker = new Pikaday({
                        field: $('.date--start')[0],
                        format: dateFormat,
                        firstDay: 1,
                        yearRange: [1, 9999],
                    });
                    picker.setMoment(startDate);

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
                        $('.input--op-amt')[0].setCustomValidity('Date out of range');
                    }

                    function setAmountValid() {
                        $('.input--op-amt')[0].setCustomValidity('');
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
                        item.set({result: formatDate(result)});
                    }

                    $sign.click(function() {
                        performCalculation();
                    });
                    $('.input--date *, .input--op *').change(function() {
                        performCalculation();
                    });
                }
            });
        });
    };
})(DDH);

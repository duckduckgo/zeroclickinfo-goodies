// jshint jquery: true, browser: true, devel: true
//
DDH.calculator = DDH.calculator || {};

/* global DDG, Goodie, isNumber */
DDH.calculator.build = function() {
    function clog() {
        if (console && typeof console !== 'undefined') {
            var args = Array.prototype.slice.apply(arguments);
            args.unshift('%c[ia:calculator]', 'font-weight:bold');
            console.log.apply(console, args);
        }
    }
    function isNumber(n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    }
    var Utils = {
        cancelEvent: function(e) {
            e.preventDefault();
            e.stopPropagation();
            e.stopImmediatePropagation();
        }
    };

    var MathHelper = {
        _factorialCache: [],
        factorial: function(n) {
            // TOREVISIT - from http://stackoverflow.com/a/3959275/1139682
            if (n === 0 || n === 1)
                return 1;
            if (MathHelper._factorialCache[n] > 0)
                return MathHelper._factorialCache[n];
            return MathHelper._factorialCache[n] = MathHelper.factorial(n-1) * n;
        }
    };

    /**
     * Keycodes of keys
     * @type {Object}
     */
    var K = {
        BACKSPACE: 8,
        ENTER: 13,
        ESC: 27,
        SPACE: 32
    };

    /**
     * Key aliases to commands
     * @type {Object}
     */
    var KEY_ALIASES = {
        '%': 'OP_PCT',
        '*': 'OP_MULT',
        '/': 'OP_DIV',
        '÷': 'OP_DIV',
        '+': 'OP_PLUS',
        '-': 'OP_MINUS',
        '^': 'FN_POW_N',
        '(': 'META_PAR_OPEN',
        ')': 'META_PAR_CLOSE',
        '=': 'META_PROCEED',
        'E': 'FN_EE'
    };

    /**
     * Supported math operations
     * @type {Object}
     */
    var OPS = {
        'OP_PCT': {
            tpl: '<span>%</span>',
            calc: function(prev) {
                return Number(prev) / 100;
            }
        },
        'OP_MULT': {
            tpl: '<span> × </span>',
            rep: '×',
            calc: function(prev, after) {
                return Number(prev) * Number(after);
            }
        },
        'OP_DIV': {
            tpl: '<span> ÷ </span>',
            rep: '÷',
            calc: function(prev, after) {
                return Number(prev) / Number(after);
            }
        },
        'OP_PLUS': {
            tpl: '<span> + </span>',
            rep: '+',
            calc: function(prev, after) {
                return Number(prev) + Number(after);
            }
        },
        'OP_MINUS': {
            tpl: '<span> - </span>',
            rep: '-',
            calc: function(prev, after) {
                return Number(prev) - Number(after);
            }
        }
    };

    /**
     * Supported math functions/expressions
     * @type {Object}
     */
    var FNS = {
        'FN_POW_2': {
            fields: 1,
            tpl: '<span><span class="calc-field">{{1}}</span><sup>2</sup></span>',
            calc: function(x) {
                return Math.pow(+x, 2);
            }
        },
        'FN_POW_N': {
            fields: 2,
            tpl: '<span><span class="calc-field">{{1}}</span><sup class="calc-field">{{2}}</sup></span>',
            calc: function(x, y) {
                return Math.pow(+x, +y);
            }
        },
        'FN_SQRT': {
            fields: 1,
            tpl: '<span>√<span class="calc-field">{{1}}</span></span>',
            calc: function(x) {
                return Math.sqrt(+x);
            }
        },
        'FN_SQRT_N': {
            fields: 2,
            tpl: '<span><sup class="calc-field">{{1}}</sup>√<span class="calc-field">{{2}}</span></span>',
            calc: function(x, y) {
                return Math.pow(y, 1/x);
            }
        },
        'FN_SIN': {
            fields: 1,
            rep: function (fields) {
                return ("sin(" + fields.join('; ') + ")");
            },
            tpl: '<span>sin(<span class="calc-field">{{1}}</span>)</span>',
            calc: Math.sin
        },
        'FN_COS': {
            fields: 1,
            tpl: '<span>cos(<span class="calc-field">{{1}}</span>)</span>',
            calc: Math.cos
        },
        'FN_TAN': {
            fields: 1,
            tpl: '<span>tan(<span class="calc-field">{{1}}</span>)</span>',
            calc: Math.tan
        },
        'FN_FACT': {
            fields: 1,
            tpl: '<span>{{1}}!</span>',
            calc: MathHelper.factorial
        },
        'FN_EE': {
            fields: 2,
            tpl: '<span><span class="calc-field">{{1}}</span>E<span class="calc-field">{{2}}</span></span>',
            calc: function(x, y) {
                return Number(Number(x) + 'e' + Number(y));
            }
        },
        'FN_LOG': {
            fields: 1,
            tpl: '<span>log(<span class="calc-field">{{1}}</span>)</span>',
            calc: function(x) {
                // TODO
                return Math.log(Number(x));
            }
        },
        'FN_LN': {
            fields: 1,
            tpl: '<span>ln(<span class="calc-field">{{1}}</span>)</span>',
            calc: Math.log // NOTE: On JS Math.log() is the real ln (thug life)
        }
    };

    /**
     * Constants TODO
     * @type {Object}
     */
    var CONSTS = {
        'TODO': {}
    };
    /**
     * Formula
     * Handles presentation & calculation
     * @param {String?} initialFormStr Formula string
     */
    function Formula(initialFormStr) {
        this.storage = [''];
        this.cursor = [0];
        this.isCalculated = false;

        if (typeof initialFormStr !== 'undefined') {
            this.handleString(''+initialFormStr);
        } else {
            this.handleString('0');
        }
    }

    ////////////////////
    /// Virtual cursor
    ////////////////////

    /**
     * Move cursor to specific position
     * @param  {Array} pos Field position
     */
    Formula.prototype.moveCursorTo = function(pos) {
        clog('[F.moveCursorTo] pos:', pos);
        this.cursor = pos;
    };

    /**
     * Move cursor a level lower
     * e.g: When closing a parathensis
     */
    Formula.prototype.levelDown = function() {
        if (this.cursor.length > 1) {
            this.cursor.pop();
        }
    };

    ///////////////
    /// STORAGE:
    /// Read
    ///////////////

    /**
     * Get field's value
     * @param  {Array} pos  Position index
     * @return {String|Array} Field's value
     */
    Formula.prototype.getField = function(pos) {
        var ctx = this.storage;
        var maxDepth = pos.length;
        for (var i = 0; i < maxDepth; ++i) {
            ctx = ctx[pos[i]];
        }
        return (typeof ctx === 'undefined' ? '' : (
            (jQuery.isArray(ctx) ? ctx  : '' + ctx)
        ));
    };


    /**
     * Get the value of the cursor's field
     * @return {String} value
     */
    Formula.prototype.getActiveField = function() {
        return this.getField(this.cursor);
    };

    /**
     * Get next fragment's position
     * @return {Array} Position index
     */
    Formula.prototype.nextFragmentPos = function() {
        // TOREVISIT
        // if (this.cursor.length > 1) {
        //     clog('[nextFragmentPos]: multilevel ');
        // }
        var pos = [].concat(this.cursor);
        pos[pos.length - 1]++;
        return pos;
    };


    /**
     * Traverse storage from right to left and upwards until it encounters:
     * - a number (not constant)
     * - the most left empty field
     * @param  {Array?} posCtx
     * @return {Array}          Position index
     */
    Formula.prototype.nextFieldToFillPos = function(posCtx) {
        if (typeof posCtx === 'undefined') {
            posCtx = [];
        }

        // if lastField is Array
        //     recursive
        // else if lastField is empty (fragment is: FN_)
        //     loop backwardsWithinFragment until lastField is not empty
        //         when lastField is not empty
        //             go forwards once
        // else
        //     newFragment
        var lastFragment = this.getField(posCtx);
        if (jQuery.isArray(lastFragment)) {
            var lastFieldIndex = lastFragment.length - 1;
            var lastField = lastFragment[lastFieldIndex];
            if (jQuery.isArray(lastField)) {
                return this.nextFieldToFillPos(
                    posCtx.concat([lastFieldIndex])
                );
            } else if (lastField === '') {
                while (lastFieldIndex > 0) {
                    if (lastFragment[lastFieldIndex - 1] === '') {
                        lastFieldIndex--;
                    }
                }
                if (lastFieldIndex > 0) {
                    if (isNumber(lastFragment[lastFieldIndex - 1])) {
                        lastFieldIndex--;
                    }
                }
                return posCtx.concat([lastFieldIndex]);
            } else {
                if (!FNS.indexOf(lastFragment[0])) {
                    clog('[F.nextFieldToFillPos] withinFnArr lastFragment:', lastFragment);
                    // TODO: Depends on cursor having pressed closing parenthesis
                    //posCtx
                }
            }
        } else {
            // NESTED?
            clog('[F.nextFieldToFillPos] lastFragment: none array:', lastFragment);
        }
    };

    // TODO: Better name
    Formula.prototype.getPreviousFieldPosWhole = function(ctx, pos) {
        if (typeof ctx === 'undefined') {
            ctx = this.storage;
            pos = [];
        }

        var ctxIndex = Math.max(0, ctx.length - 1, 0);
        var prevFieldToFill = ctx[ctxIndex];
        pos.push(ctxIndex);

        if (jQuery.isArray(prevFieldToFill)) {
            return this.getPreviousFieldPosWhole(prevFieldToFill, pos);
        } else {
            return pos;
        }
    };

    Formula.prototype.hasPreviousField = function() {
        return (this.cursor[this.cursor.length - 1] > 0);
    };

    Formula.prototype.getPreviousFieldPos = function() {
        var prevCursor = [].concat(this.cursor);
        if (prevCursor[prevCursor.length - 1] > 0) {
            prevCursor[prevCursor.length - 1] -= 1;
            return prevCursor;
        } else {
            return false;
        }
    };

    Formula.prototype.getPreviousFieldInFragment = function() {
        var prevCursor = this.getPreviousFieldPos();
        if (prevCursor !== false) {
            return this.getField(prevCursor);
        } else {
            return false;
        }
    };

    Formula.prototype.canReplaceField = function(val, toBeReplacedByType) {
        if (jQuery.isArray(val)) {
            return false; // addNew
        } else if (isNumber(val) || !val.indexOf('CONST_')) {
            return true; // useField
        } else { // OP, FN
            return false;
        }
    };

    Formula.prototype.getLastReplaceableFieldPos = function(toBeReplacedByType) {
        var lastField = this.getField(this.cursor);
        if (lastField !== '') {
            return (
                this.canReplaceField(lastField, toBeReplacedByType) ?
                this.cursor :
                false
            );
        } else {
            var prevCursor = this.getPreviousFieldPos();
            if (prevCursor !== false) {
                var prevFieldVal = this.getField(prevCursor);
                return (
                    this.canReplaceField(prevFieldVal, toBeReplacedByType) ?
                    prevCursor :
                    false
                );
            } else {
                return this.cursor;
            }
        }
    };


    /**
     * Get the first field of a fragment
     * @param  {Array?} pos Fragment's position on storage array
     *                      - by default cursor's position
     */
    Formula.prototype.getStartingFieldInFragment = function(pos) {
        if (typeof pos === 'undefined') {
            pos = this.cursor;
        }

        var i, ctx = this.storage;
        for (i = 0; i < pos.length - 1; ++i) {
            ctx = ctx[pos[i]];
        }
        return ctx[0];
    };

    ///////////////
    /// STORAGE:
    /// Manipulate
    ///////////////

    /**
     * Add new fragment to formula storage
     * @param  {Mixed}  val Value of new fragment could be String or Array
     * @param  {Array?} pos Target position on storage array - by default move to next fragment
     */
    Formula.prototype.fragmentNew = function(val, pos) {
        if (typeof pos === 'undefined') {
            pos = this.nextFragmentPos();
        }

        var i, ctx = this.storage;
        for (i = 0; i < pos.length - 1; ++i) {
            ctx = ctx[pos[i]];
        }
        clog('[fragmentNew]val:', val);
        ctx[pos[i] || 0] = val;

        if (jQuery.isArray(val)) {
            var potNextCursorPos = val.indexOf('');
            if (potNextCursorPos !== -1) {
                this.moveCursorTo(pos.concat([potNextCursorPos]));
            } else {
                // TODO
                // What to do when fragment is filled
                // Probably case by case
            }
        } else {
            this.moveCursorTo(pos);
        }
    };

    /**
     * Continue filling existing fragment of the formula storage
     * @param  {String} str Value to append to a fragment
     * @param  {Array?} pos Target position on storage array
     *                      - by default the cursor fragment
     */
    Formula.prototype.fragmentAppend = function(str, pos) {
        if (typeof pos === 'undefined') {
            pos = this.cursor;
        }

        var i, ctx = this.storage;
        for (i = 0; i < pos.length - 1; ++i) {
            ctx = ctx[pos[i]];
        }
        ctx[pos[i] || 0] += str;
    };

    /**
     * Replace existing fragment of the formula storage
     * @param  {Mixed}  val  Value to put on the fragment
     * @param  {Array?} pos  Target position on storage array
     *                       - by default the cursor fragment
     */
    Formula.prototype.fragmentReplace = function(str, pos) {
        if (typeof pos === 'undefined') {
            pos = this.cursor;
        }

        var i, ctx = this.storage;
        for (i = 0; i < pos.length - 1; ++i) {
            ctx = ctx[pos[i]];
        }
        ctx[pos[i] || 0] = str;

        this.moveCursorTo(pos);
    };

    /**
     * Remove fragment from the formula storage
     * @param  {Array?} pos  Target position on storage array
     *                       - by default the cursor fragment
     */
    Formula.prototype.fragmentRemove = function(pos) {
        if (typeof pos === 'undefined') {
            pos = this.cursor;
        }
        clog('[fragmentRemove] before:', this.storage);
        var i, ctx = this.storage;
        for (i = 0; i < pos.length - 1; ++i) {
            ctx = ctx[pos[i]];
        }
        ctx.splice(pos[i], 1);
        this.storage = ctx;

        clog('[fragmentRemove] after:', this.storage);

        this.moveCursorTo(this.getPreviousFieldPosWhole());
    };

    /**
     * Remove the ending fragment from the formula storage
     */
    Formula.prototype.fragmentRemoveEnding = function() {

        //endingFragment
    };

    ////////////////////
    // INPUT HANDLERS
    Formula.prototype.handleString = function(str) {
        var _str = '' + str;
        for (var i = 0; i < _str.length; ++i) {
            this.handleChr(_str[i], true);
        }
    };

    Formula.prototype.handleChr = function(chr, skipRender) {
        var curField = this.getActiveField();
        if (chr === ' ') {
            // TODO
            // 1. if in FN go to next field of FN
        } else if (isNumber(curField + chr)) {
            if (curField === '0' && chr !== '.') {
                curField = '';
            }
            this.fragmentReplace((curField + chr).trim());
        } else if (isNumber(chr)) {
            this.fragmentNew(chr);
        } else {
            // TODO
            // this.fragmentNew(chr);
        }

        clog('[pushChr]('+chr+') storage:', this.storage);
        if (!skipRender) {
            this.render();
        }
    };

    Formula.prototype.handleCmd = function(type, cmd, skipRender) {
        var lastFieldPos = this.getLastReplaceableFieldPos();
        var lastField = (lastFieldPos !== false ? this.getField(lastFieldPos) : false);
        clog('[F.handleCmd] type:', type, 'cmd:', cmd, 'lastField:', lastField);
        if (type === 'OP' && typeof OPS[cmd] !== 'undefined') {
            // this.fragmentNew(cmd);
            console.log("Rep: " + OPS[cmd].rep);
            this.fragmentNew(OPS[cmd].rep);
        } else if (type === 'FN' && typeof FNS[cmd] !== 'undefined') {
            // var newFragValue = [cmd].concat(Array(FNS[cmd].fields).join('.').split('.'));
            // var newFragValue = [cmd.rep].concat(Array(FNS[cmd].fields).join('.').split('.'));
            console.log("Fields: " + FNS[cmd].fields);
            var newFragValue = [cmd].concat(Array(FNS[cmd].fields).join('.').split('.'));
            // var newFragValue = FNS[cmd].rep(Array(FNS[cmd].fields));
            if (lastField !== false && (
                !lastField.indexOf('CONST_') || isNumber(lastField)
            )) {
                newFragValue[1] = lastField;
                this.fragmentRemove();
                this.fragmentNew(newFragValue);
                //TODO Move cursor to nextToFillPos this.
            } else {
                this.fragmentNew(newFragValue);
            }
        }

        if (!skipRender) {
            this.render();
        }
    };

    /**
     * Backspace logic
     *    *** UNDER CONSTRUCTION ***
     */
    Formula.prototype.handleBackspace = function() {
        if (this.isCalculated) {
            this.reset();
            return;
        }

        var curField = this.getActiveField();
        clog('[Formula.handleBackspace] curField:', curField);
        if (curField.length > 0 && isNumber(curField)) {
            curField = curField.slice(0, -1);
            this.fragmentReplace(curField);
        } else {
            // if there is a previous field
            //     if previous field is FN|PARENTHS
            //        remove fragmentArr|replace with empty ''
            //        remove FN|replace with empty ''
            //     else if previous field is CONST|OP
            //        replace fragment with empty ''
            //     else if previous field is NUM
            //        move to that field's end
            //     else if previous field is ''
            //        move to that field
            // else if there is no field
            //      replace fragmentArr with ''

            if (this.hasPreviousField()) {
                var prevField = this.getPreviousFieldInFragment();
                if (prevField === false || !prevField.indexOf('FN_')) {
                    this.fragmentReplace('', this.cursor.slice(0, -1));
                } else if (!prevField.indexOf('CONST_') || !prevField.indexOf('OP_')) {
                    this.fragmentReplace('');
                } else if (prevField.length > 0) { // NUM
                    this.fragmentRemove();
                } else if (prevField === '') {
                    var prevPos = this.getPreviousFieldPos();
                    if (this.getStartingFieldInFragment().indexOf('FN_') === -1) {
                        // delete field and move cursor to prevField
                        this.fragmentRemove();
                    } else {
                        // move cursor to prevField
                    }
                    this.moveCursorTo(prevPos);

                } else {
                    clog('TOIMPLEMENT: [handleBackspace] had prevField:', prevField);
                }
            } else {
                //clog('BACKSPACE WHILE EMPTY');
            }

            // ---after replacements
            // if currField is '' and has previous field
            //    if previous field is NUM
            //       move to that field's send
            //    else
            //       stay

            //remove last fragment
        }

        this.render();
    };

    ////////////////////
    /// Calculations ///

    /**
     * Calculate operations of a fragment (OPS)
     * @param  {Array} _frag  Subset of Formula.storage
     * @return {Number}       Computed result of the fragment
     */
    Formula.prototype.calculateOperations = function(_frag) {
        clog('[calculateOperations]:', _frag);
        var frag = [].concat(_frag);
        jQuery.each(OPS, function(opName) {
            var opPosition = frag.indexOf(opName);
            while (opPosition !== -1) {
                clog('FOUND OP:', opPosition, opName, 'opFrag:', frag[opPosition]);
                var opCalc = OPS[frag[opPosition]].calc;
                var args = [frag[opPosition - 1]];
                if (opCalc.length === 2) {
                    args.push(frag[opPosition + 1]);
                }
                frag[opPosition - 1] = opCalc.apply(null, args);

                // remove calc'd arguments
                frag.splice(opPosition, opCalc.length);
                opPosition = frag.indexOf(opName);
            }
        });
        if (frag.length > 1) {
            clog('[F.calculateOperations] INVESTIGATE:', frag);
            return frag;
        }
        return frag[0];
    };

    Formula.prototype.calculateFragment = function(frag) {
        clog('[calculateFragment]', frag);
        if (jQuery.isArray(frag)) {
            if (typeof FNS[frag[0]] !== 'undefined') {
                for (var i = 1; i < frag.length; i++) {
                    frag[i] = this.calculateFragment(frag[i]);
                }
                clog('FNS:',frag[0]);
                return FNS[frag[0]].calc.apply(this, frag.slice(1));
            } else { // Parenthesis
                return this.calculateOperations(frag);
            }
        } else if (isNumber(frag)) {
            return +frag;
        //} else if () { // TODO CONSTS++
        } else {

        }
    };

    Formula.prototype.calculateResult = function(_arr, _path) {
        // var query = $("#tile__past-formula").val();
        console.log("Rep: " + calc._cache.$inputField.value);
        console.log("Storage: " + this.storage);
        console.log("Storage[0]: " + this.storage[0]);
        var query = this.storage.join('');
        console.log("Query: " + query);
        // $.getJSON("https://crossorigin.me/" + "https://api.duckduckgo.com/?format=json&q=" + query, function(data) {
        // $.getJSON("https://crossorigin.me/" + "https://api.duckduckgo.com/?format=json&q=1+7", function(data) {
        // $.getJSON("https://crossorigin.me/" + "https://api.duckduckgo.com/?format=json&q=" + encodeURIComponent(query), function(data) {
        var answer;
        // $.getJSON("https://crossorigin.me/" + "https://beta.duckduckgo.com/?format=json&q=" + encodeURIComponent(query), function(data) {
        $.getJSON("http://localhost:5000/?format=json&q=" + encodeURIComponent(query), function(data) {
            // console.log("Data: " + data);
            // console.log("Answer: " + data.Answer);
            // var answ1 = data.Answer.data.subtitle;
            // console.log("sub: " + answ1);
            var answerValue = data.Answer.data.text_result;
            var formattedInput = data.Answer.data.parsed_input;
            // var answerComponents = data.Answer.match(/^([0-9\.,]+) ([a-zA-Z].*)$/);
            // var answerValue = answerComponents[1].replace(/,/g,"");
            // console.log("Value: " + answerValue);
            // $("#tile__past-calc").text(answerValue);
            // $("#tile__past-formula").text(answerValue);
            calc._cache.$inputField.text(answerValue);
            calc.history.add(formattedInput, answerValue);
            answer = answerValue;
            return answerValue;
        });
        return answer;
        // var arr = _arr || [].concat(this.storage);
        // var path = _path || [];
        // var type = jQuery.type(arr);

        // // arr should be an array
        // var flatArr = [];
        // for (var i = 0; i < arr.length; i++) {
        //     type = jQuery.type(arr[i]);
        //     switch (type) {
        //     case 'array':
        //         flatArr[i] = this.calculateFragment(arr[i]);
        //         break;
        //     default: //case 'string':
        //         // check Constants handling
        //         flatArr[i] = /*temp*/ (isNumber(arr[i]) ? +arr[i] : arr[i]);
        //         break;
        //     }
        // }

        // // OP_*
        // flatArr = this.calculateOperations(flatArr);
        // // TEMP FIX: For push
        // if (jQuery.isArray(flatArr)) {
        //     for (i = 0; i < flatArr.length; i++) {
        //         if (typeof flatArr[i] !== 'undefined') {
        //             return flatArr[i];
        //         }
        //     }
        // }
        // return flatArr;
    };

    Formula.prototype.calculate = function() {
        this.isCalculated = true;
        var html = this.toHtml();
        var result = this.calculateResult();
        clog('[calculate] result:', result);
        calc._cache.$formulaMinor.html(html);
        // calc._cache.$inputField.text(result);

        // calc.history.add(html, result);
        // Prepare for next calculation
        console.log('next formula:', ''+result);
        calc.formula = new Formula(''+result);
        calc.formula.isCalculated = true;

        // Shhhh... ;)
        if (result === 42) {
            calc._cache.$inputField
                .prepend(
                    '<span class="tile__calc__eg">' +
                    "DON'T PANIC" +
                    '</span>'
                );
        }
    };

    /* Render: HTML */
    // Formula.prototype.fnTpl = function(_arr, _path) {

    // }

    Formula.prototype.toHtml = function(_arr, _path) {
        var arr = _arr || [].concat(this.storage);
        var path = _path || [];
        var type = jQuery.type(arr);
        var compiledStr = '';

        // arr should be an array
        var flatArr = [];
        for (var i = 0; i < arr.length; i++) {
            type = jQuery.type(arr[i]);
            switch (type) {
            case 'array':
                if (
                    arr.length === 1 && jQuery.isArray(arr[0]) &&
                    (typeof FNS[arr[0]] === 'undefined')
                ) {
                    // Parenthesis
                    flatArr[i] = '(' + this.toHtml(arr[i], path.concat([i])) + ')';
                } else {
                    // Normal expressions
                    flatArr[i] = this.toHtml(arr[i], path.concat([i]));
                }
                break;
            default: //case 'string':
                // check Constants handling
                flatArr[i] = /*temp*/ arr[i];
                break;
            }
        }

        // flattened array ready
        // [FN_*, (.+)+]
        var fn = FNS[flatArr[0]];
        if (typeof fn !== 'undefined') {
            // TOREF
            //compiledStr = this.fnTpl(flatArr); //fn.tpl(flatArr[i]);
            compiledStr = fn.tpl.replace(/{{(\d+)}}/g, function($1, i) {
                //clog('FN['+i+']:', flatArr[i], 'empty?:', !(''+flatArr[i]).trim());
                if (typeof flatArr[i] === 'undefined' || !(''+flatArr[i]).trim()) {
                    return '<span class="formula__placeholder">' + String.fromCharCode(+i + 119) + '</span>';
                }
                return flatArr[i];
            });
            return compiledStr;
        }

        //[OP_*]
        for (i = 0; i < flatArr.length; i++) {
            if (typeof OPS[flatArr[i]] !== 'undefined') {
                flatArr[i] = OPS[flatArr[i]].tpl;
            }
        }
        return '<span>'+flatArr.join(' ')+'</span>';
    };

    Formula.prototype.render = function() {
        this.isCalculated = false;
        calc._cache.inputField.innerHTML = this.toHtml();
    };

    Formula.prototype.reset = function() {
        calc._cache.$formulaMinor.html('');
        calc._cache.inputField.innerHTML = '0';
        this.storage = ['0'];
        this.cursor = [0];
        this.render();
    };

    // Calc engine
    var calc = {
        _cache: {},

        settings: {
            keys: {
                // hotkeys to catch with no focus on calc UI
                global: '1234567890^*-+('
                // Keys that conflict with global DDG keyshortcuts:
                //     /
            }
        },

        init: function init(wrapSel) {
            calc.settings.wrapSel = wrapSel;
            calc.cacheDom(wrapSel);
            calc.bindEvents(wrapSel);
        },
        cacheDom: function cacheDom(wrapSel) {
            calc._cache.$ctx = $(wrapSel);
            calc._cache.$inputDisplay = $(wrapSel + ' .tile__display');
            calc._cache.$inputTrap = $(wrapSel + ' .tile__input-trap');
            calc._cache.$inputField = $(wrapSel + ' .tile__display__main');
            calc._cache.$formulaMinor = $(wrapSel + ' .tile__display__aside');
            calc._cache.inputField = calc._cache.$inputField.get(0);
            calc._cache.$skipCalc = $(wrapSel + ' .tile__skip-calc');

            calc._cache.$historyTab = $(wrapSel + ' .tile__history');
            calc._cache.$historyItemTpl = $(wrapSel + ' .tile__past-calc__tpl');
        },

        //////////////
        /// EVENTS ///
        //////////////
        bindEvents: function bindEvents() {
            calc.bindUtilityEvents();
            // Capture related keystrokes from global ctx
            $(document).keypress(calc.handlers.globalKeyEvent);
            // Capture keystrokes from input trap which allows for wider range of keyCodes
            calc.bindTrapKeyEvents();
            // Capture UI clicks
            calc.ui.bindBtnEvents();
            // handle focus via mouse on input field
            calc._cache.$inputDisplay.on('click', calc.ui.focusInput);

            calc.ui.bindTabControls();

            // TODO Handle paste within the calculator UI
            //calc._cache.$ctx.on('paste', calc.handlers.paste);
        },

        /**
         * Bind extra events (Accessibility for calc skipping)
         */
        bindUtilityEvents: function bindUtilityEvents() {
            // Accessibility skip calc UI
            calc._cache.$skipCalc.on('click keydown', function(e){
                e.preventDefault();
                e.stopImmediatePropagation();
                if (e.type === 'keydown' && [K.SPACE, K.ENTER].indexOf(e.which) !== -1) {
                    clog('e [CAUG]:', e);
                    $(window).scrollTo('.content-wrap'); // TORETHINK: too much?
                    $('.content-wrap a, .content-wrap input').get(0).focus(); // TORETHINK: No visual indication
                } else {
                    clog('e:', e);
                }
            });
        },

        /**
         * Bind events for full-input mode using an input trap
         */
        bindTrapKeyEvents: function bindTrapKeyEvents() {
            calc._cache.$inputTrap.keydown(function(e) {
                clog('[inputTrap.keydown] e', e);
                if (e.which === K.BACKSPACE) {
                    if (e.shiftKey) {
                        calc.process.clearFull();
                    } else {
                        calc.process.backspace();
                    }
                    Utils.cancelEvent(e);
                    return false;
                } else {
                    e.stopPropagation();
                }
                e.stopImmediatePropagation();
            });
            calc._cache.$inputTrap.keypress(function(e) {
                clog('[inputTrap.keypress] e', e);
                // process key
                calc.process.key(e.which);
                calc.ui.focusInput();
                Utils.cancelEvent(e);
            });
            calc._cache.$inputTrap.keyup(function(e) {
                clog('[inputTrap.keyup] e', e);
                if (e.which === K.ESC) {
                    e.target.blur();
                }
                Utils.cancelEvent(e);
            });
        },

        ////////
        /// Handlers
        handlers: {
            /**
             * Handles keypresses of specific keys on global context
             * to bring focus to the calculator
             *
             * Doesn't react to:
             * - keypresses that belong to input elements
             * - keys that are not on the whitelist
             * @param  {jQuery.Event} e Keypress event
             */
            globalKeyEvent: function (e) {
                if (
                    e.target && (
                        e.target.tagName === 'INPUT' ||
                        e.target.className.indexOf('tile__ctrl__btn') !== -1
                    )
                ) {
                    // Ignore keys to inputs foreign to the calculator
                    clog('[handlers] ignore due to target:', e);
                    return;
                }
                var chr = String.fromCharCode(e.which || 0);
                if (calc.settings.keys.global.indexOf(chr) !== -1) {
                    clog('[calc.keypress.global] [CAUGHT] globalKey:', e.which, 'char:', chr, 'e:', e);
                    Utils.cancelEvent(e);
                    // process key
                    calc.process.key(e.which);
                    return false;
                } else {
                    clog('[calc.keypress.global] [IGNORED] globalKey:', e.which, 'char:', chr, 'e:', e);
                }
            },

            paste: function(e) {
                // TODO
            }
        },

        /////////
        /// UI
        ui: {
            bindBtnEvents: function() {
                $('.tile__tabs .tile__ctrl__btn', calc._cache.$ctx)
                    .on('click keypress', function(e){
                        if (e.type === 'keypress' && e.which === K.BACKSPACE) {
                            calc.process.backspace();
                            return;
                        }

                        if (
                            e.type === 'keypress' &&
                            [K.ENTER, K.SPACE].indexOf(e.which) !== -1
                        ) {
                            // TODO maybe needs prevent default etc.
                            // TODO [accessibility] Decide on Enter & Space roles when use while focused on btns
                            return;
                        }

                        var $this = $(this);
                        var cmd = $this.data('cmd');
                        if (cmd === 'NO') return;

                        if (typeof cmd === 'undefined') {
                            calc.process.chr(this.textContent);
                        } else {
                            calc.process.cmd(cmd);
                        }

                        if (e.type === 'click') {
                            clog('[AMPER] btn.click:', e);
                            calc.ui.focusInput();
                        }
                    });
            },
            bindTabControls: function() {
                // TODO: Perf refactor
                $('.tile__options .tile__option span').click(function(e) {
                    var $tabHandle = $(this).parent();
                    if ($tabHandle.hasClass('tile__option--active')) {
                        return;
                    }
                    $('.tile__options .tile__option')
                        .removeClass('tile__option--active');
                    $tabHandle.toggleClass('tile__option--active');

                    var activeTab = $('.tile__options .tile__option.tile__option--active')
                                        .data('tab');
                    $('.tile__tabs')
                        .removeClass(function (index, css) {
                            return (css.match(/(^|\s)tile__tabs--single-[a-z]+/g) || []).join(' ');
                        })
                        .addClass('tile__tabs--single-'+activeTab);
                });
            },
            focusInput: function () {
                clog('FOCUS on inputTrap');
                calc._cache.$inputTrap.focus();
            },
            blurInput: function () {
                calc._cache.$inputTrap.blur();
            }
        },


        /**
         * @type {Formula}
         */
        formula: new Formula(),

        /**
         * History manager
         * @type {Object}
         */
        history: {
            add: function(formula, result) {
                var $newCalc = calc._cache.$historyItemTpl.clone();
                $newCalc.removeClass('hide tile__past-calc__tpl');
                $newCalc.find('.tile__past-formula').html(formula);
                $newCalc.find('.tile__past-result').html(result);
                calc._cache.$historyTab.prepend($newCalc);
                setTimeout(function() {
                    $newCalc.removeClass('tile__past-calc--hidden');
                }, 20);
            },
            remove: function(formulaId) {
                // TODO
            },
            replay: function(formulaId) {
                // TODO
            }
        },

        /**
         * Normalize input flows
         * @type {Object}
         */
        process: {
            // Higher level

            // Called by search query init
            calculation: function (formulaStr) {
                // sanitize
                // decimal dots?
                for (var i = 0; i < formulaStr.length; i++) {
                    calc.process.chr(formulaStr[i]);
                }
            },
            cmd: function(cmd) {
                var type = cmd.split('_', 1)[0];
                if (type === 'META') {
                    switch(cmd) {
                    case 'META_CLEAR':
                        // TODO: If holds Shift, force full calc/formula clearing
                        calc.process.backspace();
                        return;
                    case 'META_PROCEED':
                        calc.formula.calculate();
                        return;
                    case 'META_PAR_OPEN':
                        calc.formula.levelUp();
                        return;
                    case 'META_PAR_CLOSE':
                        calc.formula.levelDown();
                        return;
                    default:
                        clog('[calc.process.cmd] TODO Unhandled META:', cmd);
                    }
                }
                // if (typeof KEY_ALIASES[chr] !== 'undefined') {
                //     calc.process.cmd(KEY_ALIASES[chr]);
                //     return;
                // }
                calc.formula.handleCmd(type, cmd);
                // calc.formula.handleChr(cmd);
            },
            // cmd: function(cmd) {
            //     var type = cmd.split('_', 1)[0];

            //     if (type === 'META') {
            //         switch(cmd) {
            //         case 'META_CLEAR':
            //             // TODO: If holds Shift, force full calc/formula clearing
            //             calc.process.backspace();
            //             return;
            //         case 'META_PROCEED':
            //             calc.formula.calculate();
            //             return;
            //         case 'META_PAR_OPEN':
            //             calc.formula.levelUp();
            //             return;
            //         case 'META_PAR_CLOSE':
            //             calc.formula.levelDown();
            //             return;
            //         default:
            //             clog('[calc.process.cmd] TODO Unhandled META:', cmd);
            //         }
            //     }

            //     calc.formula.handleCmd(type, cmd);
            // },

            // Low level
            key: function (key) {
                calc.ui.focusInput();
                switch (key) {
                case K.ENTER:
                    return calc.process.cmd('META_PROCEED');
                case K.BACKSPACE:
                    return calc.process.cmd('META_CLEAR');
                }
                var chr = String.fromCharCode(key || 0);
                calc.process.chr(chr, key);
            },
            chr: function (chr) {
                if (typeof KEY_ALIASES[chr] !== 'undefined') {
                    calc.process.cmd(KEY_ALIASES[chr]);
                    return;
                }
                calc.formula.handleChr(chr);
            },
            backspace: function () {
                calc.formula.handleBackspace();
            },
            clearFull: function () {
                calc.formula.reset();
            }
        }
    };
    var updateGUI = function() {
        var query = $("#tile__past-formula").val();
        $.getJSON("https://crossorigin.me/" + "https://api.duckduckgo.com/?format=json&q=" + query, function(data) {
            var answerComponents = data.Answer.match(/^([0-9\.,]+) ([a-zA-Z].*)$/);
            var answerValue = answerComponents[1].replace(/,/g,"");

            $("#tile__past-calc").val(answerValue);
        })
    };

    return {
        onShow: function() {
            var isInited = $('#zci-calculator').data('is-inited');
            // clog('[calc] onShow. inited:', isInited);
            if (!isInited) {
                $('#zci-calculator').data('is-inited', true);
                calc.init('#zci-calculator');
                // calc.process.calculation(DDG.get_query());
                // $('#tile__past-calc').change(function() {
                //     updateGUI();
                // });
                calc.process.calculation(DDG.get_query());
            };
        }
    };
};

Handlebars.registerHelper('iterate', function(context, options) {
    out = "";
    if (options.data) {
        data = Handlebars.createFrame(options.data);
    }
    var times = context;
    var start = options.hash['start'] || 0;
    var step = options.hash['step'] || 1;
    var end = options.hash['end'] || start + step * (times - 1);
    // var end = options.hash['end'];
    for (var i=start; i<=end; i+=step) {
        if (data) {
            data.this = i;
        }
        out += options.fn(data.this);
    }
    return out;
});

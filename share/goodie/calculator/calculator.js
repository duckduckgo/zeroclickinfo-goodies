// jshint jquery: true, browser: true, devel: true
//
DDH.calculator = DDH.calculator || {};

/* global DDG, Goodie, isNumber */
DDH.calculator.build = function() {
    function clog() {
        if (console && !(console === undefined)) {
            var args = Array.prototype.slice.apply(arguments);
            args.unshift('%c[ia:calculator]', 'font-weight:bold');
            console.log.apply(console, args);
        }
    }
    function cwarn() {
        if (console && !(console === undefined)) {
            var args = Array.prototype.slice.apply(arguments);
            args.unshift('%c[ia:calculator]', 'font-weight:bold');
            console.warn.apply(console, args);
        }
    }
    function cerror() {
        if (console && !(console === undefined)) {
            var args = Array.prototype.slice.apply(arguments);
            args.unshift('%c[ia:calculator]', 'font-weight:bold');
            console.cerror.apply(console, args);
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

    // Traversable fields for the display.
    function CalcField(options) {
        this.rep = options.rep;
        this.numFields = options.numFields || 0;
        // this.fields = options.startFields || [];
        this.fields = options.startFields || 'undef'.repeat(this.numFields);
        this.actionType = options.actionType || 'NONE';
        this.name = options.name || this.rep;
    }

    CalcField.prototype.asText = function() {
        if (typeof this.rep === 'string') {
          return this.rep;
        }
        if (typeof this.rep === Function) {
          return this.rep();
        }
        console.warn('[CF.asText] did not generate any text!');
    };

    // Get the very last field (maybe of children).
    CalcField.prototype.recurseLastField = function () {
        if (this.numFields === 0) {
            return this;
        }
        return this.fields[this.numFields - 1].recurseLastField();
    };

    // Get the position of the very deepest, last field.
    CalcField.prototype.recursePosLast = function () {
        if (this.numFields === 0) {
            return [];
        }
        return [this.numFields - 1].concat(this.fields[this.numFields - 1].recurseLastField());
        // return this.fields[this.numFields - 1].recurseLastField();
    };

    // Retrieve the Field accessed through pos.
    CalcField.prototype.accessField = function(pos) {
        console.log('[accessField] Accessing field at pos: ' + pos);
        var thisFieldToAccess = pos[0];
        if (thisFieldToAccess >= this.fields.length) {
            console.warn("[accessField] Attempt to access a field not yet defined! (" + thisFieldToAccess + ')');
            return;
        }
        if (thisFieldToAccess >= this.numFields) {
            console.warn("[CalcField.accessField] field access is greater than num fields!: " + this.numFields + ", " + thisFieldToAccess);
        } else {
            if (pos.length === 0) {
                return this;
            }
            var restToAccess = pos.slice(1);
            clog("[accessField] Rest: " + restToAccess);
            clog("[accessField] thisFieldToAccess: " + thisFieldToAccess);
            return this.fields[thisFieldToAccess].accessField(restToAccess);
        }
    };

    CalcField.prototype.setField = function(pos, val) {
      console.log('[CF.setField] setting field: ' + pos + ' to ' + val);
      var thisFieldToAccess = pos[0];
      if (thisFieldToAccess >= this.numFields) {
          console.warn("[CF.setField] field access is greater than num fields!: " + this.numFields + ", " + thisFieldToAccess);
      } else {
          if (pos.length === 1) {
            this.fields[pos[0]] = val;
          }
          var newPos = pos.slice(1);
          clog("[C.setField] Rest: " + newPos);
          return this.fields[thisFieldToAccess].setField(newPos, val);
      }
    };

    // True if the Field requires more arguments.
    CalcField.prototype.needsField = function() {
        return (this.numFields !== this.fields.length);
    };

    // // Position of next field that needs to be filled (within this Field).
    // CalcField.posThisFieldNeedsFilling() {
    // };

    CalcField.prototype.getPosEarliestFieldNeedsFilling = function(pos) {
        console.log('[CF.earliest needs] pos: ' + pos);
        pos = pos || [];
        var i;
        var currentEarly;
        for (i=0; i<this.fields.length; i++) {
            currentEarly = this.fields[i].getPosEarliestFieldNeedsFilling(pos.concat([i]));
            // if (this.fields[i].getPosEarliestFieldNeedsFilling(pos + [i]))
            if (!(currentEarly === undefined)) {
                return currentEarly;
            }
        }
        if (this.needsField) {
            return pos.concat([this.numFields - 1 - this.fields.length]);
            // pos.push((this.numFields - 1) - this.fields.length);
        }
        // return pos;
    };
    CalcField.prototype.getPosLatestFieldNeedsFilling = function(pos) {
        console.log('[CF.latest needs] pos: ' + pos);
        pos = pos || [];
        var i;
        var currentLate;
        for (i=this.numFields-1; i>0; i--) {
            currentLate = this.fields[i];
            if (currentLate.actionType === 'PLACE_HOLDER') {
                console.log('[CF.latest needs] got place holder, returning: ' + pos.concat([i]));
                return pos.concat([i]);
            }
            lateChild = currentLate.getPosLatestFieldNeedsFilling(pos.concat([i]));
            if (!(lateChild === undefined)) {
                console.log('[CF.latest needs] lateChild pos: ' + lateChild);
                return lateChild;
            }
        }
        return;
        // if (this.needsField) {
        //     return pos.concat([this.numFields - 1 - this.fields.length]);
        //     // pos.push((this.numFields - 1) - this.fields.length);
        // }
        // for (i=0; i<this.fields.length; i++) {
        //     currentEarly = this.fields[i].getPosEarliestFieldNeedsFilling(pos.concat([i]));
        //     // if (this.fields[i].getPosEarliestFieldNeedsFilling(pos + [i]))
        //     if (!(currentEarly === undefined)) {
        //         return currentEarly;
        //     }
        // }
        // return pos;
    };

    function CalcNonDisplay(options) {
        this.actionType = options.actionType;
        this.runAction = options.runAction;
    }


    function CalcFieldChar(n) {
        return new CalcField({
            numFields: 0,
            actionType: 'CHAR',
            rep: n
        });
    }

    function FieldCollector(options) {
        this.actionType = 'COLLECT';
        this.allow = options.allow;
        this.fields = [];
        this.rep = function() {
            this.fields.join();
        };
    }

    function calcFieldOperator(symbol) {
        return new CalcField({
            rep: ' ' + symbol + ' ',
            numFields: 0
        });
    }

    function maker(what) {
        new what();
    }

    function calcMeta(action) {
        return new CalcNonDisplay({
            actionType: 'META',
            runAction: action
        });
    }


    // Buttons
    var BTS = {
        'OP_DIV': calcFieldOperator('÷'),
        'OP_MULT': calcFieldOperator('×'),
        'OP_PLUS': calcFieldOperator('+'),
        'OP_MINUS': calcFieldOperator('-'),
        'CONST_PI': CalcFieldChar('π'),
        '0': CalcFieldChar('0'),
        '1': CalcFieldChar('1'),
        '2': CalcFieldChar('2'),
        '3': CalcFieldChar('3'),
        '4': CalcFieldChar('4'),
        '5': CalcFieldChar('5'),
        '6': CalcFieldChar('6'),
        '7': CalcFieldChar('7'),
        '8': CalcFieldChar('8'),
        '9': CalcFieldChar('9'),
        ' ': CalcFieldChar(' '),
        'META_CLEAR': calcMeta(function () { calc.process.backspace(); }),
        'META_PROCEED': calcMeta(function () { calc.formula.calculate(); }),
        'META_PAR_OPEN': calcMeta(function () { calc.formula.levelUp(); }),
        'META_PAR_CLOSE': calcMeta(function () { calc.formula.levelDown(); }),
        'PLACE_HOLDER': new CalcNonDisplay({
            actionType: 'PLACE_HOLDER',
            runAction: function() { log.error('Place holder called!'); }
        }),
        'COLLECTOR': new FieldCollector({
            allow: function(toTest) {
                return (toTest.actionType === 'CHAR');
            }
        })
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
            // calc: MathHelper.factorial
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
        // this.storage = [''];
        this.storage = [BTS['0']];
        this._cursor = [0];
        this.isCalculated = false;
        this.initialDisplay = true;

        if (!(initialFormStr === undefined)) {
            console.log('[Formula] initial is defined!');
            this.handleString(''+initialFormStr);
        } else {
            this.handleString('0');
        }
    }

    Formula.prototype = {
        get cursor() {
            return [].concat(this._cursor);
        }
    };

    ////////////////////
    /// Virtual cursor
    ////////////////////

    /**
     * Move cursor to specific position
     * @param  {Array} pos Field position
     */
    Formula.prototype.moveCursorTo = function(pos) {
        clog('[F.moveCursorTo] type of pos: ' + typeof pos);
        clog('[F.moveCursorTo] pos:', pos.join(', '));
        console.log('[F.moveCursorTo] initial position: ' + this.cursor);
        this._cursor = pos;
        console.log('[F.moveCursorTo] new position: ' + this.cursor);
    };

    /**
     * Move cursor a level lower
     * e.g: When closing a parathensis
     */
    Formula.prototype.levelDown = function() {
        if (this._cursor.length > 1) {
            this._cursor.pop();
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
        console.log("[F.getField] getting field at position: " + pos);
        var ctx = this.storage;
        // var maxDepth = pos.length;
        // top level entry - after this will be recursing into forms.
        var topLevel = ctx[pos[0]];
        return topLevel.accessField(pos.slice(1));
        // ctx = ctx[pos[0]];
        // if (pos.length > 1) {
        //     var toRecurse = pos.slice(1);
        //     ctx = ctx.accessField(toRecurse);
        // }
        // // for (var i = 0; i < toRecurse.length; i++) {
        // //     ctx = ctx.fields[pos[i]];
        // //     // ctx = ctx[pos[i]];
        // // }
        // return (ctx === undefined ? '' : (
        //     (jQuery.isArray(ctx) ? ctx  : '' + ctx)
        // ));
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
        // return [0];
        // var pos = this.cursor;
        // pos[-1]++;
        // return pos;
        // return [2];
        console.log('[F.nextFragmentPos] cursor: ' + this.cursor);
        var pos = this.cursor;
        console.log('[F.nextFragmentPos] pos(before): ' + pos);
        pos[0]++;
        console.log('[F.nextFragmentPos] cursor: ' + this.cursor);
        console.log('[F.nextFragmentPos] pos(after): ' + pos);
        return pos;
        // return this.cursor;
        // var pos = [].concat(this.cursor);
        // pos[pos.length - 1]++;
        // return pos;
    };


    /**
     * Traverse storage from right to left and upwards until it encounters:
     * - a number (not constant)
     * - the most left empty field
     * @param  {Array?} posCtx
     * @return {Array}          Position index
     */
    Formula.prototype.nextFieldToFillPos = function(posCtx) {
        console.log('[F.nextFieldToFillPos] posCtx: ' + posCtx);
        if (posCtx === undefined) {
            posCtx = this.cursor;
            // posCtx = [];
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
        console.log('[F.nextFieldToFillPos] lastFragment: ' + lastFragment);
        if (lastFragment instanceof CalcField) {
            var lastFieldPos = posCtx.concat(lastFragment.recursePosLast());
            // var lastField = lastFragment.recurseLastField();
            // var lastField = lastFragment.accessField([lastFieldIndex]);
            // console.log('[F.nextFieldToFillPos] lastField: ' + lastField);
            // var lastField = lastFragment[lastFieldIndex];
            // if (jQuery.isArray(lastField)) {
            // if (typeof(lastField) === 'CalcField') {
            console.log('[F.nextFieldToFillPos] lastFieldPos: ' + lastFieldPos);
            return lastFieldPos;
            // return posCtx.concat(lastFragment.recursePosLast());
            // return posCtx.concat(lastFragment.recursePosLast());
            // return lastField;
            // if (lastField.instanceOf(CalcField)) {
            //     return this.nextFieldToFillPos(
            //         posCtx.concat([lastFieldIndex])
            //     );
            // }
            // if (lastField === '') {
            //     while (lastFieldIndex > 0) {
            //         if (lastFragment[lastFieldIndex - 1] === '') {
            //             lastFieldIndex--;
            //         }
            //     }
            //     if (lastFieldIndex > 0) {
            //         if (isNumber(lastFragment[lastFieldIndex - 1])) {
            //             lastFieldIndex--;
            //         }
            //     }
            //     return posCtx.concat([lastFieldIndex]);
            // }
            // if (!FNS.indexOf(lastFragment[0])) {
            //     console.log('[F.nextFieldToFillPos] withinFnArr lastFragment:', lastFragment);
            //     // TODO: Depends on cursor having pressed closing parenthesis
            //     //posCtx
            // }
        } else {
            // NESTED?
            console.warn('[F.nextFieldToFillPos] lastFragment: none array:', lastFragment);
        }
        // if (jQuery.isArray(lastFragment)) {
        //     var lastFieldIndex = lastFragment.length - 1;
        //     var lastField = lastFragment[lastFieldIndex];
        //     // if (jQuery.isArray(lastField)) {
        //     // if (typeof(lastField) === 'CalcField') {
        //     if (lastField.instanceOf(CalcField)) {
        //         return this.nextFieldToFillPos(
        //             posCtx.concat([lastFieldIndex])
        //         );
        //     }
        //     if (lastField === '') {
        //         while (lastFieldIndex > 0) {
        //             if (lastFragment[lastFieldIndex - 1] === '') {
        //                 lastFieldIndex--;
        //             }
        //         }
        //         if (lastFieldIndex > 0) {
        //             if (isNumber(lastFragment[lastFieldIndex - 1])) {
        //                 lastFieldIndex--;
        //             }
        //         }
        //         return posCtx.concat([lastFieldIndex]);
        //     }
        //     if (!FNS.indexOf(lastFragment[0])) {
        //         console.log('[F.nextFieldToFillPos] withinFnArr lastFragment:', lastFragment);
        //         // TODO: Depends on cursor having pressed closing parenthesis
        //         //posCtx
        //     }
        // } else {
        //     // NESTED?
        //     console.warn('[F.nextFieldToFillPos] lastFragment: none array:', lastFragment);
        // }
    };

    // TODO: Better name
    Formula.prototype.getPreviousFieldPosWhole = function(ctx, pos) {
        if (ctx === undefined) {
            ctx = this.storage;
            pos = [];
        }

        var ctxIndex = Math.max(0, ctx.length - 1, 0);
        var prevFieldToFill = ctx[ctxIndex];
        pos.push(ctxIndex);

        // if (jQuery.isArray(prevFieldToFill)) {
        // if (typeof(prevFieldToFill) === 'CalcField') {
        if (prevFieldToFill.instanceOf(CalcField)) {
            return this.getPreviousFieldPosWhole(prevFieldToFill, pos);
        }
        return pos;
    };

    Formula.prototype.hasPreviousField = function() {
        return (this.cursor[this.cursor.length - 1] > 0);
    };

    Formula.prototype.getPreviousFieldPos = function() {
        var prevCursor = [].concat(this.cursor);
        if (prevCursor[prevCursor.length - 1] > 0) {
            prevCursor[prevCursor.length - 1] -= 1;
            return prevCursor;
        }
        return false;
    };

    Formula.prototype.getPreviousFieldInFragment = function() {
        var prevCursor = this.getPreviousFieldPos();
        if (prevCursor !== false) {
            return this.getField(prevCursor);
        }
        return false;
    };

    Formula.prototype.canReplaceField = function(val, toBeReplacedByType) {
        console.log('[F.canReplaceField] checking for val ' + val + ' with replacement ' + toBeReplacedByType);
        return true;
        // if (jQuery.isArray(val)) {
        //     return false; // addNew
        // }
        // if (isNumber(val) || !val.indexOf('CONST_')) {
        //     return true; // useField
        // }
        // // } else { // OP, FN
        // return false;
    };

    Formula.prototype.getLastReplaceableFieldPos = function(toBeReplacedByType) {
        console.log('[getLastReplaceableFieldPos] replacement type: ' + toBeReplacedByType);
        console.log('[F.getLastReplaceableFieldPos] initial cursor: ' + this.cursor);
        var lastField = this.getField(this.cursor);
        if (lastField !== '') {
            return (
                this.canReplaceField(lastField, toBeReplacedByType) ?
                this.cursor :
                false
            );
        }
        var prevCursor = this.getPreviousFieldPos();
        if (prevCursor !== false) {
            var prevFieldVal = this.getField(prevCursor);
            return (
                this.canReplaceField(prevFieldVal, toBeReplacedByType) ?
                prevCursor :
                false
            );
        }
        console.log('[F.getLastReplaceableFieldPos] final cursor: ' + this.cursor);
        return this.cursor;
    };

    /**
     * fieldName: {
     *     fields: [],
     *     rep: function () { bleh! }
     * }


    /**
     * Get the first field of a fragment
     * @param  {Array?} pos Fragment's position on storage array
     *                      - by default cursor's position
     */
    Formula.prototype.getStartingFieldInFragment = function(pos) {
        if (pos === undefined) {
            pos = [].concat(this.cursor);
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

    // Predicate: is the cursor at the top level?
    Formula.prototype.atTopLevel = function() {
        return atTopLevel(this.cursor);
    };

    // Move the cursor forward by amount (default 1)
    Formula.prototype.moveCursorForward = function(amount) {
        amount = amount || 1;
        console.log('[F.moveCursorForward] moving cursor forward by: ' + amount);
        this._cursor[this.cursor.length - 1] += amount;
        return this.cursor;
    };

    // Move the cursor backwards by amount (default 1)
    Formula.prototype.moveCursorBackward = function(amount) {
        amount = amount || 1;
        console.log('[F.moveCursorBackward] moving cursor backwards by: ' + amount);
        this._cursor[this.cursor.length - 1] -= amount;
        return this.cursor;
    };


    // Get the field at pos (default cursor)
    Formula.prototype.currentField = function(pos) {
        pos = pos || this.cursor;
        if (atTopLevel(pos)) {
            return this.storage[pos[0]];
        }
        return this.storage[pos[0]].getField(pos.slice(1));
    };

    // Is the given position at the top level?
    function atTopLevel(pos) {
        return (pos.length === 1);
    }

    // Modify the field at 'pos' (default cursor) to value.
    Formula.prototype.modifyField = function(value, pos) {
        pos = pos || this.cursor;
        if (atTopLevel(pos)) {
            this.storage[pos[0]] = value;
            return;
        }
        var topLevel = this.storage[pos[0]];
        topLevel.setField(pos.slice(1), value);
    };
    // Append a new fragment with value 'val' after the cursor.
    Formula.prototype.appendFragmentChild = function(val) {
        var pos = this.moveCursorForward();
        this.modifyField(val, pos);
    };
    /**
     * Add new fragment to formula storage
     * @param  {Mixed}  val Value of new fragment could be String or Array
     * @param  {Array?} pos Target position on storage array - by default move to next fragment
     */
    Formula.prototype.fragmentNew = function(val) {
        console.log('[F.fragmentNew] new fragment value: ' + val);
        if (this.initialDisplay) {
            this.modifyField(val);
            this.initialDisplay = false;
        } else {
            this.appendFragmentChild(val);
        }
    };

    /**
     * Replace existing fragment of the formula storage
     * @param  {Mixed}  val  Value to put on the fragment
     * @param  {Array?} pos  Target position on storage array
     *                       - by default the cursor fragment
     */
    Formula.prototype.fragmentReplace = function(str, pos) {
        console.log('[F.fragmentReplace] replacing fragment at ' + pos + ' with ' + str);
        if (pos === undefined) {
            pos = [].concat(this.cursor);
        }
        console.log('[F.fragmentReplace] replacing fragment at ' + pos + ' with ' + str);

        if (pos.length === 1) {
            this.storage[pos[0]] = str;
            this.moveCursorTo(pos);
            return;
        }
        this.storage[pos[0]].setField(pos.slice(1), str);

        this.moveCursorTo(pos);
    };

    /**
     * Remove fragment from the formula storage
     * @param  {Array?} pos  Target position on storage array
     *                       - by default the cursor fragment
     */
    Formula.prototype.fragmentRemove = function(pos) {
        console.log('[F.fragmentRemove] pos: ' + pos);
        if (pos === undefined) {
            pos = [].concat(this.cursor);
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
        console.warn('[F.handleString] str: ' + str);
        var _str = '' + str;
        for (var i = 0; i < _str.length; ++i) {
            // this.handleChr(_str[i], true);
            this.handleChr(BTS[_str[i]], true);
        }
    };

    Formula.prototype.handleChr = function(chr, skipRender) {
        // console.log('[F.handleChr] handling character: ' + chr);
        if (chr === undefined) {
            console.warn('[F.handleChr] got an undefined character!');
            return;
        }
        this.fragmentNew(chr);
        // var curField = this.getActiveField();
        // if (chr === ' ') {
        //     // TODO
        //     // 1. if in FN go to next field of FN
        // } else if (isNumber(curField + chr)) {
        //     if (curField === '0' && chr !== '.') {
        //         curField = '';
        //     }
        //     this.fragmentReplace((curField + chr).trim());
        // } else if (isNumber(chr)) {
        //     this.fragmentNew(chr);
        // } else {
        //     // TODO
        //     // this.fragmentNew(chr);
        // }

        console.log('[F.handleChr] new storage: ' + this.storage);
        // clog('[pushChr]('+chr+') storage:', this.storage);
        if (!skipRender) {
            this.render();
        }
    };

    Formula.prototype.handleCmd = function(cmd, skipRender) {
        console.log('[F.handleCmd] handling cmd: ' + cmd);
        var lastFieldPos = this.getLastReplaceableFieldPos();
        console.log('[F.handleCmd] lastFieldPos: ' + lastFieldPos);
        var lastField = (lastFieldPos !== false ? this.getField(lastFieldPos) : false);
        console.log('[F.handleCmd] lastField: ' + lastField);
        var type = cmd.actionType;
        clog('[F.handleCmd] type:', type, 'cmd:', cmd, 'lastField:', lastField);
        this.fragmentNew(cmd);
        // if (type === 'OP' && typeof OPS[cmd] !== 'undefined') {
        //     // this.fragmentNew(cmd);
        //     console.log("Rep: " + OPS[cmd].rep);
        //     this.fragmentNew(OPS[cmd].rep);
        // } else if (type === 'FN' && typeof FNS[cmd] !== 'undefined') {
        //     // var newFragValue = [cmd].concat(Array(FNS[cmd].fields).join('.').split('.'));
        //     // var newFragValue = [cmd.rep].concat(Array(FNS[cmd].fields).join('.').split('.'));
        //     console.log("Fields: " + FNS[cmd].fields);
        //     var newFragValue = [cmd].concat(Array(FNS[cmd].fields).join('.').split('.'));
        //     // var newFragValue = FNS[cmd].rep(Array(FNS[cmd].fields));
        //     if (lastField !== false && (
        //         !lastField.indexOf('CONST_') || isNumber(lastField)
        //     )) {
        //         newFragValue[1] = lastField;
        //         this.fragmentRemove();
        //         this.fragmentNew(newFragValue);
        //         //TODO Move cursor to nextToFillPos this.
        //     } else {
        //         this.fragmentNew(newFragValue);
        //     }
        // }

        if (!skipRender) {
            this.render();
        }
    };

    // Cursor is at start.
    Formula.prototype.atStart = function() {
        return (this.atTopLevel && (this.cursor[0] === 0));
    };

    Formula.prototype.deleteBackwards = function() {
        var pos = this.cursor;
        var deleted;
        if (this.atTopLevel) {
            if (this.atStart()) {
                console.log('[F.deleteBackwards] at start for pos: ' + pos);
                deleted = this.currentField();
                this.modifyField(BTS['0']);
                this.initialDisplay = true;
                return deleted;
            }
            console.log('[F.deleteBackwards] storage (before): ' + this.storage);
            deleted = this.storage.pop();
            console.log('[F.deleteBackwards] storage (after): ' + this.storage);
            this.moveCursorBackward();
            return deleted;
        }
        console.warn('[F.deleteBackwards] not at top level for pos ' + pos);
    };
    /**
     * Backspace logic
     *    *** UNDER CONSTRUCTION ***
     */
    Formula.prototype.handleBackspace = function() {
        if (this.isCalculated) {
            console.log('[F.handleBackspace] was calculated, resetting');
            this.reset();
            return;
        }

        this.deleteBackwards();
        this.render();
    };

    ////////////////////
    /// Calculations ///

    /**
     * Calculate operations of a fragment (OPS)
     * @param  {Array} _frag  Subset of Formula.storage
     * @return {Number}       Computed result of the fragment
     */
    // Formula.prototype.calculateOperations = function(_frag) {
    //     clog('[calculateOperations]:', _frag);
    //     var frag = [].concat(_frag);
    //     jQuery.each(OPS, function(opName) {
    //         var opPosition = frag.indexOf(opName);
    //         while (opPosition !== -1) {
    //             clog('FOUND OP:', opPosition, opName, 'opFrag:', frag[opPosition]);
    //             var opCalc = OPS[frag[opPosition]].calc;
    //             var args = [frag[opPosition - 1]];
    //             if (opCalc.length === 2) {
    //                 args.push(frag[opPosition + 1]);
    //             }
    //             frag[opPosition - 1] = opCalc.apply(null, args);

    //             // remove calc'd arguments
    //             frag.splice(opPosition, opCalc.length);
    //             opPosition = frag.indexOf(opName);
    //         }
    //     });
    //     if (frag.length > 1) {
    //         clog('[F.calculateOperations] INVESTIGATE:', frag);
    //         return frag;
    //     }
    //     return frag[0];
    // };

    // Formula.prototype.calculateFragment = function(frag) {
    //     clog('[calculateFragment]', frag);
    //     if (jQuery.isArray(frag)) {
    //         if (typeof FNS[frag[0]] !== 'undefined') {
    //             for (var i = 1; i < frag.length; i++) {
    //                 frag[i] = this.calculateFragment(frag[i]);
    //             }
    //             clog('FNS:',frag[0]);
    //             return FNS[frag[0]].calc.apply(this, frag.slice(1));
    //         } else { // Parenthesis
    //             return this.calculateOperations(frag);
    //         }
    //     } else if (isNumber(frag)) {
    //         return +frag;
    //     //} else if () { // TODO CONSTS++
    //     } else {

    //     }
    // };

    Formula.prototype.toText = function() {
        var i;
        var textArr = [];
        for (i=0; i<this.storage.length; i++) {
            textArr[i] = this.storage[i].asText();
        }
        return textArr.join('');
    };

    Formula.prototype.calculateResult = function(_arr, _path) {
        // var query = $("#tile__past-formula").val();
        console.log("Rep: " + calc._cache.$inputField.value);
        console.log("Storage: " + this.storage);
        console.log("Storage[0]: " + this.storage[0]);
        // var query = this.storage.join('');
        var query = this.toText();
        console.log("Query: " + query);
        // Use the below link in production
        // $.getJSON("https://crossorigin.me/" + "https://beta.duckduckgo.com/?format=json&q=" + encodeURIComponent(query), function(data) {
        $.getJSON("http://localhost:5000/?format=json&q=" + encodeURIComponent(query), function(data) {
            var answerValue = data.Answer.data.text_result;
            var formattedInput = data.Answer.data.parsed_input;
            calc._cache.$inputField.text(answerValue);
            calc.history.add(formattedInput, answerValue);
            answer = answerValue;
            return answerValue;
        });
    };

    Formula.prototype.calculate = function() {
        this.isCalculated = true;
        var html = this.toHtml();
        this.calculateResult();
        var result = $("#zci__calculator-display-main").text();
        clog('[calculate] result: ' + result);
        calc._cache.$formulaMinor.html(html);
        // calc._cache.$inputField.text(result);

        // calc.history.add(html, result);
        // Prepare for next calculation
        console.log('next formula:', ''+result);
        calc.formula.reset();

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
        console.log('[F.toHtml] with _arr ' + _arr + ' and _path ' + _path);
        // var arr = _arr || [].concat(this.storage);
        var arr = _arr || this.storage;
        // var path = _path || [];
        // var type = jQuery.type(arr);
        // var compiledStr = '';

        // arr should be an array
        var i;
        var flatArr = [];
        console.log("[F.toHtml] arr: " + arr);
        for (i=0; i<arr.length; i++) {
            // console.log('[F.toHtml] current element: ' + arr[i]);
            // console.log('[F.toHtml] typeof current element: ' + typeof(arr[i]));
            // console.log('[F.toHtml] current element.asText: ' + arr[i].asText());
            flatArr[i] = arr[i].asText();
        }
        // var flatArr = [];
        // for (var i = 0; i < arr.length; i++) {
        //     type = jQuery.type(arr[i]);
        //     switch (type) {
        //     case 'array':
        //         if (
        //             arr.length === 1 && jQuery.isArray(arr[0]) &&
        //             (typeof FNS[arr[0]] === 'undefined')
        //         ) {
        //             // Parenthesis
        //             flatArr[i] = '(' + this.toHtml(arr[i], path.concat([i])) + ')';
        //         } else {
        //             // Normal expressions
        //             flatArr[i] = this.toHtml(arr[i], path.concat([i]));
        //         }
        //         break;
        //     default: //case 'string':
        //         // check Constants handling
        //         flatArr[i] = /*temp*/ arr[i];
        //         break;
        //     }
        // }

        // flattened array ready
        // [FN_*, (.+)+]
        // var fn = FNS[flatArr[0]];
        // if (typeof fn !== 'undefined') {
        //     // TOREF
        //     //compiledStr = this.fnTpl(flatArr); //fn.tpl(flatArr[i]);
        //     compiledStr = fn.tpl.replace(/{{(\d+)}}/g, function($1, i) {
        //         //clog('FN['+i+']:', flatArr[i], 'empty?:', !(''+flatArr[i]).trim());
        //         if (typeof flatArr[i] === 'undefined' || !(''+flatArr[i]).trim()) {
        //             return '<span class="formula__placeholder">' + String.fromCharCode(+i + 119) + '</span>';
        //         }
        //         return flatArr[i];
        //     });
        //     return compiledStr;
        // }

        //[OP_*]
        // for (i = 0; i < flatArr.length; i++) {
        //     if (!(OPS[flatArr[i]] === undefined)) {
        //         flatArr[i] = OPS[flatArr[i]].tpl;
        //     }
        // }
        console.log('[F.toHtml] flatArr: ' + flatArr);
        return '<span>'+flatArr.join('')+'</span>';
    };

    Formula.prototype.render = function() {
        console.log('[F.render] rendering!');
        this.isCalculated = false;
        calc._cache.inputField.innerHTML = this.toHtml();
    };

    Formula.prototype.reset = function() {
        console.log('[F.reset] reset!');
        calc._cache.$formulaMinor.html('');
        calc._cache.inputField.innerHTML = '0';
        // this.storage = ['0'];
        this.storage = [BTS['0']];
        this._cursor = [0];
        this.initialDisplay = true;
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
            console.log('[cacheDom.cacheDom] got wrapSel: ' + wrapSel);
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
                    .on('click keypress', function(e) {
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

                        if (cmd === undefined) {
                            clog("[bindBtnEvents] got undefined command");
                            // calc.process.chr(this.textContent);
                            calc.process.chr(this.textContent);
                        } else {
                            // calc.process.cmd(cmd);
                            clog('[bindBtnEvents] processing command: ' + cmd);
                            calc.process.cmd(BTS[cmd]);
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
                // Clicking the history adds the result to the input.
                $('.tile__past-calc').on('click', function(event) {
                    event.stopImmediatePropagation();
                    var val = $(this).find('.tile__past-result').val();
                    calc.process.calculation(val);
                });
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
                clog("[calc.process.calculation] got formulaStr: " + formulaStr);
                // sanitize
                // decimal dots?
                for (var i = 0; i < formulaStr.length; i++) {
                    calc.process.chr(formulaStr[i]);
                }
            },
            cmd: function(cmd) {
                if (cmd === undefined) {
                    console.warn('[calc.process.cmd] got undefined command!');
                    return;
                }
                var type = cmd.actionType;
                if (type === 'META') {
                    cmd.runAction();
                    return;
                }
                calc.formula.handleCmd(cmd);
            },

            // Low level
            key: function (key) {
                calc.ui.focusInput();
                clog('[calc.process.key] got key: ' + key);
                switch (key) {
                case K.ENTER:
                    // return calc.process.cmd('META_PROCEED');
                    return calc.process.cmd(BTS.META_PROCEED);
                case K.BACKSPACE:
                    // return calc.process.cmd('META_CLEAR');
                    return calc.process.cmd(BTS.META_CLEAR);
                }
                var chr = String.fromCharCode(key || 0);
                calc.process.chr(chr, key);
            },
            chr: function (chr) {
                console.log('[calc.process.chr] got chr: ' + chr);
                if (!(KEY_ALIASES[chr] === undefined)) {
                    var alias = KEY_ALIASES[chr];
                    console.log('[calc.process.chr] alias: ' + alias);
                    calc.process.cmd(BTS[alias]);
                    // calc.process.cmd(BTS[KEY_ALIASES[chr]]);
                    return;
                }
                // calc.formula.handleChr(chr);
                calc.formula.handleChr(BTS[chr]);
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
        });
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
                var query = DDG.get_query();
                if (query !== 'calculator') {
                    calc.process.calculation(query);
                    calc.formula.calculate();
                }
            }
        }
    };
};

Handlebars.registerHelper('iterate', function(context, options) {
    out = "";
    if (options.data) {
        data = Handlebars.createFrame(options.data);
    }
    var times = context;
    var start = options.hash.start || 0;
    var step = options.hash.step || 1;
    var end = options.hash.end || start + step * (times - 1);
    // var end = options.hash['end'];
    for (var i=start; i<=end; i+=step) {
        if (data) {
            data.this = i;
        }
        out += options.fn(data.this);
    }
    return out;
});

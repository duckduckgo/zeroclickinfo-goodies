DDH.urlencode = DDH.urlencode || {};

DDH.urlencode.build = function (ops) {
    'use strict';

    /**
     * Event handler that selects contents of bound event target in browser
     * window.
     * @param {Event} e - An Event object containing details of the executed
     * event
     */
    function selectContents(e) {
        var selection = window.getSelection();

        // only select all contents if none was selected
        if (selection.anchorOffset === selection.focusOffset) {
            selection.removeAllRanges();
            selection.selectAllChildren(e.target);
        }
    }

    return {
        onShow: function () {
            // select contents of result when clicked once, for easy copy
            var $result = $('.zci--urlencode .zci__content pre');
            $result.on('click', selectContents);
        }
    }
}

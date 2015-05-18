DDH.cheat_sheets = DDH.cheat_sheets || {};

DDH.cheat_sheets.build = function(ops) {

    Spice.registerHelper('cheatsheets_ordered', function(sections, section_order, options) {
        var result ="";
        $.each(section_order, function(i, section) {
           if (sections[section]){
               result += options.fn({ name: section, items: sections[section] });
            }
        });
        return result;
    });

    var re_lbrackets   = /(^|[^\\])(\[|\{)/gi, // search for [ or {, but not \[ or \{
        re_rbrackets   = /([^\\])(\]|\})/gi,   // search for ] or ], but not \] or \}
        re_escbrackets = /(?:\\(\[|\{|\]|\}))/gi, // search for \[, \], \{, and \}
        re_whitespace  = /\s+/,
        re_codeblock   = /<code>(.+?)<\/code>/g;
        _escape = Handlebars.Utils.escapeExpression;

    Spice.registerHelper('cheatsheets_codeblock', function(string, options) {

        var out;

        if (re_lbrackets.test(string) && re_rbrackets.test(string)) {

            // replace '[' or '{' with '<code>'
            string = string.replace(re_lbrackets, '$1<code>');

            // replace ']' or '}' with '</code>'
            string = string.replace(re_rbrackets, '$1</code>');

            // replace '\[' or '\{' with '[' or '{'
            // replace '\]' or '\}' with ']' or '}'
            string = string.replace(re_escbrackets, '$1');

            out = string.replace(re_codeblock, function(match, p1, offset, string){
                return "<code>" + _escape(p1) + "</code>";
            });
        } else {
           out = "<code>" + _escape(string) + "</code>";
        }

        return new Handlebars.SafeString(out);
    });

    return {
         onShow: function() {
            var $dom = $("#zci-cheat_sheets"),
                $container = $dom.find(".cheatsheet__container"),
                $more_btn  = $dom.find(".chomp--link"),
                $icon = $more_btn.find(".chomp--link__icn"),
                $more = $more_btn.find(".chomp--link__mr"),
                $less = $more_btn.find(".chomp--link__ls");

             DDG.require('masonry.js', function(){
                 $container.masonry({
                     columnWidth: '.grid-sizer',
                     itemSelector: '.cheatsheet__section',
                     gutter: 5,
                     percentPosition: true
                 });

                $more_btn.click(function() {
                    $dom.toggleClass("has-chomp-expanded");
                    $container.toggleClass("compressed");
                });
             });
         }
    };
};
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

    var re_lbrackets = /(^|[^\\])(\[|\{)/gi, // search for [ or {, but not \[ or \{
        re_rbrackets = /([^\\])(\]|\})/gi,   // search for ] or ], but not \] or \}
        re_escbrackets = /(?:\\(\[|\{|\]|\}))/gi; // search for \[, \], \{, and \}

    Spice.registerHelper('cheatsheets_codeblock', function(string, options) {
        // replace '[' or '{' with '<code>'
        string = string.replace(re_lbrackets, '$1<code>');

        // replace ']' or '}' with '</code>'
        string = string.replace(re_rbrackets, '$1</code>');

        // replace '\[' or '\{' with '[' or '{'
        // replace '\]' or '\}' with ']' or '}'
        string = string.replace(re_escbrackets, '$1');

        return new Handlebars.SafeString(string);
    });

    return {
         onShow: function() {
            var $dom = $("#zci-cheat_sheets"),
                $container = $dom.find(".cheatsheet__container"),
                $more_btn  = $dom.find(".chomp--link"),
                $icon = $more_btn.find(".chomp--link__icn"),
                $more = $more_btn.find(".chomp--link__mr"),
                $less = $more_btn.find(".chomp--link__ls");

            $more_btn.click(function() {
                $dom.toggleClass("has-chomp-expanded");
                $container.toggleClass("compressed");
            });
         }
    };
};
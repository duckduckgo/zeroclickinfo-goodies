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

    var re_brackets    = /(?:\[|\{|\}|\])/,      // search for [, {, }, or }
        re_escbrackets = /(?:\\(\[|\{|\]|\}))/g, // search for \[, \], \{, and \}
        re_whitespace  = /\s+/,                  // search for spaces
        re_codeblock   = /<code>(.+?)<\/code>/g; // search for <code></code>

    Spice.registerHelper('cheatsheets_codeblock', function(string, options) {

        var out;

        // no spaces
        // OR
        // spaces and no brackets
        // e.g "?()", ":sp filename"
        //  --> wrap whole sting in <code></code>
        if ( !re_whitespace.test(string) || !re_brackets.test(string) ){
            out = "<code>" + string + "</code>";

        // spaces
        // AND
        // brackets
        // e.g "[Ctrl] [B]"
        //  --> replace [] & {} with <code></code>
        } else {
            out = string
                // replace pairs of brackets with <code></code>
                .replace(/(?:\[|\{)([^\[\]\{\}].*?)(?:\]|\})/g, "<code>$1</code>")
                // un-escape remaining brackets
                .replace(/\\\[/, "[")
                .replace(/\\\{/, "{")
                .replace(/\\\]/, "]")
                .replace(/\\\}/, "}");

        }

        out = out.replace(re_codeblock, function esc_codeblock (match, p1, offset, string){
            var escaped = Handlebars.Utils.escapeExpression(p1);
            return "<code>" + escaped + "</code>";
        });

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
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

    var re_brackets    = /(?:(?:\[)(.+?)(?:\])|(?:\{)(.+?)(?:\}))/g, // search for [] or {}
        re_escbrackets = /(?:\\(\[|\{|\]|\}))/g,     // search for \[, \], \{, and \}
        re_whitespace  = /\s+/,                      // search for spaces
        re_codeblock   = /<code>(.+?)<\/code>/g;     // search for <code></code>

    Spice.registerHelper('cheatsheets_codeblock', function(string, options) {

        var out;

        // has escaped brackets
        // e.g. "[Ctrl-B] {\[}"
        //  --> replace escaped brackets
        if (re_escbrackets.test(string)){
            console.log("escaped brackets: " + string);
            string = string
                .replace(/\\\[/, "&#91;")
                .replace(/\\\]/, "&#93;")
                .replace(/\\\{/, "&#123;")
                .replace(/\\\}/, "&#125;");
            console.log("now: " + string);
        }

        // no spaces
        // OR
        // spaces and no brackets
        // e.g "?()", ":sp filename"
        //  --> wrap whole sting in <code></code>
        if ( re_whitespace.test(string) === false || re_brackets.test(string) === false ){
            console.log("No spaces OR no bracket: " + string);
            out = "<code>" + string + "</code>";
            console.log("now: " + out);

        // spaces
        // AND
        // brackets
        // e.g "[Ctrl] [B]"
        //  --> replace [] & {} with <code></code>
        } else {
            console.log("spaces AND brackets: " + string);
            out = string
                .replace(/\[|\{/g, "<code>")
                .replace(/\]|\}/g, "</code>");
            console.log("now: " + out);
        }

        console.log("out: " + out);

        out = out.replace(re_codeblock, function(match, p1, offset, string){
            console.log("escaping codeblocks...");
            console.log("match: " + match);
            console.log("string: " + string);
            var escaped = Handlebars.Utils.escapeExpression(p1);
            console.log("escaped: " + escaped);
            return "<code>" + escaped + "</code>";
        });

        console.log("final: " + out);

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
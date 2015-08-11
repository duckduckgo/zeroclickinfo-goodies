DDH.cheat_sheets = DDH.cheat_sheets || {};

DDH.cheat_sheets.build = function(ops) {

    Spice.registerHelper('cheatsheets_ordered', function(sections, section_order, options) {
        var result = "";
        $.each(section_order, function(i, section) {
           if (sections[section]){

               var showhide = true;

               if (i === 0 ){
                   showhide = false;
               } else if ( i === 1 && !is_mobile ){
                   showhide = false;
               }

               result += options.fn({ name: section, items: sections[section], showhide: showhide });
            }
        });
        return result;
    });

    var re_brackets    = /(?:\[|\{|\}|\])/,      // search for [, {, }, or }
        re_whitespace  = /\s+/,                  // search for spaces
        re_codeblock   = /<code>(.+?)<\/code>/g; // search for <code></code>

    Spice.registerHelper('cheatsheets_codeblock', function(string, options) {

        var out;

        // replace escaped slashes and brackets
        string = string.replace(/\\\\/, "<bks>")
                .replace(/\\\[/g, "<lbr>")
                .replace(/\\\{/g, "<lcbr>")
                .replace(/\\\]/g, "<rbr>")
                .replace(/\\\}/g, "<rcbr>");

        // no spaces
        // OR
        // spaces and no un-escaped brackets
        // e.g "?()", ":sp filename"
        //  --> wrap whole sting in <code></code>
        if ( !re_whitespace.test(string) || !re_brackets.test(string) ){
            out = "<code>" + string + "</code>";

        // spaces
        // AND
        // un-escaped brackets
        // e.g "[Ctrl] [B]"
        //  --> replace [] & {} with <code></code>
        } else {

            // replace unescaped brackets
            out = string
                .replace(/\[|\{/g, "<code>")
                .replace(/\]|\}/g, "</code>");
        }

        out = out
                // re-replace escaped slash
                .replace(/<bks>/g,  "\\")
                // re-replace escaped brackets
                .replace(/<lbr>/g,  "[")
                .replace(/<lcbr>/g, "{")
                .replace(/<rbr>/g,  "]")
                .replace(/<rcbr>/g, "}");

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
                $detail    = $dom.find(".zci__main--detail"),
                $section   = $dom.find(".cheatsheet__section"),
                $hideRow   = $section.find("tbody tr:nth-child(n+4)"),
                $showhide  = $container.find(".cheatsheet__section.showhide"),
                $more_btn  = $dom.find(".chomp--link");

            // Removes all tr's after the 3rd before masonry fires
            if ($container.hasClass("compressed")) {
              $hideRow.toggleClass("is-hidden");
            }

            DDG.require('masonry.js', function(){

                $container.masonry({
                    itemSelector: '.cheatsheet__section',
                    columnWidth: 295,
                    gutter: 30,
                    isFitWidth: true
                });

                $more_btn.click(function() {
                    $dom.toggleClass("has-chomp-expanded");
                    $detail.toggleClass("c-base");
                    $container.toggleClass("compressed");
                    $showhide.toggleClass("is-hidden");
                    $hideRow.toggleClass("is-hidden");
                    $container.masonry({
                        itemSelector: '.cheatsheet__section',
                        columnWidth: 295,
                        gutter: 30,
                        isFitWidth: true
                    });
                });
             });
         }
    };
};

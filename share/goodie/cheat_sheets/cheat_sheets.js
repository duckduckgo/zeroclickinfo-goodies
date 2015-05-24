DDH.cheat_sheets = DDH.cheat_sheets || {};

DDH.cheat_sheets.build = function(ops) {

    Handlebars.registerHelper('ordered_cheatsheet', function(sections, section_order, options) {
        var result ="";
        $.each(section_order, function(i, section) {
           if (sections[section]){
               result += options.fn({ name: section, items: sections[section] });
            }
        });
        return result;
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
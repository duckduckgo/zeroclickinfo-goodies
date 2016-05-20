Handlebars.registerHelper('escapeHTML', function(text, options) {
    // See https://github.com/janl/mustache.js/blob/master/mustache.js#L60
    var entityMap = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;',
        '/': '&#x2F;',
        '`': '&#x60;',
        '=': '&#x3D;'
    };

    function escapeHtml (string) {
        return String(string).replace(/[&<>"'`=\/]/g, function fromEntityMap (s) {
        return entityMap[s];
        });
    }
    return options.fn(escapeHtml(text));
});

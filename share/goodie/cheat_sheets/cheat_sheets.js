Handlebars.registerHelper('withItem', function(object, options) {
    return options.fn(object[options.hash.key]);
});

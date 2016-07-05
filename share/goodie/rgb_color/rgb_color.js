Handlebars.registerHelper('color', function(hex) {
    return hex + ' <span class="rgb_color--color-box" style="color:' +
        hex + '">&#9632</span>';
});

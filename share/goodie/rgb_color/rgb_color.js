Handlebars.registerHelper('color', function(color) {
    var nameText = '';
    if (color.name !== '') {
        nameText = ' (' + color.name + ')';
    }
    return color.hex + nameText + ' <span class="rgb_color--color-box" style="color:' +
        color.hex + '">&#9632</span>';
});

Handlebars.registerHelper('color', function(color) {
    var nameText = '';
    var hex = color.hex;
    var colorPickerLink = 'https://duckduckgo.com/?q=color+picker+' +
        encodeURIComponent(hex);
    if (color.name !== '') {
        nameText = ' (' + color.name + ')';
    }
    var href = 'href="' + colorPickerLink + '"';
    var hexBody = '<a class="rgb_color--link" ' + href + '>' + hex +
        nameText + '</a>';
    var boxBody = '<a class="rgb_color--link rgb_color--color-box" ' +
        href + ' style="color:' + hex + '">&#9632</a>';
    var body = '<span>' + hexBody + ' ' + boxBody + '</span>';
    return body;
});

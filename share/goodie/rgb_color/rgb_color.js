Handlebars.registerHelper('color', function(color) {
    var nameText = '';
    var hex = color.hex;
    var colorPickerLink = 'https://duckduckgo.com/?q=color+picker+' +
        encodeURIComponent(hex);
    if (color.name !== '') {
        nameText = ' (' + color.name + ')';
    }
    var amountText = '';
    if (color.amount !== undefined) {
        var pct = Number(sprintf('%.2f', color.amount * 100)).
            toLocaleString();
        amountText = '<span>(' + pct + '%)</span> ';
    }
    var href = 'href="' + colorPickerLink + '"';
    var hexBody = '<a class="rgb_color--link" ' + href + '>' + hex +
        nameText + '</a>';
    var boxBody = '<a class="rgb_color--link rgb_color--color-box" ' +
        href + ' style="color:' + hex + '">&#9632</a>';
    var body = '<span>' + amountText + hexBody + ' ' + boxBody + '</span>';
    return body;
});

Handlebars.registerHelper('colorPickerLink', function(hex) {
    return '/?q=' + encodeURIComponent('color picker #' + hex);
});

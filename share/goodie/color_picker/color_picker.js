DDH.color_picker = DDH.color_picker || {};

(function(DDH) {
    "use strict";
    var local_dom = {
        initialized: false
    };

    //  Maintains currently selected palette type so that it doesn't have to be read from
    //  $palette_select on every update.
    var palette_type = 'analogous';

    //Maintains the current color in all supported formats.
    var current_color = null,
        markers = null;
    //  Holds coordinate positions for the selection markers in the hue and saturation/value
    //  pickers.

    //  Indicates whether the user is currently dragging the mouse in the hue and saturation/value
    //  pickers.
    var saturation_value_mousedown = false,
        hue_mousedown = false;

    //  Prevent duplicate touch/mouse events
    var mouse_and_touch_locked = false;
    
    DDH.color_picker.build = function(ops) {
        current_color = get_initial_color(ops.data.color);
        markers = get_marker_positions(current_color.hsv);
        return {
            onShow: function() {
                //  The DOM cache was not initialized when it was created. The DOM should be ready
                //  here, so we can initialize now.
                if (!local_dom.initialized)
                    initialize_local_dom();
                update_all();
            }
        };
    };

    /* UTILITY FUNCTIONS */

    //  Converts a given string value to an integer, which is forced between the given bounds. If
    //  the input string is not a valid number, it is treated as 0.
    function to_bounded_integer(value, lower_bound, upper_bound) {
        var num = Math.round(Number(value));
        if (isNaN(num))
            num = 0;

        if (num < lower_bound)
            num = Math.ceil(lower_bound);
        if (num > upper_bound)
            num = Math.floor(upper_bound);

        return num;
    }

    //  Converts a given string value to a number, which is forced between the given bounds. If
    //  the input string is not a valid number, it is treated as 0.
    function to_bounded_number(value, lower_bound, upper_bound) {
        var num = Number(value);
        if (isNaN(num))
            num = 0;

        if (num < lower_bound)
            num = lower_bound;
        if (num > upper_bound)
            num = upper_bound;

        return num;
    }
    
    //  Finds the coordinates of a mouse or touch event relative to an element.
    function get_real_coordinates(event, $element) {
        var offset = $element.offset(),
            coordinates = {
                x: event.pageX - offset.left,
                y: event.pageY - offset.top
            };
        return coordinates;
    }

    //  Creates a single handler that can be user for both mouse and touch events.
    function mouse_and_touch_handler(callback) {
        return function(e) {
            if (!mouse_and_touch_locked) {
                //  Certain actions will result in both a mouse and touch event being fired.
                //  In these cases, the combination of the lock and timeout below will keep
                //  both events from being processed.
                mouse_and_touch_locked = true;
                setTimeout(function() {mouse_and_touch_locked = false;}, 0);

                if (e.changedTouches && e.changedTouches.length > 0) {
                    callback(e.changedTouches[0]);
                } else if (e.targetTouches && e.targetTouches.length > 0) {
                    callback(e.targetTouches[0]);
                } else {
                    callback(e);
                }
            }
        };
    }

    /* EVENT HANDLERS */

    function saturation_value_clicked(event) {
        var coordinates = get_real_coordinates(event, local_dom.$saturation_value_picker);

        //  Use the coordinates of the mouse/touch event to calculate the new saturation/value
        var saturation = Math.floor((coordinates.x / 256) * 100),
            value = Math.floor(((256 - coordinates.y) / 256) * 100),
            hue = current_color.hsv.hue;

        saturation = to_bounded_integer(saturation, 0, 100);
        value = to_bounded_integer(value, 0, 100);

        update_all_from_hsv(hue, saturation, value);
    }

    function hue_clicked(event) {
        var coordinates = get_real_coordinates(event, local_dom.$hue_picker);

        //  Use the coordinates of the mouse/touch event to calculate the new hue
        var hue = Math.floor((coordinates.y / 256) * 360),
            saturation = current_color.hsv.saturation,
            value = current_color.hsv.value;

        hue = to_bounded_integer(hue, 0, 359);

        update_all_from_hsv(hue, saturation, value);
    }

    function rgb_change() {
        var red = local_dom.$red_input.val(),
            green = local_dom.$green_input.val(),
            blue = local_dom.$blue_input.val();

        red = to_bounded_integer(red, 0, 255);
        green = to_bounded_integer(green, 0, 255);
        blue = to_bounded_integer(blue, 0, 255);

        update_all_from_rgb(red, green, blue);
    }

    function hsv_change() {
        var hue = local_dom.$hue_input.val(),
            saturation = local_dom.$saturation_input.val(),
            value = local_dom.$value_input.val();

        hue = to_bounded_integer(hue, 0, 359);
        saturation = to_bounded_integer(saturation, 0, 100);
        value = to_bounded_integer(value, 0, 100);

        update_all_from_hsv(hue, saturation, value);
    }

    function cmyk_change() {
        var cyan = local_dom.$cyan_input.val(),
            magenta = local_dom.$magenta_input.val(),
            yellow = local_dom.$yellow_input.val(),
            black = local_dom.$black_input.val();

        cyan = to_bounded_number(cyan, 0, 100);
        magenta = to_bounded_number(magenta, 0, 100);
        yellow = to_bounded_number(yellow, 0, 100);
        black = to_bounded_number(black, 0, 100);

        update_all_from_cmyk(cyan, magenta, yellow, black);
    }
    
    function hex_change() {
        var hex = local_dom.$hex_input.val();

        //  There are a few ways a new hex string could look and still be valid. It may more may
        //  not start with a '#' character, and it may contain some combination of uppercase and
        //  lowercase letters. It can also contain either three or six hex numerals. Any other
        //  number and the string is either too long, or ambiguous (e.g. #abc -> #0a0b0c, but
        //  #abcd -> #0a0bcd or #a0bcd and so on).
        if (hex.charAt(0) === '#') hex = hex.substring(1);
        if (/^[0-9a-f]+$/i.test(hex)) {
            if (hex.length === 3)
                hex = hex.charAt(0) + hex.charAt(0) + hex.charAt(1) + hex.charAt(1) + hex.charAt(2) + hex.charAt(2);
            if (hex.length === 6)
                update_all_from_hex(hex);
            else
                update_all_from_hex(current_color.hex.substring(1));
        } else
            update_all_from_hex(current_color.hex.substring(1));
    }

    function palette_change() {
        palette_type = local_dom.$palette_select.val();
        update_palette();
    }

    //  Calculates the correct positions for the draggable markers in the hue and saturation/value
    //  pickers, relative to the picker.
    function get_marker_positions(hsv) {
        var markers = {
            hue: {
                y: Math.round((hsv.hue / 360) * 256) - 3
            },
            saturation_value: {
                x: Math.round((hsv.saturation / 100) * 256) - 3,
                y: 256 - Math.round((hsv.value / 100) * 256) - 3
            }
        };

        return markers;
    }

    function update_all_from_hsv(hue, saturation, value) {
        current_color = get_all_colors_from_hsv(hue, saturation, value);
        markers = get_marker_positions(current_color.hsv);
        update_all();
    }

    function update_all_from_rgb(red, green, blue) {
        current_color = get_all_colors_from_rgb(red, green, blue);
        markers = get_marker_positions(current_color.hsv);
        update_all();
    }

    function update_all_from_cmyk(cyan, magenta, yellow, black) {
        current_color = get_all_colors_from_cmyk(cyan, magenta, yellow, black);
        markers = get_marker_positions(current_color.hsv);
        update_all();
    }

    function update_all_from_hex(hex) {
        var rgb = convert_hex_to_rgb(hex);
        current_color = get_all_colors_from_rgb(rgb.red, rgb.green, rgb.blue);
        markers = get_marker_positions(current_color.hsv);
        update_all();
    }

    function get_all_colors_from_hsv(hue, saturation, value) {
        var hsv = {
                hue: hue,
                saturation: saturation,
                value: value
            },
            rgb = convert_hsv_to_rgb(hue, saturation, value),
            cmyk = convert_rgb_to_cmyk(rgb.red, rgb.green, rgb.blue),
            hex = convert_rgb_to_hex(rgb.red, rgb.green, rgb.blue),
            hex_hue = convert_hsv_to_hex(hue, 100, 100),
            palette = generate_palette(hsv, palette_type),
            colors = {
                rgb: rgb,
                hsv: hsv,
                cmyk: cmyk,
                hex: hex,
                hex_hue: hex_hue,
                palette: palette
            };

        return colors;
    }

    function get_all_colors_from_rgb(red, green, blue) {
        var rgb = {
                red: red,
                green: green,
                blue: blue
            },
            hsv = convert_rgb_to_hsv(red, green, blue),
            cmyk = convert_rgb_to_cmyk(red, green, blue),
            hex = convert_rgb_to_hex(red, green, blue),
            hex_hue = convert_hsv_to_hex(hsv.hue, 100, 100),
            palette = generate_palette(hsv, palette_type),
            colors = {
                rgb: rgb,
                hsv: hsv,
                cmyk: cmyk,
                hex: hex,
                hex_hue: hex_hue,
                palette: palette
            };

        return colors;
    }

    function get_all_colors_from_cmyk(cyan, magenta, yellow, black) {
        var cmyk = {
                cyan: cyan,
                magenta: magenta,
                yellow: yellow,
                black: black
            },
            rgb = convert_cmyk_to_rgb(cyan, magenta, yellow, black),
            hsv = convert_rgb_to_hsv(rgb.red, rgb.green, rgb.blue),
            hex = convert_rgb_to_hex(rgb.red, rgb.green, rgb.blue),
            hex_hue = convert_hsv_to_hex(hsv.hue, 100, 100),
            palette = generate_palette(hsv, palette_type),
            colors = {
                rgb: rgb,
                hsv: hsv,
                cmyk: cmyk,
                hex: hex,
                hex_hue: hex_hue,
                palette: palette
            };

        return colors;
    }

    function generate_palette(hsv, type) {
        var hue = [],
            saturation = [],
            value = [],
            palette = [];

        switch (type) {
            case 'triad':
                hue = [hsv.hue, (hsv.hue + 120) % 360, (hsv.hue + 240) % 360];
                saturation = [hsv.saturation, hsv.saturation, hsv.saturation];
                value = [hsv.value, hsv.value, hsv.value];
                break;
            case 'tetrad':
                hue = [(hsv.hue + 60) % 360, (hsv.hue + 180) % 360, (hsv.hue + 240) % 360];
                saturation = [hsv.saturation, hsv.saturation, hsv.saturation];
                value = [hsv.value, hsv.value, hsv.value];
                break;
            case 'analogous': //fall through
            default:
                hue = [hsv.hue, (hsv.hue + 30) % 360, (hsv.hue + 330) % 360];
                saturation = [hsv.saturation, hsv.saturation, hsv.saturation];
                value = [hsv.value, hsv.value, hsv.value];
                break;
        }

        for (var i = 0; i < hue.length; i++)
            palette.push(convert_hsv_to_hex(hue[i], saturation[i], value[i]));

        return palette;
    }

    function update_palette() {
        current_color.palette = generate_palette(current_color.hsv, palette_type);
        update_all();
    }

    function update_all() {
        local_dom.$red_input.val(current_color.rgb.red);
        local_dom.$green_input.val(current_color.rgb.green);
        local_dom.$blue_input.val(current_color.rgb.blue);
        local_dom.$hue_input.val(current_color.hsv.hue);
        local_dom.$saturation_input.val(current_color.hsv.saturation);
        local_dom.$value_input.val(current_color.hsv.value);
        local_dom.$cyan_input.val(current_color.cmyk.cyan);
        local_dom.$magenta_input.val(current_color.cmyk.magenta);
        local_dom.$yellow_input.val(current_color.cmyk.yellow);
        local_dom.$black_input.val(current_color.cmyk.black);
        local_dom.$hex_input.val(current_color.hex.substring(1));

        local_dom.$saturation_value_picker.css('background-color', current_color.hex_hue);
        local_dom.$sample.css('background-color', current_color.hex);

        local_dom.$saturation_value_marker.css('top', markers.saturation_value.y);
        local_dom.$saturation_value_marker.css('left', markers.saturation_value.x);
        local_dom.$hue_marker.css('top', markers.hue.y);

        //  Change the color of the text in the samples to make sure it is legible.
        local_dom.$palette_sample.each(function(i) {
            $(this).css('background-color', current_color.palette[i]);
        });

        local_dom.$palette_input.each(function(i) {
            $(this).text(current_color.palette[i].substring(1));
        });
    }

    /* CONVERSIONS */

    function convert_hsv_to_rgb(hue, saturation, value) {
        var c = (value / 100) * (saturation / 100),
            x = c * (1 - Math.abs(((hue / 60) % 2) - 1)),
            m = (value / 100) - c,

            red = 0,
            green = 0,
            blue = 0;

        switch (true) {
            case 0 <= hue && hue < 60:
                red = c; green = x; blue = 0;
                break;
            case 60 <= hue && hue < 120:
                red = x; green = c; blue = 0;
                break;
            case 120 <= hue && hue < 180:
                red = 0; green = c; blue = x;
                break;
            case 180 <= hue && hue < 240:
                red = 0; green = x; blue = c;
                break;
            case 240 <= hue && hue < 300:
                red = x; green = 0; blue = c;
                break;
            case 300 <= hue && hue < 360:
                red = c; green = 0; blue = x;
                break;
        }
        red = Math.floor(255 * (red + m));
        green = Math.floor(255 * (green + m));
        blue = Math.floor(255 * (blue + m));

        var rgb = {
            red: red,
            green: green,
            blue: blue
        };

        return rgb;
    }

    function convert_rgb_to_hsv(red, green, blue){
        var red_proportion = red / 255,
            green_proportion = green / 255,
            blue_proportion = blue / 255,

            min = Math.min(red_proportion, Math.min(green_proportion, blue_proportion)),
            max = Math.max(red_proportion, Math.max(green_proportion, blue_proportion)),
            delta = max - min,

            hue = 0,
            saturation = (max > 0) ? Math.round(((max - min) * 100) / max) : 0,
            value = Math.round(max * 100);

        if (delta > 0) {
            switch (max) {
                case red_proportion:
                    hue = Math.round(60 * (((green_proportion - blue_proportion) / delta)));
                    break;
                case green_proportion:
                    hue = Math.round(60 * (((blue_proportion - red_proportion) / delta) + 2));
                    break;
                case blue_proportion:
                    hue = Math.round(60 * (((red_proportion - green_proportion) / delta) + 4));
                    break;
            }
        }
        if (hue < 0) hue += 360;

        var hsv = {
            hue: hue,
            saturation: saturation,
            value: value
        };

        return hsv;
    }

    function convert_rgb_to_cmyk(red, green, blue){
        var red_proportion = red / 255,
            green_proportion = green / 255,
            blue_proportion = blue / 255,

            black = 1 - Math.max(red_proportion, Math.max(green_proportion, blue_proportion)),
            cyan = (black < 1) ? ((1 - red_proportion - black) / (1 - black)) : 0,
            magenta = (black < 1) ? ((1 - green_proportion - black) / (1 - black)) : 0,
            yellow = (black < 1) ? ((1 - blue_proportion - black) / (1 - black)) : 0,

            cmyk= {
                black: (100 * black).toFixed(0),
                cyan: (100 * cyan).toFixed(0),
                magenta: (100 * magenta).toFixed(0),
                yellow: (100 * yellow).toFixed(0)
            };

        return cmyk;
    }

    function convert_rgb_to_hex(red, green, blue){
        var red_string = red.toString(16),
            green_string = green.toString(16),
            blue_string = blue.toString(16);

        if (red_string.length < 2)
            red_string = '0' + red_string;
        if (green_string.length < 2)
            green_string = '0' + green_string;
        if (blue_string.length < 2)
            blue_string = '0' + blue_string;

        return '#' + red_string + green_string + blue_string;
    }

    function convert_hsv_to_hex(hue, saturation, value) {
        var rgb = convert_hsv_to_rgb(hue, saturation, value),
            hex = convert_rgb_to_hex(rgb.red, rgb.green, rgb.blue);

        return hex;
    }

    function convert_hex_to_rgb(hex) {
        var red = parseInt(hex.substring(0,2), 16),
            green = parseInt(hex.substring(2,4), 16),
            blue = parseInt(hex.substring(4,6), 16),

            rgb = {
                red: red,
                green: green,
                blue: blue
            };

        return rgb;
    }

    function convert_cmyk_to_rgb(cyan, magenta, yellow, black) {
        var c = cyan / 100,
            m = magenta / 100,
            y = yellow / 100,
            k = black / 100,

            red = Math.round(255 * (1 - c) * (1 - k)),
            green = Math.round(255 * (1 - m) * (1 - k)),
            blue = Math.round(255 * (1 - y) * (1 - k)),

            rgb = {
                red: red,
                green: green,
                blue: blue
            };

        return rgb;
    }

    //  Generates a a color to use when the IA is first loaded. It first checks the query to find
    //  a specified color. If no color was specified, one is randomly generated.
    function get_initial_color(query) {
        var query_color = parse_color_from_query(query);

        if (query_color !== null)
            return query_color;

        var hue = Math.floor(Math.random() * 360),
            saturation = Math.floor(Math.random() * 100),
            value = Math.floor(Math.random() * 100),

            colors = get_all_colors_from_hsv(hue, saturation, value);

        return colors;
    }

    //  Searches the query for a color. Returns null if no color was specified in the query.
    function parse_color_from_query(query) {
        //  This will take the query string, remove the first two words (e.g. 'color picker'), and
        //  format it for later processing. The result will have all spaces, and parentheses
        //  replaced with commas such that there will only be one comma between any text.
        //  For example, HSV(1, 2, 3) becomes hsv,1,2,3
        if (query === null){
            return null;
        }
        var possible_color_query = query.toLowerCase();

        if (possible_color_query.length === 0)
            return null;

        switch (true) {
            case possible_color_query.lastIndexOf('rgb', 0) === 0:

                var rgb_nums = possible_color_query.split(',').slice(1);

                if (rgb_nums.length < 3)
                    return null;
                var red = to_bounded_integer(rgb_nums[0], 0, 255),
                    green = to_bounded_integer(rgb_nums[1], 0, 255),
                    blue = to_bounded_integer(rgb_nums[2], 0, 255),
                    colors = get_all_colors_from_rgb(red, green, blue);
                return colors;
            case possible_color_query.lastIndexOf('hsv', 0) === 0:
                var hsv_nums = possible_color_query.replace(/%/g, '').split(',').slice(1);
                if (hsv_nums.length < 3)
                    return null;
                var hue = to_bounded_integer(hsv_nums[0], 0, 360),
                    saturation = to_bounded_integer(hsv_nums[1], 0, 100),
                    value = to_bounded_integer(hsv_nums[2], 0, 100),
                    colors = get_all_colors_from_hsv(hue, saturation, value);
                return colors;
            case possible_color_query.lastIndexOf('cmyk', 0) === 0:
                var cmyk_nums = possible_color_query.split(',').slice(1);

                if (cmyk_nums.length < 4)
                    return null;
                var cyan = to_bounded_number(cmyk_nums[0], 0, 100),
                    magenta = to_bounded_number(cmyk_nums[1], 0, 100),
                    yellow = to_bounded_number(cmyk_nums[2], 0, 100),
                    black = to_bounded_number(cmyk_nums[3], 0, 100),
                    colors = get_all_colors_from_cmyk(cyan, magenta, yellow, black);
                return colors;
            default:
                var hex = possible_color_query;
                if (hex.lastIndexOf('#', 0) === 0){
                    hex = hex.substring(1);
                }

                if (/^[0-9a-f]+$/i.test(hex)) {
                    if (hex.length === 3)
                        hex = hex.charAt(0) + hex.charAt(0) + hex.charAt(1) + hex.charAt(1) + hex.charAt(2) + hex.charAt(2);
                    if (hex.length === 6) {
                        var rgb = convert_hex_to_rgb(hex),
                            colors = get_all_colors_from_rgb(rgb.red, rgb.green, rgb.blue);
                        return colors;
                    }
                }
        }
        
        return null;
    }

    function initialize_local_dom() {
        //  The container of this instant answer will be the root for all other elements.
        var $root = $('#color_picker_container');

        //  Find all of the elements of interest within the instant answer.
        local_dom = {
            $saturation_value_picker: $root.find('#saturation_value_picker'),
            $hue_picker: $root.find('#hue_picker'),
            $red_input: $root.find('#red_input'),
            $green_input: $root.find('#green_input'),
            $blue_input: $root.find('#blue_input'),
            $hue_input: $root.find('#hue_input'),
            $saturation_input: $root.find('#saturation_input'),
            $value_input: $root.find('#value_input'),
            $cyan_input: $root.find('#cyan_input'),
            $magenta_input: $root.find('#magenta_input'),
            $yellow_input: $root.find('#yellow_input'),
            $black_input: $root.find('#black_input'),
            $hex_input: $root.find('#hex_input'),
            $palette_select: $root.find('#palette_select'),
            $sample: $root.find('#sample'),
            $saturation_value_marker: $root.find('#saturation_value_marker'),
            $hue_marker: $root.find('#hue_marker'),
            $palette_sample: $root.find('.palette_sample'),
            $palette_input: $root.find('.palette_input'),
            initialized: true
        };

        //  Event Handling

        //  For the hue and saturation/value pickers, there are a few things we need to do. First,
        //  we need to listen for click events so that a user can click anywhere in the picker
        //  to immediate jump to that color. We also need to allow the user to drag the mouse
        //  around in the pickers, so we need to keep the browser from using the default drag
        //  action on images. Then we respond to mousemove events if the mouse was already down
        //  on the picker the same way we respond to a click.
        local_dom.$saturation_value_picker.click(mouse_and_touch_handler(saturation_value_clicked));
        local_dom.$saturation_value_picker.on('dragstart', function(event) {event.preventDefault();});
        local_dom.$saturation_value_picker.mousedown(mouse_and_touch_handler(function() { saturation_value_mousedown = true; }));
        local_dom.$saturation_value_picker.mousemove(mouse_and_touch_handler(function(event) { if (saturation_value_mousedown) saturation_value_clicked(event); }));

        local_dom.$hue_picker.click(mouse_and_touch_handler(hue_clicked));
        local_dom.$hue_picker.on('dragstart', function(event) {event.preventDefault();});
        local_dom.$hue_picker.mousedown(mouse_and_touch_handler(function() { hue_mousedown = true; }));
        local_dom.$hue_picker.mousemove(mouse_and_touch_handler(function(event) { if (hue_mousedown) hue_clicked(event); }));

        $(document).mouseup(function() { saturation_value_mousedown = false; hue_mousedown = false; });
        $root.focusout(function() { saturation_value_mousedown = false; hue_mousedown = false; });

        //  Also need to listen for touch events for touch-enabled devices.
        local_dom.$saturation_value_picker[0].addEventListener('touchstart', mouse_and_touch_handler(saturation_value_clicked), false);
        local_dom.$saturation_value_picker.on('touchmove', function(event) {event.preventDefault();});
        local_dom.$saturation_value_picker[0].addEventListener('touchmove', mouse_and_touch_handler(saturation_value_clicked), false);

        local_dom.$hue_picker[0].addEventListener('touchstart', mouse_and_touch_handler(hue_clicked), false);
        local_dom.$hue_picker.on('touchmove', function(event) {event.preventDefault();});
        local_dom.$hue_picker[0].addEventListener('touchmove', mouse_and_touch_handler(hue_clicked), false);

        //  Listen for changes to any of the text inputs
        local_dom.$red_input.change(rgb_change);
        local_dom.$green_input.change(rgb_change);
        local_dom.$blue_input.change(rgb_change);
        local_dom.$hue_input.change(hsv_change);
        local_dom.$saturation_input.change(hsv_change);
        local_dom.$value_input.change(hsv_change);
        local_dom.$cyan_input.change(cmyk_change);
        local_dom.$magenta_input.change(cmyk_change);
        local_dom.$yellow_input.change(cmyk_change);
        local_dom.$black_input.change(cmyk_change);
        local_dom.$hex_input.change(hex_change);

        //  Listen to changes to the selected palette type
        local_dom.$palette_select.change(palette_change);
    }
})(DDH);

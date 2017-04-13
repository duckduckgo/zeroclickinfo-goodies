DDH.css_gradient_generator = DDH.css_gradient_generator || {};

(function(DDH) {
    "use strict";

    var localDom = {
        initialized: false
    };
    
    // Initial gradient parameters
    var params = {
        prefix: getCssPrefix(),        
        type: "linear",
        direction: 50,
        radial_size: "farthest-corner",
        radial_x: 75,
        radial_y: 25,
        colors: [
            {
                id: "color-box-0",
                index: 0,
                point: 10,
                r: 210,
                g: 100,
                b: 110
            },
            {
                id: "color-box-1",
                index: 1,
                point: 60,
                r: 215,
                g: 170,
                b: 135
            },
            {
                id: "color-box-2",
                index: 2,
                point: 100,
                r: 100,
                g: 100,
                b: 115
            }
        ]
    };
     
    
    DDH.css_gradient_generator.build = function(ops) {
        return {
            onShow: function() {
                if (!localDom.initialized) {
                    initializeLocalDom();
                }
            }
        };
    };
    
    
    // Initializes local domain and handles user events
    function initializeLocalDom() {
        localDom = {           
            $linear_type_button: $("#linear-type-btn"),
            $radial_type_button: $("#radial-type-btn"),
            
            $direction_input: $("#direction-input"),
            $direction_output: $("#direction-output"),
            
            $radial_size_dropdown: $("#radial-size-dropdown"),
            $radial_x_position_input: $("#radial-x-position-input"),
            $radial_y_position_input: $("#radial-y-position-input"),
            
            $color_box_arr: document.getElementsByClassName('color-box'),
            
            $new_color_point: $("#new-color-point"),
            $new_color_r: $("#new-color-r"),
            $new_color_g: $("#new-color-g"),
            $new_color_b: $("#new-color-b"),
            $new_color_add_button: $("#new-color-add-btn"),
            
            $selected_color_text: $("#selected-color-text"),
            $selected_point_input: $("#selected-point-input"),
            $selected_r_picker: $("#selected-r-picker"),
            $selected_g_picker: $("#selected-g-picker"),
            $selected_b_picker: $("#selected-b-picker"),
            $selected_delete_button: $("#selected-delete-btn"),
            
            $preview_panel: $("#preview-panel"),
            $output_panel_text: $("#output-panel-text"),
            
            $output_modal: $("#output-modal"),
            $output_modal_close: $("#output-modal-close"),

            activeColorIndex: 0,
            initialized: true
        } 

        // Gradient type selectors
        localDom.$linear_type_button.on("click", function() { typeChange("linear"); });
        localDom.$radial_type_button.on("click", function() { typeChange("radial"); });
        
        // Linear gradient settings change
        localDom.$direction_input.on("input", function() { linearSettingsChange(); });
        
        // Radial gradient settings change
        localDom.$radial_size_dropdown.on("change", function() { radialSettingsChange(); });
        localDom.$radial_x_position_input.on("input", function() { radialSettingsChange(); });
        localDom.$radial_y_position_input.on("input", function() { radialSettingsChange(); });
        
        // Handle form input change
        localDom.$new_color_point.on("input", function() { toggleAddButton() });
        localDom.$new_color_r.on("input", function() { toggleAddButton(); });
        localDom.$new_color_g.on("input", function() { toggleAddButton(); });
        localDom.$new_color_b.on("input", function() { toggleAddButton(); });
        
        // Add new stop color
        localDom.$new_color_add_button.on("click", function() { addColor(); });
        
        // Remove a stop color
        localDom.$selected_delete_button.on("click", function() { deleteColor(); });
        
        // Point picker change
        localDom.$selected_point_input.on("input", function() { pointChange(); });
        
        // RGB picker change
        localDom.$selected_r_picker.on("input", function() { rgbChange(); });
        localDom.$selected_g_picker.on("input", function() { rgbChange(); });
        localDom.$selected_b_picker.on("input", function() { rgbChange(); });
        
        // Modal handlers        
        localDom.$preview_panel.on("click", function() { 
            localDom.$output_modal.addClass("is-showing"); 
        });
        localDom.$output_modal_close.on("click", function() { 
            localDom.$output_modal.removeClass("is-showing"); 
        });
        
        drawColorPanel();
        update();
    } // function initialize_local_dom 

    
    // This function updates all visuals on the IA. Gets called everytime a gradient parameter changes
    function update() {
        // Update color visuals
        var activeColor = params.colors[localDom.activeColorIndex];
        selectColor(activeColor.index);
        drawColorBox(activeColor.id, activeColor.r, activeColor.g, activeColor.b);
                
        // Update gradient visuals
        drawGradient();
    }
    
    
    // Populates color settings panel for the selected color box
    function selectColor(index) {
        var selectedColor = params.colors[index],
            selectedColorStr = toRGBString(selectedColor.r, selectedColor.g, selectedColor.b);
        
        // Add 'selected' class name to the chosen color box to highlight it
        for (var i = 0; i < localDom.$color_box_arr.length; i++) {
            if (index !== i && localDom.$color_box_arr[i].className.match(/(?:^|\s)selected(?!\S)/)) {
                localDom.$color_box_arr[i].className = localDom.$color_box_arr[i].className.replace( /(?:^|\s)selected(?!\S)/g , '' );
            }
            else if (index === i) {
                localDom.$color_box_arr[i].className += ' selected';
            }
        }
        
        localDom.activeColorIndex = index;

        // Update domain elements
        localDom.$selected_point_input.val(selectedColor.point);
        localDom.$selected_r_picker.val(selectedColor.r);
        localDom.$selected_g_picker.val(selectedColor.g);
        localDom.$selected_b_picker.val(selectedColor.b);
                        
        localDom.$selected_color_text.text(selectedColorStr);
        localDom.$selected_color_text.css({
            'color': selectedColorStr, 
            'text-decoration-color': selectedColorStr
        });
    }
    
    
    // Adds a new color object to the global params object based on user input
    function addColor() { 
        // Return if any of the form input is left empty
        if (localDom.$new_color_point.val() === "" || localDom.$new_color_r.val() === "" || 
            localDom.$new_color_g.val() === "" || localDom.$new_color_b.val() === "")
            return;
        
        // New color object takes point and rgb info from the user-filled form
        // Id and index are to be calculated
        var newColorObj = {
            id: "",
            index: 0,
            point: parseInt(localDom.$new_color_point.val()),
            r: parseInt(localDom.$new_color_r.val()),
            g: parseInt(localDom.$new_color_g.val()),
            b: parseInt(localDom.$new_color_b.val())
        }
        var temp = params.colors;
        
        // Push new stop color to the temporary color array, and sort it based on colors' starting points on the color panel
        temp.push(newColorObj);
        
        temp.sort(function(a, b) {
           return parseFloat(a.point) - parseFloat(b.point); 
        });
        
        sortColors(temp); 
        
        // Reset form inputs
        localDom.$new_color_point.val("");
        localDom.$new_color_r.val("");
        localDom.$new_color_g.val("");
        localDom.$new_color_b.val("");
        toggleAddButton();
        toggleDeleteButton();
    }

    
    // Deletes a color box from the color panel
    function deleteColor() {
        if (params.colors.length <= 2)
            return;
        
        var toBeRemoved = localDom.activeColorIndex;
        params.colors.splice(localDom.activeColorIndex, 1);
        selectColor(0);
        
        sortColors(params.colors);
        toggleDeleteButton();
    }
    
    
    // Assigns new indices and ID's to elements of colors array based on their new order
    function sortColors(temp) {
        for (var i = 0; i < temp.length; i++) {
            temp[i].index = i;
            temp[i].id = "color-box-" + parseInt(i);
        }
        
        params.colors = temp;
        
        drawColorPanel();
        update();  
    }
    
    
    // Function to draw new color boxes to the color panel
    function drawColorPanel() {
        var colorPanel = $("#color-panel");
        
        // First remove all color boxes (children of colorPanel)
        colorPanel.html("");
        
        for (var i = 0; i < params.colors.length; i++) {
            var color = params.colors[i];
            
            // Append the color panel with the new color box
            var newColorBox = document.createElement('td');
            newColorBox.setAttribute('id', color.id);
            newColorBox.setAttribute('class', 'color-box');
            
            colorPanel.append(newColorBox);

            drawColorBox(color.id, color.r, color.g, color.b);
        }
        
        // Handles click events on color boxes
        for (var i = 0; i < localDom.$color_box_arr.length; i++) {
            (function(i) {
                localDom.$color_box_arr[i].onclick = function() {
                    selectColor(i);
                }
            })(i);
        }
    }
    
        
    // Redraws a single color box based on given id and rgb values
    function drawColorBox(id, r, g, b) {
        $("#" + id).css("background-color", toRGBString(r, g, b));
    }
    
    
    // This function generates a CSS code based on selected gradient settings
    // Generated gradient code is then used to draw a gradient in the preview panel
    function drawGradient() {
        var gradientParams,
            gradientParams2,
            colorParams = "",
            currentColorRgb = "",
            generatedCSS = "";
        
        if (params.type === "linear") {
            gradientParams = params.direction + "deg, ";
        }
        
        else if (params.type === "radial") {
            gradientParams = params.radial_x + '% ' + params.radial_y + '%, ' + params.radial_size + ', ';
            gradientParams2 = params.radial_size +  ' at ' + params.radial_x + '% ' + params.radial_y + '%, ';
        }
        
        // Generate color part of the gradient string from the colors array in the params object
        for (var i = 0; i < params.colors.length; i++) {
            currentColorRgb = toRGBString(params.colors[i].r, params.colors[i].g, params.colors[i].b);
            if (i !== 0) {
                colorParams += ", ";
            }
            colorParams += currentColorRgb + ' ' + params.colors[i].point + '%';
        }
        
        generatedCSS = 'background: ' + currentColorRgb +';<br>' +
                       'background: -moz-' + params.type + '-gradient(' + gradientParams + colorParams + ');<br>' +
                       'background: -webkit-' + params.type + '-gradient(' + gradientParams + colorParams  + ');<br>' +
                       'background: -o-' + params.type + '-gradient(' + gradientParams + colorParams  + ');<br>' +
                       'background: -ms-' + params.type + '-gradient(' + gradientParams + colorParams  + ');<br>';
        
        // Add default syntax rule -- this is added separately because it is formatted differently in radial gradient type
        // And update preview panel
        if (params.type === "linear") {
            generatedCSS += 'background: ' + params.type + '-gradient(' + gradientParams + colorParams  + ');\n';
            localDom.$preview_panel.css("background-image", params.prefix + 'linear-gradient(' + gradientParams + colorParams + ')');
        }
        
        else if (params.type === "radial") {
            generatedCSS += 'background: ' + params.type + '-gradient(' + gradientParams2 + colorParams  + ');\n';
            localDom.$preview_panel.css("background-image", params.prefix + 'radial-gradient(' + gradientParams + colorParams + ')');
        }
        
        localDom.$output_panel_text.html(generatedCSS);
    }
    
    
    // Handles change in type. Takes either "linear" or "radial" strings as parameter
    function typeChange(type) {
        params.type = type;

        if (type === "linear") {
            localDom.$linear_type_button.addClass("btn--alt");
            localDom.$radial_type_button.removeClass("btn--alt");

            $("#radial-type-settings").css("display", "none");
            $("#linear-type-settings").css("display", "block");
        }
        else if (type === "radial") {
            localDom.$radial_type_button.addClass("btn--alt");
            localDom.$linear_type_button.removeClass("btn--alt");
            
            $("#linear-type-settings").css("display", "none");
            $("#radial-type-settings").css("display", "block");
        }

        update();
    }
    
    
    // Handles changes for linear type gradients (direction)
    function linearSettingsChange() {
        params.direction = localDom.$direction_input.val();
        localDom.$direction_output.val(params.direction);
        update();
    }
    
    
    // Handles changes for radial type gradients (size and position)
    function radialSettingsChange() {
        params.radial_size = localDom.$radial_size_dropdown.val();
        params.radial_x = localDom.$radial_x_position_input.val();
        params.radial_y = localDom.$radial_y_position_input.val();
        
        update();
    }
    
    
    // Toggles 'Add Color' button based on the validity of the new color form
    function toggleAddButton() {
        var addButton = localDom.$new_color_add_button;
        
        if (localDom.$new_color_point.val() !== "" && localDom.$new_color_r.val() !== "" && 
            localDom.$new_color_g.val() !== "" && localDom.$new_color_b.val() !== "") {
            addButton.attr("disabled", false);
        }
        else if (localDom.$new_color_point.val() === "" || localDom.$new_color_r.val() === "" || 
                 localDom.$new_color_g.val()  === "" || localDom.$new_color_b.val() === "") {
            addButton.attr("disabled", true);
        }
    }
    
    
    // Toggles 'Add Color' button based on the number of colors available on color panel
    function toggleDeleteButton() {
        var deleteButton = localDom.$selected_delete_button;
        
        if (params.colors.length > 2) {
            deleteButton.attr("disabled", false);
        }
        else if (params.colors.length <= 2) {
            deleteButton.attr("disabled", true);
        }
    }
    
    
    // Handles changes done on point picker for the selected color
    function pointChange() {
        var point = localDom.$selected_point_input.val();
        params.colors[localDom.activeColorIndex].point = point;
        
        update();
    }

    
    // Handles changes done on RGB pickers for the selected color
    function rgbChange() {
        var r = localDom.$selected_r_picker.val(),
            g = localDom.$selected_g_picker.val(),
            b = localDom.$selected_b_picker.val();

        params.colors[localDom.activeColorIndex].r = r;
        params.colors[localDom.activeColorIndex].g = g;
        params.colors[localDom.activeColorIndex].b = b;
        
        update();
    }
    

    // Helper function that returns the appropriate prefix (e.g. -webkit-, -ms- etc.) for user's browser.
    function getCssPrefix() {
        var result;
        var prefixes = ['-o-', '-ms-', '-moz-', '-webkit-'];

        // Create a temporary DOM object for testing
        var dom = document.createElement('div');

        for (var i = 0; i < prefixes.length; i++)
        {
            // Attempt to set the style
            dom.style.background = prefixes[i] + 'linear-gradient(#000000, #ffffff)';

            // Detect if the style was successfully set
            if (dom.style.background)
            {
                result = prefixes[i];
            }
        }

        dom = null;

        return result;
    }

    
    // Helper function that returns RGB string based on an the color array parameter (i.e. [r, g, b])
    function toRGBString(r, g, b) {
        return 'rgb(' + r + ',' + g + ',' + b + ')';
    }
    
    
    // Helper function that toggles className on/off in a given HTML element
    function toggleClass(element, className){
        if (!element || !className) {
            return;
        }

        var classStr = element.className, 
            index = classStr.indexOf(className);
        
        if (index == -1) {
            classStr += ' ' + className;
        }
        else {
            classStr = classStr.substr(0, index) + classStr.substr(index + className.length);
        }
        
        element.className = classStr;
    }
    
})(DDH);

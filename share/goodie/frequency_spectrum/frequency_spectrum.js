DDH.frequency_spectrum = DDH.frequency_spectrum || {};

(function(DDH) {
    "use strict";
    // Get the marker label and tag
    var markerlabel, markertag, started;
    
    function start() {
        markerlabel = document.getElementById("marker_label");
        markertag = document.getElementById("marker_tag");

        // Firefox (and possbily other browers) have a problem with the
        // getBBox function. For now, I'll work around this by simply
        // hiding the marker tag if getBBox() is not available.
        try { 
            // Resize marker to fit text
            bbox = markerlabel.getBBox();
            markerlabel.setAttribute("x", bbox.x);
            markertag.setAttribute("x", bbox.x - (bbox.width / 2));
            markertag.setAttribute("y", bbox.y + 1);
            markertag.setAttribute("width", bbox.width);
            markertag.setAttribute("height", bbox.height);

            // If the marker tag is wider than the window - 80 px, hide it
            if (bbox.width > (wwidth - 80)) {
                markerlabel.style.visibility = "hidden";
                markertag.style.visibility = "hidden";
            }

        // If getBBox() not available, hide the tag and label
        } catch(err) {
            markerlabel.style.visibility = "hidden";
            markertag.style.visibility = "hidden";
        }
    
        // When window is too small, remove marker label and tag
        // and abbreviate major range (y-axis) labels
        var wwidth, majrangelabels;
        wwidth = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
        majrangelabels = document.getElementsByClassName("major_range_label");
        if (wwidth < 500) {
            // Marker tag and label
            markerlabel.style.visibility = "hidden";
            markertag.style.visibility = "hidden";
            
            var obj = { "Radio" : "Rad.", "Infrared" : "Inf.", "Visible light" : "Vis.", "Ultraviolet" : "UV", "X-ray" : "X-ray", "Gamma" : "Gam." };
            // Major range labels
            for (var i = majrangelabels.length - 1; i >= 0; i--) {
                majrangelabels[i].childNodes[1].childNodes[0].textContent = obj[ scheme[majrangelabels[i].childNodes[1].childNodes[0].textContent] ];
            }
        }
    }
    DDH.frequency_spectrum.build = function(ops) {
    
        return {
            onShow: function() {

                if (!started) {
                    started = true;
                
                    start();

                }
            }
        };
    };
})(DDH);

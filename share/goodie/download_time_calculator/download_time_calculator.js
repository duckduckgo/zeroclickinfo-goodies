DDH.download_time_calculator = DDH.download_time_calculator || {};

(function(DDH) {
    "use strict";

    var initialized = false;
    var $dom, $inputs, $dl_data, $dl_speed, $time, $select_data, $select_speed;
    
    var dataUnits = [
        { symbol: 1,         name: 'Bit' },
        { symbol: 8,         name: 'Byte' },
        { symbol: 1e3,       name: 'Kilobit' },
        { symbol: 1e6,       name: 'Megabit' },
        { symbol: 1e9,       name: 'Gigabit' },
        { symbol: 1e12,      name: 'Terrabit' },
        { symbol: 8e3,       name: 'Kilobyte' },
        { symbol: 8e6,       name: 'Megabyte' },
        { symbol: 8e9,       name: 'Gigabyte' },
        { symbol: 8e12,      name: 'Terabyte' }
    ];
    
    var speedUnits = [
        { symbol: 1,         name: 'Bits per second'},
        { symbol: 1e3,       name: 'Kilobit per second'},
        { symbol: 1e6,       name: 'Megabit per second'},
        { symbol: 1e9,       name: 'Gigabit per second'},
        { symbol: 1e12,      name: 'Terabit per second'},
        { symbol: 8e3,       name: 'Kilobyte per second'},
        { symbol: 8e6,       name: 'Megabyte per second'},
        { symbol: 8e9,       name: 'Gigabyte per second'}
    ];
        
    /*
     * setUpSelectors
     *
     * Sets up the jQuery selectors when the IA is built
     */
    function setUpSelectors() {
        $dom = $(".zci--download_time_calculator");

        // the inputs
        $inputs = $dom.find('input');
        $dl_data = $dom.find("#dl_data");
        $dl_speed = $dom.find("#dl_speed");
        $select_data = $dom.find(".frm__select--data");
        $select_speed = $dom.find(".frm__select--speed");

        // the display label
        $time = $dom.find("#time");
    }
    
    /*
     * setUpUnits
     *
     * Sets up the units when IA is initialized
     */
    function setUpUnits() {
        for(var i = 0 ; i < dataUnits.length ; i++) {
            $select_data.append(
                '<option value="' + dataUnits[i].symbol + '">'
                + dataUnits[i].name
                + '</option>'
            );
        }
        
        for(var i = 0 ; i < speedUnits.length ; i++) {
            $select_speed.append(
                '<option value="' + speedUnits[i].symbol + '">'
                + speedUnits[i].name
                + '</option>'
            );
        }
    }

    /**
     * calculateTime
     *
     * Calculates the time and sets the display
     */
    function calculateTime() {
        var dl_data = $dl_data.val();
        var dl_speed = $dl_speed.val();

        if(dl_data === "") {
            dl_data = 0;
        }
        
        dl_data *= $select_data.val();
        dl_speed *= $select_speed.val();
        
        var time = dl_data/dl_speed;
        var result = "";
        
        if(time >= 3600)
        {
            result += Math.floor(time/3600);
            if(time >= 7200) result += " hours, ";
            else result += " hour, ";
            time %= 3600;
        }
        if(time >= 60)
        {
            result += Math.floor(time/60);
            if(time >= 120) result += " minutes, ";
            else result += " minute, ";
            time %= 60;
        }
        if(time >= 1)
        {
            result += Math.floor(time);
            if(time >= 2) result += " seconds, ";
            else result += " second, ";
        }
        
        $time.text(result.slice(0, -2));
    }

    DDH.download_time_calculator.build = function(ops) {
        
        // seed the calculator with some values
        var init_data = ops.data.data || "100";
        var init_speed = ops.data.speed || "20";
        var init_dataUnit = ops.data.dataUnit || 8e6;
        var init_speedUnit = ops.data.speedUnit || 1e6;

        return {
            onShow: function() {

                if(!initialized) {
                    setUpSelectors();
                    setUpUnits();
                    $dl_data.val(init_data);
                    $dl_speed.val(init_speed);
                    $select_data.val(init_dataUnit);
                    $select_speed.val(init_speedUnit);
                    calculateTime()
                }

                /**
                 * Event handlers to update the values when
                 * keys are pressed
                 */
                $inputs.bind('keyup click change mousewheel', function(_e) {
                    calculateTime()
                });
                
                $select_data.change(function() {
                    calculateTime()
                });
                
                $select_speed.change(function() {
                    calculateTime()
                });

                initialized = true;
            }

        };
    };
})(DDH);
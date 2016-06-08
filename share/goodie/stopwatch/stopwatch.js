DDH.stopwatch = DDH.stopwatch || {};

DDH.stopwatch.build = function(ops) {
    function stopwatchBuildOnce(){
        var running = false,
            start_time = null,
            last_lap = null,
            interval_id = null,
            lap_num = 1,
            old_time = 0,
            $total_time = $('#total_time'),
            $current_time = $('#current_time'),
            $split_list = $('#split_list'),
            $lap_btn = $('#lap_btn'),
            $reset_btn = $('#reset_btn');

        //add zeros to the end of the number
        function padZeros(n, len){
            var s = n.toString();
            while (s.length < len){
                s = '0' + s;
            }
            return s;
        }

        //go from a time in ms to human-readable
        function formatTime(t){
            // var hrs = Math.floor(t / (1000*60*60));
            // t = t % (1000*60*60);
            var mins = Math.floor(t / (1000*60));
            t = t % (1000*60);
            var secs = Math.floor(t / 1000);
            t = padZeros((t % 1000).toString(), 3).substring(0, 2);
            return padZeros(mins, 2) + ":" + padZeros(secs, 2) + '.' + t;
        }

        //called on every interval
        function updateStopwatch(){
            var t = new Date().getTime() - start_time + old_time;
            $total_time.html(formatTime(t));
            $current_time.html(formatTime(t-last_lap))
            return t;
        }

        //trigger for lap button (extracted so the stop button trigger can access it)
        function addLap(){
            if (!running) return;
            var current_time = updateStopwatch();
            var current_lap = current_time - last_lap;
            $split_list.prepend('<tr><td class="lap-num">' + lap_num + '</td><td class="lap-time lap-total">' +
                $total_time.html() + '</td><td class="lap-time">' + formatTime(current_lap) + '</td></tr>');
            $split_list.removeClass('is-hidden');
            last_lap = current_time;
            lap_num++;
            return current_time;
        }

        //when we click the start button, we save the time we started and start updating it
        $('.btn-wrapper').on('click', '.stopwatch__btn.start', function(){
            if (running) return;
            running = true;
            start_time = new Date().getTime();
            if (!last_lap) last_lap = 0;
            interval_id = setInterval(updateStopwatch, 10);

            $(this).html('STOP').removeClass('start').addClass('stop');
            $reset_btn.prop('disabled', false);
            $lap_btn.prop('disabled', false);
        });

        //stop the stopwatch and save the time in case we start it again
        $('.btn-wrapper').on('click', '.stopwatch__btn.stop', function(){
            if (!running) return;
            //add a lap (useful for people who want to stop and get a split at the same time)
            old_time = addLap();
            running = false;
            clearInterval(interval_id);

            $(this).html('START').removeClass('stop').addClass('start');
            $reset_btn.prop('disabled', false);
            $lap_btn.prop('disabled', true);
        });

        //reset everything
        $reset_btn.click(function(){
            running = false;
            old_time = 0;
            last_lap = null;
            lap_num = 1;
            $total_time.html(formatTime(0));
            $current_time.html(formatTime(0));
            $split_list.find('tbody').children().remove();
            clearInterval(interval_id);

            $('.stopwatch__btn.stop').removeClass('stop').addClass('start').html('START');
            $(this).prop('disabled', true);
            $lap_btn.prop('disabled', true);
            $split_list.addClass('is-hidden');
        });

        //add a split (the time that was on the watch) and lap (time between laps)
        $lap_btn.click(addLap);
    }

    var firstStopwatchRun = false;

    return {
        onShow: function(){
            // Wait for the goodie to load before displaying things
            // This makes sure the divs display at the right time so the layout doesn't break
            $(".zci--stopwatch .goodie-pane-right").css("display", "inline-block");
            $(".zci--stopwatch .stopwatch__left").css("display", "inline");
            if (!firstStopwatchRun){
                firstStopwatchRun = true;
                stopwatchBuildOnce();
            }
        }
    }
}

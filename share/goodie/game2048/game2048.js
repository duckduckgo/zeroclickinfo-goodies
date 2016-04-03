DDH.game2048 = DDH.game2048 || {};

DDH.game2048.build = function(ops) {
    // Global Variables Declaration
    var $tempArea, $container, $spanPoints, $pointsCounter, $newGame, $result_box, WINNUM, SIZE, TILE_COUNT;

    var lost_or_won = false,
        started,
        area,
        cells,
        score = 0;

    function rc_to_index(row, col) {
        return row * SIZE + col;
    }

    //This function moves and sums numbers
    function mov(dir) {
        var points = 0;

        if (dir === 'w' || dir === 's')
            transpose_area();
        if (dir === 'd' || dir === 's')
            swap_cols_area();
    
        var result = handle_move();

        if (dir === 'd' || dir === 's')
            swap_cols_area();
        if (dir === 'w' || dir === 's')
            transpose_area();

        increase_points(result.points);

        return result.moved;
    }

    function handle_move() {
        var result = {'moved': false, 'points': false};

        var moves = 0;

        for(var i = 0; i < TILE_COUNT; ++i) {
            var row = Math.floor(i / SIZE),
                col = i % SIZE,
                moves = col === 0 ? 0 : moves;

            if (area[i].val === 0) {
                ++moves;
                continue;
            } 

            if(moves > 0) {
                area[rc_to_index(row, col - moves)].val = area[i].val;
                area[i].val = 0;
                result.moved = true;
            }

            for(var j = col + 1; j < SIZE; ++j) {
                var index_a = rc_to_index(row, col - moves);
                var index_b = rc_to_index(row, j);

                if(area[index_b].val !== area[index_b].val)
                    break;

                if(area[index_a].val === area[index_b].val) { 
                    //merge same tiles
                    area[index_a].val *= 2;
                    area[index_b].val = 0;

                    result.points = area[index_a].val;
                    result.moved = true;
                    break;
                }
            }
        }

        return result;
    }

    // Updates the 'points' div
    function increase_points(points) {
        score += points;
        if (points > 0){
            var addition = "<div class='score-addition'>+" + points + "</div>";
            $pointsCounter.html(addition);
        }
        $spanPoints.text(score);
    }

    //Update the board
    function print_area() {
        cells.each(function(index) {
            var val = area[index].val;

            if(val === 0)
                $(this).html("").attr("class", "boxtile val-");
            else
                $(this).html(val).attr("class", "boxtile val-" + val);
        });
    }

    // 'area' initialization
    function init_area() {
        area = [];
        cells.each(function(index) {
            var row = Math.floor(index / SIZE);
            var col = index % SIZE;

            area[index] = {
                pos: { 'row': row, 'col': col },
                prev_pos: { 'row': -1, 'col': -1 },
                val: 0
            };
        });
    }

    function transpose_area() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            if(area[i].pos.col >= area[i].pos.row) 
                continue;

            var index_to_swap = area[i].pos.col * SIZE + area[i].pos.row;
            var tmp_val = area[i].val;
            area[i].val = area[index_to_swap].val;
            area[index_to_swap].val = tmp_val;
        }
    }

    function swap_cols_area() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            if(i % SIZE >= (SIZE / 2))
                continue;

            var row = area[i].pos.row,
                col = area[i].pos.col;

            var index_to_swap = rc_to_index(row, SIZE - 1 - col);
            var tmp_val = area[i].val;

            area[i].val = area[index_to_swap].val;
            area[index_to_swap].val = tmp_val;
        }
    }


    //4 has a 10% chance of being chosen
    function add_random_tile() {
        var free = [];
        for(var i = 0; i < TILE_COUNT; ++i) {
            if(area[i].val === 0) {
                free.push(i);
            }
        } 

        var rand_tile = free[Math.floor(Math.random() * free.length)];
        var rand_val = Math.floor(Math.random() * 11);
        rand_val = rand_val < 2 ? 4 : 2;
        area[rand_tile].val = rand_val;
    }

    //If there is the winning number inside the table, returns true and
    //prints a congratulation message
    function has_won() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            if (area[i].val == WINNUM) {
                game_over_message(true);
                return true;
            }
        }
        return false;
    }

    function has_lost() {
        var full_tiles_count = 0,
            move_possible = false;

        for(var i = 0; i < TILE_COUNT; ++i) {
            if (area[i].val > 0)
                ++full_tiles_count;

            var row = area[i].pos.row;
            var col = area[i].pos.col;

            // check all available movements
            if ((row !== 0 && area[i].val === area[rc_to_index(row - 1, col)].val) ||
                (row !== SIZE - 1 && area[i].val === area[rc_to_index(row + 1, col)].val) ||
                (col !== 0 && area[i].val === area[rc_to_index(row, col - 1)].val) ||
                (col !== SIZE - 1 && area[i].val === area[rc_to_index(row, col + 1)].val)) {
                move_possible = true;
            }
        }

        if (full_tiles_count === TILE_COUNT && !move_possible) {
            game_over_message(false);
            return true;
        }

        return false;
    }

    // This function shows game over message
    function game_over_message(game_won) {
        var result_msg = $('#game2048__area .game2048__message p');
        if (game_won == true) {
            result_msg.text("You Won!");
            $result_box.addClass("game2048__won");
        } else {
            result_msg.text("You Lost!");
            $result_box.removeClass("game2048__won");
        }
        $result_box.show();
    }

    // This function reset game_area, points, result
    function start() {
        increase_points(-score);    // Set to 0
        lost_or_won = false;        // New game
        $result_box.hide();         // Hide previous result
        $tempArea.focus();          // Focus on game by default
        init_area();
        add_random_tile();
        print_area();
    }

    return {
        onShow: function() {

        //'started' is a boolean variable used in order to avoid the
        //duplication of the gaming area. Moving around the DDG tabs the
        //'onShow' function is executed over and over. This simple solution
        //prevents the problem
        if (!started) {
            started = true;

            $container = $('#game2048__container');
            $spanPoints = $('.game2048__points');
            $pointsCounter = $('.game2048__points_addition');
            $tempArea = $('#game2048__area');
            $newGame = $(".zci--game2048 .game2048__new_game");
            $result_box = $('#game2048__area .game2048__message');
            WINNUM = 2048;
            SIZE = 4;
            TILE_COUNT = SIZE * SIZE;
            cells = $('.game2048__row .boxtile.val-');
            start();

            $tempArea.keydown(function(e) {
                e.preventDefault();

                var moved = false;
                if (!lost_or_won) {
                    if (e.keyCode === 87 || e.keyCode === 38) { // w or up arrow
                        moved = mov('w');
                    } else if (e.keyCode === 65 || e.keyCode === 37) { // a or left arrow
                        moved = mov('a');
                    } else if (e.keyCode === 83 || e.keyCode === 40) { // s or dowm arrow
                        moved = mov('s');
                    } else if (e.keyCode === 68 || e.keyCode === 39) { // d or right arrow
                        moved = mov('d');
                    }

                    if (moved) {
                        add_random_tile();
                        if (has_won() || has_lost()) {
                            lost_or_won = true;
                        }
                    }
                    print_area();
                }
                return false;
            });

            $newGame.on("click", function(e){
                e.preventDefault();
                start();
            });
        }
        }
    };
};

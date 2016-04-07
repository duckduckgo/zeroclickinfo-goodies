DDH.game2048 = DDH.game2048 || {};

DDH.game2048.build = function(ops) {
    // Global Variables Declaration
    var WINNUM = 2048,
        SIZE = 4,
        TILE_COUNT = SIZE * SIZE,
        started = false, 
        tiles = init_area(),
        score = 0;

    function rc_to_index(row, col) {
        return row * SIZE + col;
    }

    function index_to_rc(index) {
        return { 'row' : Math.floor(index / SIZE), 'col' : index % SIZE };
    }

    //This function moves and sums numbers
    function move(dir) {
        var points = 0;
        var transposed = false;
        var swapped =  false;

        if (dir === 'w' || dir === 's') {
            transpose_area();
            transposed = true;
        }
        if (dir === 'd' || dir === 's') {
            swap_cols_area();
            swapped = true;
        }
    
        var result = handle_move(transposed, swapped);

        if (dir === 'd' || dir === 's')
            swap_cols_area();
        if (dir === 'w' || dir === 's')
            transpose_area();

        increase_points(result.points);

        return result.moved;
    }

    function handle_move(transposed, swapped) {
        var result = {'moved': false, 'points': false};

        var moves = 0;

        for(var i = 0; i < TILE_COUNT; ++i) {
            var row = Math.floor(i / SIZE),
                col = i % SIZE;
            moves = col === 0 ? 0 : moves;

            if (tiles[i].val === 0) {
                ++moves;
                continue;
            } 

            //Move across empty tiles
            if(moves > 0) {
                var temp_tile = tiles[rc_to_index(row, col - moves)];
                temp_tile.val = 0;

                tiles[rc_to_index(row, col - moves)] = tiles[i];
                tiles[i] = temp_tile;

                result.moved = true;
            }

            //Find and merge two matching tiles
            for(var j = col + 1; j < SIZE; ++j) {
                var tile_a = tiles[rc_to_index(row, col - moves)];
                var tile_b = tiles[rc_to_index(row, j)];

                if(tile_b.val === 0)
                    continue;

                if(tile_a.val === tile_b.val) { 
                    merge(tile_a, tile_b, row, col - moves, transposed, swapped);

                    result.points = tile_a.val;
                    result.moved = true;
                }
                break;
            }
        }

        return result;
    }

    function gen_translate_string(row, col) {
        return "translate(" + (col * 85 + 5) + "px," + row * 85 + "px)";
    }

    //Row and col indicate the place where the animation should end
    function merge(tile_a, tile_b, row, col, transposed, swapped) {
        tile_a.val += tile_b.val;
        tile_b.val = 0;

        //Recalculate the real world pos
        if(swapped) 
            col = SIZE - 1 - col;

        if(transposed) {
            var tmp = col;
            col = row;
            row = tmp;
        } 

        var translate_string = gen_translate_string(row, col);

        tile_b.div.css({ "-ms-transform" : translate_string,
                        "-webkit-transform" : translate_string,
                        "transform" : translate_string,
                        "opacity" : 0.00 }); 

        tile_b.div.on("transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", function () {
            this.remove();
        });
    }

    // Updates the 'points' div
    function increase_points(points) {
        score += points;
        if (points > 0){
            var addition = "<div class='score-addition'>+" + points + "</div>";
            $('.game2048__points_addition').html(addition);
        }

        $('.game2048__points').text(score);
    }

    //Update the board
    function update_tiles() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            var pos = index_to_rc(i);
            var tile = tiles[i];
            
            if("undefined" !== typeof(tile.div)) {
                var translate_string = gen_translate_string(pos.row, pos.col);

                if(tile.val > 0)
                    tile.div
                        .html(tile.val)
                        .attr("class", "boxtile val-" + tile.val)
                        .css({ "-ms-transform" : translate_string,
                            "-webkit-transform" : translate_string,
                            "transform" : translate_string }); 
            }
        }
    }

    // 'area' initialization
    function init_area() {
        var tiles = [TILE_COUNT];

        for(var i = 0; i < TILE_COUNT; ++i) {
            tiles[i] = {
                val: 0
            };
        }

        return tiles;
    }

    function transpose_area() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            var pos = index_to_rc(i);

            if(pos.col >= pos.row) 
                continue;

            var index_to_swap = pos.col * SIZE + pos.row;
            var tmp_tile = tiles[i];
            tiles[i] = tiles[index_to_swap];
            tiles[index_to_swap] = tmp_tile;
        }
    }

    function swap_cols_area() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            var pos = index_to_rc(i);

            if(i % SIZE >= (SIZE / 2))
                continue;

            var index_to_swap = rc_to_index(pos.row, SIZE - 1 - pos.col);
            var tmp_tile = tiles[i];

            tiles[i] = tiles[index_to_swap];
            tiles[index_to_swap] = tmp_tile;
        }
    }

    //4 has a 10% chance of being chosen
    function add_random_tile() {
        var unused_tiles = [];
        for(var i = 0; i < TILE_COUNT; ++i) {
            if(tiles[i].val === 0) {
                unused_tiles.push(i);
            }
        } 

        var rand_tile = unused_tiles[Math.floor(Math.random() * unused_tiles.length)];
        var rand_val = Math.floor(Math.random() * 11) < 2 ? 4 : 2;

        tiles[rand_tile].div = create_tile_div();
        tiles[rand_tile].val = rand_val;
    }

    function create_tile_div() {
        var div = $("<div class=\"boxtile val-\"></div>");
        $("#game2048__area_container").append(div);
        return div;
    }

    //If there is the winning number inside the table, returns true and
    //prints a congratulation message
    function has_won() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            if (tiles[i].val == WINNUM) {
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
            if (tiles[i].val > 0)
                ++full_tiles_count;

            var pos = index_to_rc(i);

            var row = pos.row;
            var col = pos.col;

            // check all available movements
            if ((row !== 0 && tiles[i].val === tiles[rc_to_index(row - 1, col)].val) ||
                (row !== SIZE - 1 && tiles[i].val === tiles[rc_to_index(row + 1, col)].val) ||
                (col !== 0 && tiles[i].val === tiles[rc_to_index(row, col - 1)].val) ||
                (col !== SIZE - 1 && tiles[i].val === tiles[rc_to_index(row, col + 1)].val)) {
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
        var result_box = $('#game2048__area .game2048__message');
        if (game_won == true) {
            result_msg.text("You Won!");
            result_box.addClass("game2048__won");
        } else {
            result_msg.text("You Lost!");
            result_box.removeClass("game2048__won");
        }
        result_box.show();
    }

    // This function reset game_area, points, result
    function init_game() {
        var game_area = $('#game2048__area');
        var game_area_container = $('#game2048__area_container');
        var result_box = $('#game2048__area .game2048__message');

        increase_points(-score);
        game_over = false;
        result_box.hide();
        game_area.focus();
        game_area_container.children(".boxtile").remove();
        tiles = init_area();
        add_random_tile();
        update_tiles();
    }

    return {
        onShow: function() {

        //Hide this goodie on mobile devices for now
        if(is_mobile || is_mobile_device) {
            DDH.spice_tabs.game2048.hideLink();
            DDH.spice_tabs.game2048.hide();
            return;
        }

        //'started' is a boolean variable used in order to avoid the
        //duplication of the gaming tiles. Moving around the DDG tabs the
        //'onShow' function is executed over and over. This simple solution
        //prevents the problem
        if (!started) {
            started = true;
        
            var game_over = false;
            var game_area = $('#game2048__area');

            init_game();

            game_area.keydown(function(e) {
                e.preventDefault();

                var move_made = false;
                if (!game_over) {
                    if (e.keyCode === 87 || e.keyCode === 38) { // w or up arrow
                        move_made = move('w');
                    } else if (e.keyCode === 65 || e.keyCode === 37) { // a or left arrow
                        move_made = move('a');
                    } else if (e.keyCode === 83 || e.keyCode === 40) { // s or dowm arrow
                        move_made = move('s');
                    } else if (e.keyCode === 68 || e.keyCode === 39) { // d or right arrow
                        move_made = move('d');
                    }

                    if (move_made) {
                        add_random_tile();
                        game_over = has_won() || has_lost();
                        update_tiles();
                    }
                }
                return false;
            });

            var new_game_button = $(".zci--game2048 .game2048__new_game");
            new_game_button.on("click", function(e) {
                e.preventDefault();
                init_game();
            });
            }
        }
    };
};

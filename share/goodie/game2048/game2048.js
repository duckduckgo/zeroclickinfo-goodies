DDH.game2048 = DDH.game2048 || {};

DDH.game2048.build = function(ops) {
    "use strict";

    //Hide this goodie on mobile devices for now
    if (DDG.device.isMobile || DDG.device.isMobileDevice) {
        return DDH.failed('game2048');
    }

    // Global Variables Declaration
    var WINNUM = 2048,
        SIZE = 4,
        TILE_COUNT = SIZE * SIZE,
        started = false,
        tiles = init_area(),
        $game_area,
        $game_area_container,
        $game_points,
        $game_points_addition,
        $result_msg,
        $result_box,
        score = 0;

    function rc_to_index(row, col) {
        return row * SIZE + col;
    }

    function index_to_rc(index) {
        return { 'row' : Math.floor(index / SIZE), 'col' : index % SIZE };
    }

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

        if(result.points > 0)
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
        return "translate(" + (col * 85 + 5) + "px," + (row * 85 + 5) + "px)";
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

        tile_b.tile_div.css({ "-ms-transform" : translate_string,
                        "-webkit-transform" : translate_string,
                        "transform" : translate_string,
                        "opacity" : 0.00 });

        tile_b.tile_div.on("transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", function () {
            $(this).remove();
        });
    }

    // Updates the 'points' div
    function increase_points(points) {
        score += points;
        var addition = $("<div>").addClass("score-addition").text(points);

        $game_points.text(score);
        $game_points_addition.html(addition);
    }

    function reset_points() {
        score = 0;
        $game_points.text(0);
    }

    //Update the board
    function update_tiles() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            var pos = index_to_rc(i);
            var tile = tiles[i];

            if("undefined" !== typeof(tile.tile_div) && tile.val > 0) {
                var translate_string = gen_translate_string(pos.row, pos.col);
                tile.tile_div
                    .html(tile.val)
                    .addClass("boxtile val-" + tile.val)
                    .css({
                        "-ms-transform" : translate_string,
                        "-webkit-transform" : translate_string,
                        "transform" : translate_string,
                        "display" : "block"
                    });
            }
        }
    }

    function init_area() {
        var tiles = [TILE_COUNT];

        for(var i = 0; i < TILE_COUNT; ++i) {
            tiles[i] = { val: 0 };
        }

        return tiles;
    }

    function swap_tiles(a, b) {
        var tmp = tiles[a];
        tiles[a] = tiles[b];
        tiles[b] = tmp;
    }

    function transpose_area() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            var pos = index_to_rc(i);

            if(pos.col >= pos.row)
                continue;

            var index_to_swap = rc_to_index(pos.col, pos.row);
            swap_tiles(i, index_to_swap);
        }
    }

    function swap_cols_area() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            var pos = index_to_rc(i);

            if(pos.col >= SIZE / 2)
                continue;

            var index_to_swap = rc_to_index(pos.row, SIZE - 1 - pos.col);
            swap_tiles(i, index_to_swap);
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

        tiles[rand_tile].tile_div = create_tile_div();
        tiles[rand_tile].val = rand_val;
    }

    function create_tile_div() {
        //Hide the div initially as a workaround for funky IE9 animations
        var tile_div = $("<div>").hide();
        $game_area_container.append(tile_div);
        return tile_div;
    }

    function has_won() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            if (tiles[i].val === WINNUM) {
                game_over_message(true);
                return true;
            }
        }
        return false;
    }

    function has_lost() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            if (tiles[i].val === 0)
                return false;

            var pos = index_to_rc(i);

            // check all possible movements
            if ((pos.row !== 0 && tiles[i].val === tiles[i - SIZE].val) ||
                (pos.row !== SIZE - 1 && tiles[i].val === tiles[i + SIZE].val) ||
                (pos.col !== 0 && tiles[i].val === tiles[i - 1].val) ||
                (pos.col !== SIZE - 1 && tiles[i].val === tiles[i + 1].val)) {
                return false;
            }
        }

        game_over_message(false);
        return true;
    }

    function is_game_over() {
        return has_won() || has_lost();
    }

    function game_over_message(game_won) {
        if (game_won) {
            $result_msg.text("You Won!");
            $result_box.addClass("game2048__won");
        } else {
            $result_msg.text("You Lost!");
            $result_box.removeClass("game2048__won");
        }
        $result_box.show();
    }

    function init_game() {
        reset_points();
        $result_box.hide();

        //Clear displayed board
        $game_area_container.children(".boxtile").remove();
        $game_area.focus();

        //Clear internal tile administration
        tiles = init_area();

        //Start over
        add_random_tile();
        update_tiles();
    }

    function handle_buttons(e) {
        e.preventDefault();

        var move_made = false;

        if (is_game_over())
            return false;

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
            update_tiles();
        }
        return false;
    }

    return {
        onShow: function() {

            //'started' is a boolean variable used in order to avoid the
            //duplication of the gaming tiles. Moving around the DDG tabs the
            //'onShow' function is executed over and over. This simple solution
            //prevents the problem
            if (started)
                return;

            started = true;
            $game_area = $('#game2048__area');
            $game_area_container = $("#game2048__area_container");
            $game_points = $('.game2048__points');
            $game_points_addition = $('.game2048__points_addition');
            $result_msg = $('#game2048__area_container .game2048__message p');
            $result_box = $('#game2048__area_container .game2048__message');
            var $new_game_button = $(".zci--game2048 .game2048__new_game")

            $game_area.keydown(handle_buttons);

            init_game();

            //Register new game button listener
            $new_game_button.on("click", function(e) {
                e.preventDefault();
                init_game();
            });
        }
    };
};

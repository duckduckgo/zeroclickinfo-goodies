DDH.game2048 = DDH.game2048 || {};

DDH.game2048.build = function(ops) {
    // Global Variables Declaration
    var $tempArea, $container, $spanPoints, WINNUM, SIZE, TILE_COUNT;

    var continueGame = true,
        started = false,
        area,
        cells,
        score = 0;

    function rc_to_index(row, col) {
        return row * SIZE + col;
    }

    //This function moves and sums numbers
    function mov(dir) {
        var points = 0,
            flag = false;

        if (dir === 'a' || dir === 'd') {
            transpose_area();
        } 
        if (dir === 's' || dir === 'd') {
            swap_rows_area();
        }

        for (var col = 0; col < SIZE; ++col) {
            var moves = 0;

            for (var row = 0; row < SIZE; ++row) {
            var i = rc_to_index(row, col);
            var exit = false;

                if (area[i].val === 0) {
                    ++moves;
                } else {
                    // if a move can be made
                    if(moves > 0) {
                        area[rc_to_index(row - moves, col)].val = area[i].val;
                        area[i].val = 0;
                        flag = true;
                    }

                    for(var j = row + 1; j < SIZE && exit === false; ++j) {
                        // if numbers can be summed
                        if(area[rc_to_index(row - moves, col)].val === area[rc_to_index(j, col)].val) { 
                            // sum numbers
                            area[rc_to_index(row - moves, col)].val *= 2;
                            // delete the old number
                            area[rc_to_index(j, col)].val = 0;
                            // add points
                            points = area[rc_to_index(row - moves, col)].val;
                            flag = true; exit = true;
                        // else quit the while loop
                        } else if(area[rc_to_index(j, col)].val !== 0) {
                            exit = true;
                        }
                    }
                }
            }
        }

        if (dir === 's' || dir === 'd') {
            swap_rows_area();
        }
        if (dir === 'a' || dir === 'd') {
            transpose_area();
        }

        increase_points(points);

        if (has_won() /*|| has_lost()*/) {
            continueGame = false;
            flag = false;
        }

        //This check is mandatory in order to avoid the appearance of a new
        //value in the area if no moves has been made
        return flag;
    }

    // Updates the 'points' div
    function increase_points(points) {
        score += points;
        $spanPoints.text(score);
    }

    //After every little table's change, the area is updated.
    //This function changes the cell class too
    function print_area() {
        cells.each(function(index) {
            var val = area[index].val;
            if(val === 0) {
                $(this).html("").attr("class", "boxtile val-");
            } else {
                $(this).html(val).attr("class", "boxtile val-" + val);
            }
        });
    }

    // 'area' initialization
    function init_area() {
        area = [];
        cells.each(function(index) {
            area[index] = {
                row: Math.floor(index / SIZE),
                col: index % SIZE,
                val: 0
            };
        });
    }

    // left and right moves activate this function
    function transpose_area() {
        for(var i = 0; i < TILE_COUNT; ++i) {
            if(area[i].col >= area[i].row) continue;
            var index_to_swap = area[i].col * SIZE + area[i].row;
            var tmp_val = area[i].val;
            area[i].val = area[index_to_swap].val;
            area[index_to_swap].val = tmp_val;
        }
    }

    // down and right moves activate this function
    function swap_rows_area() {
        for(var i = 0; i < TILE_COUNT / 2; ++i) {
            var row = area[i].row,
                col = area[i].col;
            var index_to_swap = rc_to_index(SIZE - 1 - row, col);
            var tmp_val = area[i].val;
            area[i].val = area[index_to_swap].val;
            area[index_to_swap].val = tmp_val;
        }
    }


    //This function set a random number ( 2 or 4 ) in a random
    //position around the area. 4 has a 10% chance of being chosen.
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
            console.log(area[i].val + " " + WINNUM);
            if (area[i].val == WINNUM) {
                alert("You win");
                //area[0][0] = 'Y'; area[0][1] = 'O'; area[0][2] = 'U';
                //area[SIZE-1][0] = 'W'; area[SIZE-1][1] = 'I'; area[SIZE-1][2] = 'N';
                return true;
            }
        }
        return false;
    }

    // If no moves or sums are possible, return true
    function has_lost() {
        var full_tiles_count = 0,
            move_possible = false;

        for(var i = 0; i < TILE_COUNT; ++i) {
            if (area[i].val !== 0) {
                ++full_tiles_count;
            }

            var row = area[i].row;
            var col = area[i].col;
            // check all available movements
            if ((row !== 0 && area[i].val === area[rc_to_index(row - 1, col)].val) ||
                (row !== SIZE-1 && area[i].val === area[rc_to_index(row + 1, col)].val) ||
                (col !== 0 && area[i].val === area[rc_to_index(row, col - 1)].val) ||
                (col !== SIZE-1 && area[i].val === area[rc_to_index(row, col + 1)].val)) {
                move_possible = true;
            }
        }
        // if all the cells all full AND no movements are available, return true
        if (full_tiles_count === TILE_COUNT - 1 && move_possible === false) {
            //area[0][0] = 'Y'; area[0][1] = 'O'; area[0][2] = 'U';
            //area[SIZE-1][0] = 'L'; area[SIZE-1][1] = 'O'; area[SIZE-1][2] = 'S'; area[SIZE-1][3] = 'E';
            //printArea();
            alert("You lost");
            return true;
        }

        return false;
    }


    // This function creates and prints on page the gaming table
    function start() {
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
                $tempArea = $('#game2048__area');
                WINNUM = ops.data[0].inputNum;
                SIZE = ops.data[0].dimension;
                TILE_COUNT = SIZE * SIZE;
                cells = $('td.boxtile.val-');
                start();
                $('html').keydown(function(event){
                    var move = false;
                    if (continueGame) {
                        if (event.keyCode === 87 || event.keyCode === 38) { // w or up arrow
                            move = mov('w');
                        } else if (event.keyCode === 65 || event.keyCode === 37) { // a or left arrow
                            move = mov('a');
                        } else if (event.keyCode === 83 || event.keyCode === 40) { // s or dowm arrow
                            move = mov('s');
                        } else if (event.keyCode === 68 || event.keyCode === 39) { // d or right arrow
                            move = mov('d');
                        }

                        // if move is true, a move has been made
                        if (move) {
                            add_random_tile();
                        }
                        print_area();
                    }
                });
            }
        }
    };
};

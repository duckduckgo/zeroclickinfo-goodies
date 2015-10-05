DDH.game2048 = DDH.game2048 || {};

DDH.game2048.build = function(ops) {

    // Global Variables Declaration

    var $tempArea, $container, $spanPoints, WINNUM, SIZE;

    var continueGame = true,
        started = false,
        area = [];


    /* This function ( using 'transpose' and 'swapRows' )
    moves and sums numbers */

    function mov(dir) {
        var i,
            points = 0,
            moves = 0,
            flag = false,
            exit;

        if (dir === 'a' || dir === 'd') {
            area = transpose();
        }
        if (dir === 's' || dir === 'd') {
            area = swapRows();
        }

        for (var col = 0; col < SIZE; col++) {
            for (var row = 0; row < SIZE; row++) {
                exit = false;
                if (area[row][col] === "") {
                    moves++;
                } else {
                    // if a move can be made
                    if (moves !== 0) {

                        area[row-moves][col] = area[row][col];

                        area[row][col] = '';

                        flag=true;
                    }
                    i = row+1;
                    while(i < SIZE && exit === false) {
                        // if numbers can be summed
                        if(area[row-moves][col] === area[i][col]) {
                            // sum numbers
                            area[row-moves][col] *= 2;
                            // delete the old number
                            area[i][col] = '';
                            // add points
                            points = area[row-moves][col];

                            flag = true; exit = true;
                        } else {
                            // else quit the while loop
                            if(area[i][col] !== "") {
                                exit = true;
                            }
                        }
                        i++;
                    }
                }
                i = 0;
            }
            moves = 0;
        }

        if (dir === 's' || dir === 'd') {
            area = swapRows();
        }
        if (dir === 'a' || dir === 'd') {
            area = transpose();
        }

        printArea();
        increasePoints(points);

        if (checkWin() || checkLose()) {
            continueGame = false;
            flag = false;
        }
        /* This check is mandatory in order to avoid the appearance of a new
        value in the area if no moves has been made */
        return flag;
    }

    // Updates the 'points' div

    function increasePoints(points) {
        var current = parseInt($spanPoints.text());
        $spanPoints.text(current + points);
    }

    /* After every little table's change, the area is updated.
    This function changes the cell class too */

    function printArea() {
        var val;
        $("td").each(function(idx) {
            val = area[parseInt(idx / SIZE, 10)][idx % SIZE];
            $(this).html(val).attr("class","boxtile val-"+val);
        });
    }

    // 'area' initialization

    function getArea() {
        var sub = [SIZE];
        for (var row = 0; row < SIZE; row++) {
            $("td").each(function(idx) {
                sub[idx % SIZE] = $(this).text();
            });
            area[row] = sub;
            sub = [];
        }
    }


    /* The two functions below are implemented in order to avoid to make a
    specific function for every single direction/move

    Start:

''  ''  2   ''

4   8   ''  ''

2   ''   ''  2

''  ''  ''  ''

Want to make a move to the right: -> or 'd'
transpose() makes the table looks like this:

''  4   2   ''

''  8   ''  ''

2   ''  ''  ''

''  ''  2   ''

swapRows() makes the table looks like this:

''  ''  2   ''

2   ''  ''  ''

''  8   ''  ''

''  4   2   ''

movement to the up:

2   8   4   ''

''  4   ''  ''

''  ''  ''  ''

''  ''  ''  ''


recall the swapRows() function

''  ''  ''  ''

''  ''  ''  ''

''  4   ''  ''

2   8   4   ''


recall the transpose() function (final state)

''  ''  ''  2

''  ''  4   8

''  ''  ''  4

''  ''  ''  ''

*/

    // left and right moves activate this function

    function transpose() {
        for (var row = 0; row < SIZE; row++) {
            for (var col = 0; col < row; col++) {
                var temp = area[row][col];
                area[row][col] = area[col][row];
                area[col][row] = temp;
            }
        }
        return area;
    }

    // down and right moves activate this function

    function swapRows() {
        var nArea = [];

        for(var i = 0; i < SIZE; i++) {
            nArea[SIZE-1-i] = area[i];
        }
        return nArea;
    }


    /* This function set a random number ( 2 or 4 ) in a random
    position around the area. 4 has a 10% chance of being chosen. */

    function getRand() {

        var rand = Math.floor(Math.random() * 11);
        var posX, posY;

        rand = (rand < 10) ? 2 : 4;

        do {
            posX = Math.floor(Math.random() * SIZE);
            posY = Math.floor(Math.random() * SIZE);
        } while( area[posX][posY] !== '');

        area[posX][posY] = rand;
        printArea();

    }

    /* If there is the winning number inside the table, returns true and
    prints a congratulation message */

    function checkWin() {
        for (var row = 0; row < SIZE; row++) {
            for (var col = 0; col < SIZE; col++) {
                if (area[row][col] == WINNUM) {
                    area[0][0] = 'Y'; area[0][1] = 'O'; area[0][2] = 'U';
                    area[SIZE-1][0] = 'W'; area[SIZE-1][1] = 'I'; area[SIZE-1][2] = 'N';
                    printArea();
                    return true;
                }
            }
        }
        return false;
    }

    // If no moves or sums are possible, returns true

    function checkLose() {
        var count = 0;
        var canDoSomething = false;
        for (var row = 0; row < SIZE; row++) {
            for (var col = 0; col < SIZE; col++) {
                // how many cells are not empty??
                if (area[row][col] !== '') {
                    count++;
                }
                // check all available movements
                if ((row !== 0 && area[row][col] === area[row-1][col]) ||
                    (row !== SIZE-1 && area[row][col] === area[row+1][col]) ||
                    (col !== 0 && area[row][col] === area[row][col-1]) ||
                    (col !== SIZE-1 && area[row][col] === area[row][col+1])) {
                    canDoSomething = true;
                }
            }
        }
        // if all the cells all full AND no movements are available, returns true
        if (count === SIZE * SIZE && !canDoSomething) {
            area[0][0] = 'Y'; area[0][1] = 'O'; area[0][2] = 'U';
            area[SIZE-1][0] = 'L'; area[SIZE-1][1] = 'O'; area[SIZE-1][2] = 'S'; area[SIZE-1][3] = 'E';
            printArea();
            return true;
        }

        return false;
    }


    // This function creates and prints on page the gaming table

    function start() {
        getArea();
        getRand();
    }


    return {
        onShow: function() {

            /* 'started' is a boolean variable used in order to avoid the
            duplication of the gaming area. Moving around the DDG tabs the
            'onShow' function is executed over and over. This simple solution
            prevents the problem */
            if (!started) {

                started = true;

                $container = $('#game2048__container');
                $spanPoints = $('.game2048__points');
                $tempArea = $('#game2048__area');
                WINNUM = ops.data[0].inputNum;
                SIZE = ops.data[0].dimension;

                start();

                $('html').keydown(function(event){

                    event.stopPropagation();
                    event.preventDefault();

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
                            getRand();
                        }
                    }

                });
            }
        }
    };
};

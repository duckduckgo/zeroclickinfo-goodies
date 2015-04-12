DDH.game2048 = DDH.game2048 || {};

DDH.game2048.build = function(ops) {

    // Global Variables Declaration

    var tempArea, container, WINNUM, SIZE, goOn, area, color;


    // This function ( using 'transpose' and 'swapRows' )
    // moves the numbers

    function mov(dir, area) {
        tempArea.focus();
        var i,
            points = 0,
            moves = 0,
            flag = false,
            exit;

        if (dir == 'a' || dir == 'd') {
            area = transpose(area);
        }
        if (dir == 's' || dir == 'd') {
            area = swapRows(area);
        }

        for (var c = 0; c<SIZE; c++) {
            for (var r = 0; r<SIZE; r++) {
                exit = false;
                if (area[r][c] == "") {
                    moves++;
                } else {

                    if (moves != 0) {
                        area[r-moves][c] = area[r][c];
                        area[r][c] = '';
                        flag=true;
                    }
                    i = r+1;
                    while(i < SIZE && exit == false) {
                        if(area[r-moves][c]==area[i][c]) {
                            area[r-moves][c]*=2;
                            area[i][c]='';
                            points = area[r-moves][c];
                            flag = true; exit = true;
                        } else {
                            if(area[i][c]!="")
                                exit = true;
                        }
                        i++;
                    }
                }
                i =0;
            }
            moves = 0;
        }

        if (dir == 's' || dir == 'd') {
            area = swapRows(area);
        }
        if (dir == 'a' || dir == 'd') {
            area = transpose(area);
        }

        printArea(area);
        upPoints(points);

        if (checkWin(area) || checkLose(area, dir)) {
            goOn = false;
        }
        // This check is mandatory in order to avoid the appearance of a new
        // value in the area if no moves has been made
        return flag;
    }

    // Updates the 'points' div

    function upPoints(points) {
        var spanPoints = $('.points');
        var current = parseInt(spanPoints.text());
        spanPoints.text(current + points);
    }

    // After every little table's change, the area is updated.
    // This function changes the cell background too

    function printArea(area) {
        var val;
        for (var r = 0; r < SIZE; r++) {
            for (var c = 0; c < SIZE; c++) {
                val = area[r][c];
                $('#area tr').eq(r).find('td').eq(c).html(val);
                $('#area tr').eq(r).find('td').eq(c).css("background-color",color[val]);
            }
        }
    }

    // 'area' initialization

    function getArea(tempArea, area) {
        var sub = [];
        for (var r = 0; r<SIZE; r++) {
            for (var c = 0; c<SIZE; c++) {
                sub[c] = $(area).find('tr#'+r).find('td:eq(c)').text();
            }
            area[r] = sub;
            sub = [];
        }
    }



    // The two functions below are implemented in order to avoid to make a
    // specific function for every single direction/move

    // left and right moves activate this function

    function transpose(area) {
        for (var r = 0; r < SIZE; r++) {
            for (var c = 0; c < r; c++) {
                var temp = area[r][c];
                area[r][c] = area[c][r];
                area[c][r] = temp;
            }
        }
        return area;
    }

    // down and right moves activate this function

    function swapRows(area) {
        var nArea=new Array();

        for(i=0;i<SIZE;i++) {
            nArea[SIZE-1-i]=area[i];
        }
        return nArea;
    }


    // This function set a random number ( 2 or 4 ) in a random
    // position around the area. 4 has a 10% chance of being chosen.

    function getRand(area) {

        var rand=Math.floor(Math.random()*11);
        var posX, posY;

        rand = (rand < 10) ? 2 : 4;

        do {
            posX=Math.floor(Math.random()*SIZE);
            posY=Math.floor(Math.random()*SIZE);
        } while( area[posX][posY] != '');

        area[posX][posY] = rand;
        printArea(area);

    }

    // If there is the winning number inside the table, returns true and
    // prints a congratulation message

    function checkWin(area) {
        for (var r = 0; r<SIZE; r++) {
            for (var c = 0; c<SIZE; c++) {
                if (area[r][c] == WINNUM) {
                    area[0][0] = 'Y'; area[0][1] = 'O'; area[0][2] = 'U';
                    area[SIZE-1][0] = 'W'; area[SIZE-1][1] = 'I'; area[SIZE-1][2] = 'N';
                    printArea(area);
                    return true;
                }
            }
        }
        return false;
    }

    // If no moves or sums are possible, returns true

    function checkLose(area) {
        var count = 0;
        for (var r = 0; r<SIZE; r++) {
            for (var c = 0; c<SIZE; c++) {
                if (area[r][c] != '') {
                    count++;
                }
            }
        }
        if (count == SIZE*SIZE && !canDoSomething(area)) {
            area[0][0] = 'Y'; area[0][1] = 'O'; area[0][2] = 'U';
            area[SIZE-1][0] = 'L'; area[SIZE-1][1] = 'O'; area[SIZE-1][2] = 'S'; area[SIZE-1][3] = 'E';
            printArea(area);
            return true;
        }

        return false;
    }

    function canDoSomething(area) {
        for (var r = 0; r < SIZE; r++) {
            for (var c = 0; c < SIZE; c++) {
                if ((r != 0 && area[r][c] == area[r-1][c]) ||
                    (r != SIZE-1 && area[r][c] == area[r+1][c]) ||
                    (c != 0 && area[r][c] == area[r][c-1]) ||
                    (c != SIZE-1 && area[r][c] == area[r][c+1])) {

                    return true;
                }
            }
        }
        return false;
    }

    // This function creates and prints to page the gaming table

    function createTable(container) {
        var nCell = '';
        var table = $('<table/>').attr("id","area").attr("class","area");

        for (var i = 0; i < SIZE; i++) {
            nCell += '<td></td>';
        }
        for(var r = 0; r < SIZE; r++){
            table.append('<tr>' + nCell + '</tr>');
        }
        $(container).append(table);
    }


    function start() {
        getArea(tempArea,area);
        getRand(area);
    }


    return {
        onShow: function() {

            tempArea = $('#area');
            container = $('#2048-area');
            WINNUM = $('#game').html();
            SIZE = parseInt($("#dimension").html(), 10);
            goOn = true;
            area = new Array();
            color = {'' : '#BBADA0',
                    '2' : '#EEE4DA',
                    '4' : '#EDE0C8',
                    '8' : '#F2B179',
                    '16' : '#F59563',
                    '32' : '#F67C5F',
                    '64' : '#F65E3B',
                    '128' : '#EDCF72',
                    '256' : '#EDCC61',
                    '512' : '#EDC850',
                    '1024' : '#EDC53F',
                    '2048' : '#EDC22E',
                    '4096' : '#D5AE29',
                    '8192' : '#AA8B21'};

            createTable(container);
            start(tempArea,area);

            $('html').keydown(function(event){

                event.stopPropagation();
                event.preventDefault();

                var move = false;

                if (goOn) {

                    if (event.keyCode == 87 || event.keyCode == 38) { // w or up arrow
                        move = mov('w', area);
                    } else if (event.keyCode == 65 || event.keyCode == 37) { // a or left arrow
                        move = mov('a', area);
                    } else if (event.keyCode == 83 || event.keyCode == 40) { // s or dowm arrow
                        move = mov('s', area);
                    } else if (event.keyCode == 68 || event.keyCode == 39) { // d or right arrow
                        move = mov('d', area);
                    }

                    // if move is true, a move has been made
                    if (move) {
                        getRand(area);
                    }
                }

            });
        }
    };
};


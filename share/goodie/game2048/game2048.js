DDH.game2048 = DDH.game2048 || {};

DDH.game2048.build = function(ops) {


    return {
        onShow: function() {

            var tempArea = document.getElementById('area');
            var WINNUM = document.getElementById('game').innerHTML;
            var SIZE = parseInt(document.getElementById('dimension').innerHTML);
            var goOn = true;
            var dir;
            var area = new Array();
            var color = {'' : '#BBADA0',
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

            createTable(tempArea);
            start(tempArea,area);

            document.addEventListener("keydown", function(event){checkMov(event)}, true);

            function checkMov(event) {
                var move = false;

                if (goOn) {

                    switch(event.which) {
                        case 38: {
                            dir = 'w';
                            break;
                        }
                        case 37: {
                            dir = 'a';
                            break;
                        }
                        case 40: {
                            dir = 's';
                            break;
                        }
                        case 39: {
                            dir = 'd';
                            break;
                        }
                        default: return;
                    }

                    move = mov(dir,area);

                    // if move is true, a move has been made
                    if (move) {
                        getRand(area);
                    }
                }

                event.defaultPrevented;
            }

            function mov(dir, area) {
                var i;
                var points = 0;
                var moves = 0;
                var flag = false;
                var exit;

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

                // This check is necesary avoiding the appearance of a new value in the area if
                // no moves was made
                return flag;
            }

            function upPoints(points) {
                var spanPoints = document.getElementsByClassName('points')[0];
                var current = parseInt(spanPoints.innerHTML);
                spanPoints.innerHTML = current + points;
            }

            function printArea(area) {
                var val;
                for (var r = 0; r< SIZE; r++) {
                    for (var c = 0; c<SIZE; c++) {
                        val = area[r][c];
                        tempArea.rows[r].cells[c].innerHTML = area[r][c];
                        tempArea.rows[r].cells[c].style.backgroundColor = color[val];
                    }
                }
            }


            function getArea(tempArea, area) {
                var sub = new Array();
                for (var r = 0; r<SIZE; r++) {
                    for (var c = 0; c<SIZE; c++) {
                        sub[c] = tempArea.rows[r].cells[c].innerHTML;
                    }
                    area[r] = sub;
                    sub = [];
                }
            }

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

            function swapRows(area) {
                var narea=new Array();

                for(i=0;i<SIZE;i++) {
                    narea[SIZE-1-i]=area[i];
                }
                return narea;
            }

            function getRand(area) {

                var rand=Math.floor(Math.random()*11);
                var posX;
                var posY;

                rand = (rand < 10) ? 2 : 4;

                do {
                    posX=Math.floor(Math.random()*SIZE);
                    posY=Math.floor(Math.random()*SIZE);
                } while( area[posX][posY] != '');

                area[posX][posY] = rand;

                printArea(area);

            }

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

            function createTable(tempArea) {
                for(var r = 0; r < SIZE; r++){
                    var tr = tempArea.insertRow();
                    for(var c = 0; c < SIZE; c++){
                        var td = tr.insertCell();
                    }
                }
            }

            function start() {
                getArea(tempArea,area);
                getRand(area);
            }
        }
    };
};

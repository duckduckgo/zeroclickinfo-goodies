//Written by Melchiorre Alastra
//it was distributed under the terms of
//GNU General Public License Version 2
//You can read the LICENSE file

var sudokujsma = {

Array.prototype.remove = function(value) {
    var idx = this.indexOf(value);
    if (idx != -1) {
        return this.splice(idx, 1);
    }
    return false;
}

var rows = [[0,1,2,3,4,5,6,7,8],
[9,10,11,12,13,14,15,16,17],
[18,19,20,21,22,23,24,25,26],
[27,28,29,30,31,32,33,34,35],
[36,37,38,39,40,41,42,43,44],
[45,46,47,48,49,50,51,52,53],
[54,55,56,57,58,59,60,61,62],
[63,64,65,66,67,68,69,70,71],
[72,73,74,75,76,77,78,79,80]];
var cols = [[0,9,18,27,36,45,54,63,72],
[1,10,19,28,37,46,55,64,73],
[2,11,20,29,38,47,56,65,74],
[3,12,21,30,39,48,57,66,75],
[4,13,22,31,40,49,58,67,76],
[5,14,23,32,41,50,59,68,77],
[6,15,24,33,42,51,60,69,78],
[7,16,25,34,43,52,61,70,79],
[8,17,26,35,44,53,62,71,80]];
var blocks = [[0,1,2,9,10,11,18,19,20],
[3,4,5,12,13,14,21,22,23],
[6,7,8,15,16,17,24,25,26],
[27,28,29,36,37,38,45,46,47],
[30,31,32,39,40,41,48,49,50],
[33,34,35,42,43,44,51,52,53],
[54,55,56,63,64,65,72,73,74],
[57,58,59,66,67,68,75,76,77],
[60,61,62,69,70,71,78,79,80]];
var blockscol = [[0,9,18,1,10,19,2,11,20],
[3,12,21,4,13,22,5,14,23],
[6,15,24,7,16,25,8,17,26],
[27,36,45,28,37,46,29,38,47],
[30,39,48,31,40,49,32,41,50],
[33,42,51,34,43,52,35,44,53],
[54,63,72,55,64,73,56,65,74],
[57,66,75,58,67,76,59,68,77],
[60,69,78,61,70,79,62,71,80]];
var blockstartcol = [0,3,6,0,3,6,0,3,6];
var blockstartrow = [0,0,0,3,3,3,6,6,6];
var cellrow = [0,0,0,0,0,0,0,0,0,
1,1,1,1,1,1,1,1,1,
2,2,2,2,2,2,2,2,2,
3,3,3,3,3,3,3,3,3,
4,4,4,4,4,4,4,4,4,
5,5,5,5,5,5,5,5,5,
6,6,6,6,6,6,6,6,6,
7,7,7,7,7,7,7,7,7,
8,8,8,8,8,8,8,8,8];
var cellcol = [0,1,2,3,4,5,6,7,8,
0,1,2,3,4,5,6,7,8,
0,1,2,3,4,5,6,7,8,
0,1,2,3,4,5,6,7,8,
0,1,2,3,4,5,6,7,8,
0,1,2,3,4,5,6,7,8,
0,1,2,3,4,5,6,7,8,
0,1,2,3,4,5,6,7,8,
0,1,2,3,4,5,6,7,8];
var cellblock = [
0,0,0,1,1,1,2,2,2,
0,0,0,1,1,1,2,2,2,
0,0,0,1,1,1,2,2,2,
3,3,3,4,4,4,5,5,5,
3,3,3,4,4,4,5,5,5,
3,3,3,4,4,4,5,5,5,
6,6,6,7,7,7,8,8,8,
6,6,6,7,7,7,8,8,8,
6,6,6,7,7,7,8,8,8];
var cells = [];
var clonecells = [];
var initialcells = [];
var cand = [];
var listemptycells = [];
var listnoemptycells = [];
var clonelistemptycells = [];
var create = 0;
var loopin = 0;

function getSudoku(level) {
    makeValidSudoku();
    initialCells();
    makeSudoku(level);
    return cells;
}

function makeSudoku(level) {
    //delete some random cells and verify if sudoku has one only solution
    var memo,memomirror,value,valuemirror,numloop,numloop2;
    var memoemptycells;
    var row;
    var col;
    var pos = [];
    var pos2 = [];
    var t = 0;
    var memomaxlevel = 0;
    var index;
    var zum;
    maxlevel = 1;
    emptycells = 0;
    listemptycells=[];

    for (t = 0; t < 41; t++) {
        pos[t] = t;
    }
    clearCandidates();
    listnoemptycells = [0,1,2,3,4,5,6,7,8,9,10
,11,12,13,14,15,16,17,18,19,20
,21,22,23,24,25,26,27,28,29,30
,31,32,33,34,35,36,37,38,39,40
,41,42,43,44,45,46,47,48,49,50
,51,52,53,54,55,56,57,58,59,60
,61,62,63,64,65,66,67,68,69,70
,71,72,73,74,75,76,77,78,79,80];
    if (level > 2 ) {
        for (t = 0; t < 5; t++) {
            index = Math.floor((Math.random() * pos.length));
            value = pos[index];
            if (value != 40) {
                valuemirror = getMirrorCell(value);
                cells[valuemirror] = 0;
                listemptycells.push(valuemirror);
                listnoemptycells.remove(valuemirror);
                emptycells++;
            }
            pos.splice(index,1);
            cells[value] = 0;
            listemptycells.push(value);
            listnoemptycells.remove(value);
            emptycells++;
        }
    }
    
    //try to delete a number and see if it is Solvable
    numloop = pos.length;
    
    for (t = 0; t < numloop; t++) {
        index = Math.floor((Math.random() * pos.length));
        value = pos[index];
        if (value != 40) {
            valuemirror = getMirrorCell(value);
            memomirror = cells[valuemirror];
            cells[valuemirror] = 0;
            listemptycells.push(valuemirror);
            listnoemptycells.remove(valuemirror);
        }
        pos.splice(index,1);
        memo = cells[value];
        cells[value] = 0;
        listemptycells.push(value);
        listnoemptycells.remove(value);  
        memoemptycells = emptycells;
        if (isSolvable(level) === 0) {
            cells[value] = memo; 
            if (value != 40) {
                cells[valuemirror] = memomirror; 
            }
            emptycells = memoemptycells;
            listemptycells.splice(memoemptycells,1);
            listnoemptycells.push(value);
            if (value != 40) {
                listemptycells.splice(memoemptycells,1);
                listnoemptycells.push(valuemirror); 
            }
            maxlevel = 1;
        } else {
           memomaxlevel = maxlevel; 
           if (value != 40) { 
               emptycells = memoemptycells + 2;
           } else {
               emptycells = memoemptycells + 1;
           }
        }    
    }
    
    if (level !== memomaxlevel) {
        byinitialCells();
        create++;
        if (create > 30) {
            loopin++;
            create = 0;
            getSudoku(level);
            return;
        } else {
            makeSudoku(level);
            return;
        }
    }
    create = 0;
    loopin = 0;
}

function getMirrorCell(value) {
    return 80-value;
}

function solve(mycells) {
    maxlevel = 1;
    cells = mycells;
    var t;
    var level=4;
    resetCandidates();
    emptycells = 0;
    for (t = 0; t < 81; t++) {
        if (cells[t] != 0) {
            deleteCandidate(t,cells);
        } else {
            emptycells++;
            listemptycells.push(t);
        }
    }
    cloneCells();
    cloneList();
    var continueloop = false;
    var lv = "NakedSingle";
    do {
    do {
        //Search NakedSingle Level 1 - Very Easy
        searchNakedSingle();
        if (emptycells === 0) {
            printSudoku81(clonecells);
            return 1;
        }
        do {
            //Search HiddenSingle Level 2 - Easy
            if (maxlevel < 2) {
                maxlevel = 2;
            } 
            if (level > 1) {
                continueloop = searchHiddenSingle();
                if (continueloop === true) {
                    lv = "HiddenSingle";
                }
                if (emptycells === 0) {
                    printSudoku81(clonecells);
                    return 1;
                }
            }
        } while (continueloop === true) 
        //Search NakedPair HiddenPair Level 3 - Medium
        if (maxlevel < 3) {
            maxlevel = 3;
        }
    } while (level > 2 && (searchNaked(2) ||searchNaked(3) ||searchHiddenPair()||searchNaked(4) || searchPointingPair()||searchBoxLineReduction() )) 
   if (maxlevel < 4) {
            maxlevel = 4;
        }
} while (level>3 && (searchXWing() ||searchXYWing() ))
    return 0;
}

function isOnlyOne() {
    var t;
    var memolen=10;
    var memoindex;
    var used=[];

    var ge = listemptycells.length;
    for (t = 0; t < ge; t++) {
        cand[listemptycells[t]] = [1,2,3,4,5,6,7,8,9];
    }
    var gn = listnoemptycells.length;
    for (t = 0; t < gn; t++) {
        deleteCandidate(listnoemptycells[t],cells) 
    } 
    cloneCells();
    cloneList();

    do {
       searchNakedSingle();
       if (emptycells < 0) {
           return true;
       }     
    } while (searchHiddenSingle()) 


    ge = listemptycells.length;
    for (t = 0; t < ge; t++) {
        if (cand[listemptycells[t]].length < memolen) {
            memolen = listemptycells[t].length;
            memoindex = listemptycells[t];
        }
    }
    used.push(memoindex);
    cand[memoindex].remove(initialcells[memoindex]);
    
    do {
       searchNakedSingle();
       if (emptycells < 0) {
           return false;
       }     
    } while (searchHiddenSingle())


    return true;
}

function isSolvable(level) {
    var t;
    var ge = listemptycells.length;
    for (t = 0; t < ge; t++) {
        cand[listemptycells[t]] = [1,2,3,4,5,6,7,8,9];
    }
    var gn = listnoemptycells.length;
    for (t = 0; t < gn; t++) {
        deleteCandidate(listnoemptycells[t],cells) 
    } 
    cloneCells();
    cloneList();
    var continueloop = false;
    var lv = "NakedSingle";
do {
    do {
        //Search NakedSingle Level 1 - Very Easy
        searchNakedSingle();
        if (emptycells < 0) {
            return 1;
        }
        do {
            //Search HiddenSingle Level 2 - Easy
            if (maxlevel < 2) {
                maxlevel = 2;
            } 
            if (level > 1) {
                continueloop = searchHiddenSingle();
                if (continueloop === true) {
                    lv = "HiddenSingle";
                }
                if (emptycells < 0) {
                    return 1;
                }
            }
        } while (continueloop === true) 
        //Search NakedPair HiddenPair Level 3 - Medium
        if (maxlevel < 3) {
            maxlevel = 3;
        }
    } while (level >2 && ( searchNaked(2) ||searchNaked(3)|| searchHiddenPair() ||searchNaked(4) ||searchPointingPair() || searchBoxLineReduction() ))
if (maxlevel < 4) {
            maxlevel = 4;
        } 
} while (level>3 && (searchXWing() ||searchXYWing() ))

    return 0;
}

function searchHiddenPair() {
    var value,num,row,col,t,f,g,r,c,block;
    var ischanged = false;
    var length,length1;
    //Search HiddenPair on rows
    for (row = 0; row < 9; row++) {
        value = [];
        num=[];
        for (t = 1; t < 10; t++) {
            num[t] = 0;
            value[t] = [[],[],[],[],[],[],[],[],[],[]];
        }
        for (col = 0; col < 9; col++) {
            length = cand[rows[row][col]].length; 
            length1 = length - 1;
            for (f = 0; f < length1; f++) {
                num[cand[rows[row][col]][f]]++;
                for (g = f + 1; g < length; g++) {
                    value[cand[rows[row][col]][f]][cand[rows[row][col]][g]].push(rows[row][col]);
                }
            }
            num[cand[rows[row][col]][f]]++;   
        }
        for (r = 1; r < 9; r++) {
            for (c = r+1; c < 10; c++) {
                if (num[r]===2 && num[c]===2 && value[r][c].length == 2 && (cand[value[r][c][0]].length>2 || cand[value[r][c][1]].length>2)) {
                    //pair Hidden to Naked
                    cand[value[r][c][0]] = [r,c];
                    cand[value[r][c][1]] = [r,c];
                    ischanged = true;
                } 
            }
        }   
    }
    //Search HiddenPair on cols
    for (col = 0; col < 9; col++) {
        value = [];
        num=[];
        for (t = 1; t < 10; t++) {
            num[t] = 0;
            value[t] = [[],[],[],[],[],[],[],[],[],[]];
        }
        for (row = 0; row < 9; row++) { 
                    length = cand[cols[col][row]].length; 
                    length1 = length - 1;
                    for (f = 0; f < length1; f++) {
                        num[cand[cols[col][row]][f]]++;
                        for (g = f + 1; g < length; g++) {
                            value[cand[cols[col][row]][f]][cand[cols[col][row]][g]].push(cols[col][row]);
                        }
                    } 
                    num[cand[cols[col][row]][f]]++;     
        }
        for (r = 1; r < 9; r++) {
            for (c = r+1; c < 10; c++) {
                if (num[r]===2 && num[c]===2 && value[r][c].length == 2 && (cand[value[r][c][0]].length>2 || cand[value[r][c][1]].length>2)) {
                    //pair Hidden to Naked
                    cand[value[r][c][0]] = [r,c];
                    cand[value[r][c][1]] = [r,c];
                    ischanged = true;
                } 
            }
        }   
    }
    //Search HiddenPair on blocks
    for (block = 0; block < 9; block++) {
        value = [];
        num=[];
        for (t = 1; t < 10; t++) {
            num[t] = 0;
            value[t] = [[],[],[],[],[],[],[],[],[],[]];
        }

    for (t = 0; t < 9; t++) {
                //create all pair combinations of cand
                length = cand[blocks[block][t]].length; 
                length1 = length - 1;
                    for (f = 0; f < length1; f++) {
                        num[cand[blocks[block][t]][f]]++;
                        for (g = f + 1; g < length; g++) {
                            value[cand[blocks[block][t]][f]][cand[blocks[block][t]][g]].push(blocks[block][t]);
                        }
                    }  
                    num[cand[blocks[block][t]][f]]++;      
    }
    for (r = 1; r < 9; r++) {
            for (c = r+1; c < 10; c++) {
                if (num[r]===2 && num[c]===2 && value[r][c].length == 2 && (cand[value[r][c][0]].length>2 || cand[value[r][c][1]].length>2)) {    
                    //pair Hidden to Naked
                    cand[value[r][c][0]] = [r,c];
                    cand[value[r][c][1]] = [r,c];
                    ischanged = true;
                } 
            }
        }
    }
     
    return ischanged;      
}

function searchXYWing() {
    var ischanged=false;
    var index;
    var row,col;

    //XY-WING
    for (row =0; row<9; row++) {
        for (col =0; col<9; col++) {
            index = (row*9)+col;
            if (cand[index].length==2) {
                if (searchy(row,col,index)) {
                    ischanged=true;
                }
            }  
        } 
     }

    return ischanged;
}

function searchy(row,col,index1) {
    var ischanged=false;
    var block,r,c,y,z;
    var index,index2;
    var common;
    for (c=col+1;c<9;c++) {
        index=(row*9)+c;
        if (cand[index].length==2) {
            if (haveAtLeastOne(index,index1)) {
                //found a couple of cells
                //now search in col of cell[index1]
                for (r=0;r<9;r++) {
                    if (r!=row) {
                        index2=(r*9)+col;
                        if (cand[index2].length==2) {
                            if (candInCommon(index1,index,index2)==3) {
                                    //index1 vertex
                                    if (deleteCandXYWing(index1,index,index2)) {
                                        ischanged=true;
                                    }
                            }
                        }
                    }
                }
                //now search in col of cell[index]
                for (r=0;r<9;r++) {
                    if (r!=row) {
                        index2=(r*9)+c;
                        if (cand[index2].length==2) {
                            if (candInCommon(index,index1,index2)==3) {
                                    //index vertex
                                    if (deleteCandXYWing(index,index1,index2)) {
                                        ischanged=true;
                                    }
                            }
                        }
                    }
                }
                // and in block of cell[index1]
                block=cellblock[index1];
                for (r=0;r<9;r++) {
                    index2=blocks[block][r];
                    if (index1!=index2 && index!=index2) {
                        if (cand[index2].length==2) {
                            if (candInCommon(index1,index,index2)==3) {
                                    //index vertex
                                    if (deleteCandXYWing(index1,index,index2)) {
                                        ischanged=true;
                                    }
                            }
                        }
                    }
                }
                // and in block of cell[index]
                block=cellblock[index];
                for (r=0;r<9;r++) {
                    index2=blocks[block][r];
                    if (index1!=index2 && index!=index2) {
                        if (cand[index2].length==2) {
                            if (candInCommon(index,index1,index2)==3) {
                                    //index vertex
                                    if (deleteCandXYWing(index,index1,index2)) {
                                        ischanged=true;
                                    }
                            }
                        }
                    }
                }
            }
        }
    }

for (r=row+1;r<9;r++) {
        index=(r*9)+col;
        if (cand[index].length==2) {
            if (haveAtLeastOne(index,index1)) {
                //found a couple of cells
                //now search in row of cell[index1]
                for (c=0;c<9;c++) {
                    if (c!=col) {
                        index2=(row*9)+c;
                        if (cand[index2].length==2) {
                            if (candInCommon(index1,index2,index)==3) {
                                    //index1 vertex
                                    if (deleteCandXYWing(index1,index2,index)) {
                                        ischanged=true;
                                    }
                            }
                        }
                    }
                }
                //now search in col of cell[index]
                for (c=0;c<9;c++) {
                    if (c!=col) {
                        index2=(r*9)+c;
                        if (cand[index2].length==2) {
                            if (candInCommon(index,index2,index1)==3) {
                                    //index vertex
                                    if (deleteCandXYWing(index,index2,index1)) {
                                        ischanged=true;
                                    }
                            }
                        }
                    }
                }
                // and in block of cell[index1]
                block=cellblock[index1];
                for (c=0;c<9;c++) {
                    index2=blocks[block][c];
                    if (index1!=index2 && index!=index2) {
                        if (cand[index2].length==2) {
                            if (candInCommon(index1,index2,index)==3) {
                                    //index vertex
                                    if (deleteCandXYWing(index1,index2,index)) {
                                        ischanged=true;
                                    }
                            }
                        }
                    }
                }
                // and in block of cell[index]
                block=cellblock[index];
                for (c=0;c<9;c++) {
                    index2=blocks[block][c];
                    if (index1!=index2 && index!=index2) {
                        if (cand[index2].length==2) {
                            if (candInCommon(index,index2,index1)==3) {
                                    //index vertex
                                    if (deleteCandXYWing(index,index2,index1)) {
                                        ischanged=true;
                                    }
                            }
                        }
                    }
                }
            }
        }
    }


    return ischanged;
}

function deleteCandXYWing(index1,index,index2){
    var answer=false;
    var col=cellcol[index];
    var row=cellrow[index2];
    var indexdel,t,p;
    var memolencand;
    var dcand,point,row1,col1;
    point=0;
    for (t=0;t<2;t++) {
        for (p=0;p<2;p++) {
            if (cand[index][t]==cand[index2][p]) {
                point++;
                dcand=cand[index2][p];
            }
        }
    }
    if (point==2) {
        for (t=0;t<2;t++) {
            for (p=0;p<2;p++) {
                if (cand[index1][t]==cand[index2][p]) {
                    dcand=cand[index2][p];
                }
            }
         }
    }
    if (cellblock[index1]!=cellblock[index2]) {
        if (cellblock[index1]!=cellblock[index]) {
            indexdel=(row*9)+col;
            if (indexdel!=index && indexdel!=index1 && indexdel!=index2) {
            memolencand=cand[indexdel].length;
            cand[indexdel].remove(dcand);
            if (memolencand!=cand[indexdel].length) {
                answer=true;
            }
            }
        }else{
            row1=cellrow[index1];
            col1=cellcol[index1];
            for (t=0;t<3;t++) {
                indexdel=((t+blockstartrow[cellblock[index2]])*9)+col;
                if (indexdel!=index && indexdel!=index1 && indexdel!=index2) {
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
                }
            }
            if (row1==0 || row1==3 || row1==6) {
                indexdel=((row1+1)*9)+col1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
                indexdel=((row1+2)*9)+col1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
            } else if (row1==1 || row1==4 || row1==7) {
                indexdel=((row1+1)*9)+col1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
                indexdel=((row1-1)*9)+col1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
            } else {
                indexdel=((row1-2)*9)+col1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
                indexdel=((row1-1)*9)+col1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
            }
        }
    } else {
        if (cellblock[index1]!=cellblock[index]) {
            row1=cellrow[index1];    
            col1=cellcol[index1];
            for (t=0;t<3;t++) {
                indexdel=(row*9)+t+blockstartcol[cellblock[index]];
                if (indexdel!=index && indexdel!=index1 && indexdel!=index2) {
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
                }
            }
            if (col1==0 || col1==3 || col1==6) {
                indexdel=(row1*9)+col1+1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
                indexdel=(row1*9)+col1+2;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
            } else if (col1==1 || col1==4 || col1==7) {
                indexdel=(row1*9)+col1+1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
                indexdel=(row1*9)+col1-1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
            } else {
                indexdel=(row1*9)+col1-2;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
                indexdel=(row1*9)+col1-1;
                memolencand=cand[indexdel].length;
                cand[indexdel].remove(dcand);
                if (memolencand!=cand[indexdel].length) {
                    answer=true;
                }
            }
            
        }else{

        }
    }
    return answer;
}

function haveAtLeastOne(index,index1){
    var t,p;
    for (t=0;t<cand[index].length;t++){
        for (p=0;p<cand[index1].length;p++) {
            if (cand[index][t]==cand[index1][p]) {
                return true;
            }
        }
    }
    return false;
}

function candInCommon(index,index1,index2){
    var t,p,found;
    var common=[];
    if (cellrow[index]==cellrow[index1] && cellrow[index]==cellrow[index2]) {
        return 0;
}
if (cellcol[index]==cellcol[index1] && cellcol[index]==cellcol[index2]) {
        return 0;
}
if (cellblock[index]==cellblock[index1] && cellblock[index]==cellblock[index2]) {
        return 0;
}

    if (areArrayEqual(cand[index1],cand[index2])) {
        return 0;
    }
    if (areArrayEqual(cand[index],cand[index2])) {
        return 0;
    }
    if (areArrayEqual(cand[index],cand[index1])) {
        return 0;
    }
    for (t=0;t<cand[index].length;t++){
        common.push(cand[index][t]);
    }
    for (p=0;p<cand[index1].length;p++) {
        found=false;
        for (t=0;t<common.length;t++){
            if (common[t]==cand[index1][p]) {
                found=true;
                break;
            }
        }
        if (!found) {
            common.push(cand[index1][p]);
        }
    }
    for (p=0;p<cand[index2].length;p++) {
        found=false;
        for (t=0;t<common.length;t++){
            if (common[t]==cand[index2][p]) {
                found=true;
                break;
            }
        }
        if (!found) {
            common.push(cand[index2][p]);
        }
    }
    return common.length;
}

function searchXWing() {
    var ischanged=false;
    var index;
    var row,col,t,p,y,z,col1,col2,row1,row2;
    var indexnum;
    var scheme=[];
    //X-WING row
    for (row =0; row<9; row++) {
        indexnum=[[],[],[],[],[],[],[],[],[]];
        for (col =0; col<9; col++) {
            index = (row*9)+col;
            for (t=0; t<cand[index].length; t++) {
                indexnum[cand[index][t]-1].push(index);
            }  
        } 
        scheme.push(indexnum.slice(0));
    }
    for (t=0;t<scheme.length;t++) {
        for (p=0;p<scheme[t].length;p++) {
            if (scheme[t][p].length == 2) {
                //search on other rows
                for (y=t+1; y<scheme.length;y++) {
                    if (scheme[y][p].length==2) {
                        //are indexes in the same columns?
                        col1=cellcol[scheme[t][p][0]];
                        col2=cellcol[scheme[t][p][1]];
                        if (col1==cellcol[scheme[y][p][0]] && col2==cellcol[scheme[y][p][1]]) { 
                            //Found XWING
                            //delete p from colum of candidates
                            for (z=0;z<9;z++) {
                                if (scheme[t][p][0]!=cols[col1][z] && scheme[y][p][0]!=cols[col1][z]) {
                                    memolencan=cand[cols[col1][z]].length;
                                    cand[cols[col1][z]].remove(p+1);
                                    if (memolencan!=cand[cols[col1][z]].length) {
                                        ischanged=true;
                                    }
                                }
                                if (scheme[t][p][1]!=cols[col2][z]&& scheme[y][p][1]!=cols[col2][z]) {
                                    memolencan=cand[cols[col2][z]].length;
                                    cand[cols[col2][z]].remove(p+1);
                                    if (memolencan!=cand[cols[col2][z]].length) {
                                        ischanged=true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    scheme=[];
    //X-WING col
    for (col =0; col<9; col++) {
        indexnum=[[],[],[],[],[],[],[],[],[]];
        for (row =0; row<9; row++) {
            index = (row*9)+col;
            for (t=0; t<cand[index].length; t++) {
                indexnum[cand[index][t]-1].push(index);
            }  
        } 
        scheme.push(indexnum.slice(0));
    }
    for (t=0;t<scheme.length;t++) {
        for (p=0;p<scheme[t].length;p++) {
            if (scheme[t][p].length == 2) {
                //search on other cols
                for (y=t+1; y<scheme.length;y++) {
                    if (scheme[y][p].length==2) {
                        //are indexes in the same rows?
                        row1=cellrow[scheme[t][p][0]];
                        row2=cellrow[scheme[t][p][1]];
                        if (row1==cellrow[scheme[y][p][0]] && row2==cellrow[scheme[y][p][1]]) { 
                            //Found XWING
                            //delete p from row of candidates
                            for (z=0;z<9;z++) {
                                if (scheme[t][p][0]!=rows[row1][z]&& scheme[y][p][0]!=rows[row1][z]) {
                                    memolencan=cand[rows[row1][z]].length;
                                    cand[rows[row1][z]].remove(p+1);
                                    if (memolencan!=cand[rows[row1][z]].length) {
                                        ischanged=true;
                                    }
                                }
                                if (scheme[t][p][1]!=rows[row2][z]&& scheme[y][p][1]!=rows[row2][z]) {
                                    memolencan=cand[rows[row2][z]].length;
                                    cand[rows[row2][z]].remove(p+1);
                                    if (memolencan!=cand[rows[row2][z]].length) {
                                        ischanged=true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return ischanged;
}

function searchBoxLineReduction() {
    var ischanged=false;
    var block,candpres,p,t,j,row,indrow,col,indcol,indblock;
    indblock=[];
    indrow=[];
    indcol=[];
    for (block = 0; block < 9; block++) {
        //Rows
        for (p = 0 ; p<3; p++) {
            candpres=[];
            row=cellrow[blocks[block][p*3]];
            
            indrow=rows[row].slice(0);
            indblock=blocks[block].slice(0);
            for (t=0; t<3; t++) {
                addOnlyDifferent(cand[blocks[block][(p*3)+t]],candpres);
                indrow.remove(blocks[block][(p*3)+t]);
                indblock.remove(blocks[block][(p*3)+t]);
            }
            if (candpres.length>0) {
            for (t=0; t<indrow.length; t++) {
                for (j=0; j<cand[indrow[t]].length; j++) {
                    candpres.remove(cand[indrow[t]][j]);
                }
            }
            }
            if (candpres.length>0) {
                for (t=0;t<indblock.length;t++) {
                    for (j=0;j<cand[indblock[t]].length;j++) {
                    if (isInArray(cand[indblock[t]][j],candpres)) {
                        ischanged=true;
                        cand[indblock[t]].remove(cand[indblock[t]][j]);
                    }
                    }
                }
            }
        }
        //Cols
        for (p = 0 ; p<3; p++) {
            candpres=[];
            col=cellcol[blockscol[block][p*3]];
            indcol=cols[col].slice(0);
            indblock=blockscol[block].slice(0);
            for (t=0; t<3; t++) {
                addOnlyDifferent(cand[blockscol[block][(p*3)+t]],candpres);
                indcol.remove(blockscol[block][(p*3)+t]);
                indblock.remove(blockscol[block][(p*3)+t]);
            }
            if (candpres.length>0) {
            for (t=0; t<indcol.length; t++) {
                for (j=0; j<cand[indcol[t]].length; j++) {
                    candpres.remove(cand[indcol[t]][j]);
                }
            }
            }
            if (candpres.length>0) {
                for (t=0;t<indblock.length;t++) {
                    for (j=0;j<cand[indblock[t]].length;j++) {
                    if (isInArray(cand[indblock[t]][j],candpres)) {
                        ischanged=true;
                        cand[indblock[t]].remove(cand[indblock[t]][j]);
                    }
                    }
                }
            }
        }
    }

    return ischanged;
}

function addOnlyDifferent(array1,array2){
    var t,p,j;
    var value=[];
    for (t=0;t<array1.length;t++) {
        j=0;
        for (p=0;p<array2.length;p++) {
            if (array1[t]==array2[p]) {
                j++;
                break;
            }
        }
        if (j==0) {
            value.push(array1[t]);
        }
    }
    for (t =0; t<value.length;t++) {
        array2.push(value[t]);
    }
}

function searchNaked(num) {
    var ischanged=false;
    var key,value,row,col,t,p,s,g,block,length,length1,indexver;
    //Search NakedPair on rows
    for (row = 0; row < 9; row++) {
        key = [];
        value = [];
        indexver = [];
        for (col = 0; col < 9; col++) {
            if (cand[rows[row][col]].length == num) {
                updateKeyValue(cand[rows[row][col]],num,key,value,indexver,rows[row][col]);
            }
        }
        for (col = 0; col < 9; col++) {
            if (cand[rows[row][col]].length > 1 && cand[rows[row][col]].length < num) {
                updateKeyValue(cand[rows[row][col]],num,key,value,indexver,rows[row][col]);    
            } 
        }
        length = key.length;
        for (t = 0; t < length; t++) {
            if (value[t] == num) {
                for (col = 0; col < 9; col++) {
                    length1 = cand[rows[row][col]].length;
                    if (!isInArray(rows[row][col],indexver[t])) {
                       for (p=0; p<num; p++) {                           
                           for (s=0; s<length1; s++) {
                               if (cand[rows[row][col]][s] == key[t][p]) {
                                    ischanged = true;
                                    cand[rows[row][col]].remove(key[t][p]);
                               }
                           }
                       }
                    }
                }
            }
        }
    }
    if (ischanged) {
        return true;
    }
    //Search NakedPair on cols
    for (col = 0; col < 9; col++) {
        key = [];
        value = [];
        indexver = [];
        for (row = 0; row < 9; row++) {
            if (cand[cols[col][row]].length == num) {
                updateKeyValue(cand[cols[col][row]],num,key,value,indexver,cols[col][row]);   
            } 
        }
        for (row = 0; row < 9; row++) {
            if (cand[cols[col][row]].length >1 && cand[cols[col][row]].length < num) {
                updateKeyValue(cand[cols[col][row]],num,key,value,indexver,cols[col][row]);   
            } 
        }
        length = key.length;
        for (t = 0; t < length; t++) {
            if (value[t] == num) {
                for (row = 0; row < 9; row++) {
                    length1 = cand[cols[col][row]].length;
                    if (!isInArray(cols[col][row],indexver[t])) {
                       for (p=0; p<num; p++) {
                           for (s=0; s<length1; s++) {
                               if (cand[cols[col][row]][s] == key[t][p]) {
                                    ischanged = true;
                                    cand[cols[col][row]].remove(key[t][p]);
                               }
                           }
                           
                       }
                    }
                }
            }
        }
    }
    if (ischanged) {
        return true;
    }
    //Search NakedPair on blocks
    for (block = 0; block < 9; block++) {
        key = [];
        value = [];
        indexver = [];
        for (t = 0; t < 9; t++) {
            if (cand[blocks[block][t]].length == num) {
                updateKeyValue(cand[blocks[block][t]],num,key,value,indexver,blocks[block][t]);
            } 
        }
        for (t = 0; t < 9; t++) {
            if (cand[blocks[block][t]].length>1 && cand[blocks[block][t]].length < num) {
                updateKeyValue(cand[blocks[block][t]],num,key,value,indexver,blocks[block][t]);
            } 
        }
        length = key.length;
        for (t = 0; t < length; t++) {
            if (value[t] == num) {
                for (row = 0; row < 9; row++) {
                        length1 = cand[blocks[block][row]].length;
                        if (!isInArray(blocks[block][row], indexver[t])) {
                            for (p=0; p<num; p++) {
                                for (s=0; s<length1; s++) {
                                    if (cand[blocks[block][row]][s] == key[t][p]) {
                                        ischanged = true;
                                        cand[blocks[block][row]].remove(key[t][p]);
                                    }
                                }
                            }
                        }
                    
                }
            }
        }
    }
    return ischanged;
}

function isInArray(value, array) {
    for(i = 0; i < array.length; i++) {
	if(value == array[i]) {
	    return true;
	}
    }
    return false;
}

function searchPointingPair() {
    var numbers = [];
    var an = false;
    var row,col,index1,index2,t,value,p,memlencand,block,length;
    //search on all row
    for (row=0; row<9; row++) {
    for (t = 1 ; t < 10; t++) {
        numbers[t] = [];
    }
        for (col=0; col<9; col++) {
            length = cand[rows[row][col]].length;
            for (value = 0; value < length; value++) {
                numbers[cand[rows[row][col]][value]][numbers[cand[rows[row][col]][value]].length] = rows[row][col];
            }
        }
        for (p = 1; p < 10; p++) {
            if (numbers[p].length == 2) {
                //Search PointingPair       
                index1 = numbers[p][0];
                index2 = numbers[p][1];
                if (cellblock[index1]==cellblock[index2]) {
                   //delete value on other cells of block
                   for (t = 0; t < 9; t++) {
                       
                             if (clonecells[blocks[cellblock[index1]][t]] == 0 && blocks[cellblock[index1]][t] != index1  && blocks[cellblock[index1]][t] != index2) {
                               memlencand = cand[blocks[cellblock[index1]][t]].length;
                               cand[blocks[cellblock[index1]][t]].remove(p);
                               if (memlencand != cand[blocks[cellblock[index1]][t]].length) {
                                   an = true;
                               }
                           }
                              
                   }
                }
            } 
        }
    } 
    //search on all col
    for (col=0; col<9; col++) {
    for (t = 1 ; t < 10; t++) {
        numbers[t] = [];
    }
        for (row=0; row<9; row++) {
            length = cand[cols[col][row]].length;
            for (value = 0; value < length; value++) {
                numbers[cand[cols[col][row]][value]][numbers[cand[cols[col][row]][value]].length] = cols[col][row];
            }
        }
        for (p = 1; p < 10; p++) {
            if (numbers[p].length == 2) {
                //Search PointingPair
                index1 = numbers[p][0];
                index2 = numbers[p][1];
                if (cellblock[index1]==cellblock[index2]) {
                   //delete value on other cells of block
                   for (t = 0; t < 9; t++) {
                       
                           if (clonecells[blocks[cellblock[index1]][t]] == 0 && blocks[cellblock[index1]][t] != index1  && blocks[cellblock[index1]][t] != index2) {
                               memlencand = cand[blocks[cellblock[index1]][t]].length;

                               cand[blocks[cellblock[index1]][t]].remove(p);
                               if (memlencand != cand[blocks[cellblock[index1]][t]].length) {
                                   an = true;
                               }
                           }
                             
                   }
                }
            }
        }

    }

    //search on all block
    for (block = 0; block < 9; block++) {
    for (t = 1 ; t < 10; t++) {
        numbers[t] = [];
    }
    
    for (t = 0; t < 9; t++) {
            length = cand[blocks[block][t]].length; 
            for (value = 0; value < length; value++) {
                numbers[cand[blocks[block][t]][value]][numbers[cand[blocks[block][t]][value]].length] = blocks[block][t];
            }
    }
    for (p = 1; p < 10; p++) {
            if (numbers[p].length === 2) {
                //Search PointingPair
                index1 = numbers[p][0];
                index2 = numbers[p][1];
                if (cellrow[index1] == cellrow[index2]) {
                   //delete value on other cells of row
                   for (t = 0; t < 9; t++) {
                       if (clonecells[rows[cellrow[index1]][t]] == 0 && rows[cellrow[index1]][t] != index1 && rows[cellrow[index1]][t] != index2) {
                           memlencand = cand[rows[cellrow[index1]][t]].length;

                           cand[rows[cellrow[index1]][t]].remove(p);
                           if (memlencand != cand[rows[cellrow[index1]][t]].length) {
                               an = true;
                           }
                       }
                   }       
                }
                if (cellcol[index1] == cellcol[index2]) {
                   //delete value on other cells of col
                   for (t = 0; t < 9; t++) {
                       if (clonecells[cols[cellcol[index1]][t]] == 0 && cols[cellcol[index1]][t] != index1 && cols[cellcol[index1]][t] != index2) {
                           memlencand = cand[cols[cellcol[index1]][t]].length;

                           cand[cols[cellcol[index1]][t]].remove(p);
                           if (memlencand != cand[cols[cellcol[index1]][t]].length) {
                               an = true;

                           }
                       }
                   }       
                }
             }            
        }
    }       
    return an;
}

function updateKeyValue(candidates,num,key,value,indexver,indexcel) {
    var tr = key.length;
    if (candidates.length === num) {
        for (var t=0; t<tr; t++) {
            if (areArrayEqual(key[t],candidates)) {
                value[t]++;
                indexver[t].push(indexcel);
                return 1; 
            }
        }
        key[tr]=candidates;
        value[tr]=1;
        indexver[tr]=[];
        indexver[tr].push(indexcel);
        return 1;
    } else {
        for (var t=0; t<tr; t++) {
            if (areIn(key[t],candidates)) {
                value[t]++;
                indexver[t].push(indexcel);
                return 1; 
            }
        }
    }
    return 0;
}

function areIn(array1,array2) {
    var point = 0;
    for (var t=0; t<array2.length; t++) {
        for (var p=0; p<array1.length; p++) {
            if (array1[p] == array2[t]) {
                point++;
                break;
            }
        }
    }
    if (array2.length == point) {
        return true;
    }
    return false;
}

function areArrayEqual(array1,array2) {
    if ( (!array1[0]) || (!array2[0]) ) { 
      return false;
   }
   if (array1.length != array2.length) {
      return false;
   }
   var length = array1.length;
   for (var t=0; t<length; t++) {
       if (array1[t] != array2[t]) {
           return false;
       }
   }
   return true;
}

function searchHiddenSingle() {
    var numbers = [];
    var length;

    //search on all row
    for (var row=0; row<9; row++) {
        for (var t = 1 ; t < 10; t++) {
            numbers[t] = [];
        }
        for (var col=0; col<9; col++) {
            length = cand[rows[row][col]].length;
            for (var value = 0; value < length; value++) {
                numbers[cand[rows[row][col]][value]].push(rows[row][col]);
            }
        }
        for (var p = 1; p < 10; p++) {
            if (numbers[p].length == 1) {
                var index = numbers[p][0];
                //found Hidden Single
                clonecells[index] = p;
                //delete candidate from other cells;
                delsupCandidateCB(index,clonecells); 
                emptycells--;
                return true;
            } 
        }
    } 
    //search on all col
    for (var col=0; col<9; col++) {
        for (var t = 1 ; t < 10; t++) {
            numbers[t] = [];
        }
        for (var row=0; row<9; row++) {
            length = cand[cols[col][row]].length;
            for (var value = 0; value < length; value++) {
                numbers[cand[cols[col][row]][value]].push(cols[col][row]);
            }
        }
        for (var p = 1; p < 10; p++) {
            if (numbers[p].length == 1) {
                var index = numbers[p][0];
                //found Hidden Single
                clonecells[index] = p;
                //delete candidate from other cells
                delsupCandidateRB(index,clonecells);
                emptycells--;
                return true;
            }
        }
    }

    //search on all block
    for (var block = 0; block < 9; block++) {
    for (var t = 1 ; t < 10; t++) {
        numbers[t] = [];
    }
    for (var col = 0; col < 9; col++) {
            length = cand[blocks[block][col]].length;
            for (var value = 0; value < length; value++) {
                numbers[cand[blocks[block][col]][value]].push(blocks[block][col]);
            }
    }
    for (var p = 1; p < 10; p++) {
            if (numbers[p].length == 1) {
                var index = numbers[p][0];
                //found Hidden Single
                clonecells[index] = p;
                //delete candidate from other cells
                delsupCandidateRC(index,clonecells); 
                emptycells--;
                return true;
            }             
        }
    }      
    return false;
}

function searchNakedSingle() {
    var found,index;
    do {
        found = false;
        var start = clonelistemptycells.length - 1; 
        for (var i = start; i > -1; i--) {
            index = clonelistemptycells[i];
            if (cand[index].length == 1) {
                //Found Naked Single
                clonecells[index] = cand[index][0];
                //delete candidate from other cells
                delsupCandidate(index,clonecells); 
                clonelistemptycells.splice(i, 1); 
                emptycells--;
                found = true;  
            }
        }
    } while (found == true) ;
}  

function cloneCells(){
    clonecells = cells.slice(0);   
}
function cloneList(){
    clonelistemptycells = listemptycells.slice(0);
}


function makeValidSudoku() {
    var pos;
    do {
        resetCells();
        resetCandidates();
        //Create Random Blocks 0 4 8
        createRandomBlock(0);
        createRandomBlock(4);
        createRandomBlock(8);

        deleteCandidatebyBlock(0);
        deleteCandidatebyBlock(4);
        deleteCandidatebyBlock(8);
    
        for (var t=0; t<54; t++) { 
            pos = searchCellWithMinorCandidates();
            if (pos > -1) {createRandomCell(pos)};
        }
    }
    while (isSudokuOk() == 0);
}

function resetCells() {
    var t;
    for (t = 0; t < 81; t++) {
        cells[t] = 0;
    }
}
function resetCandidates() {
    var t;
    for (t = 0; t < 81; t++) {
        cand[t]=[1,2,3,4,5,6,7,8,9];
    }
}

function clearCandidates() {
    var t;
    for (t = 0; t < 81; t++) {
        cand[t]=[];
    }
}

function createRandomBlock(i) {
    var r, p; 
    var v = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    for (p = 0; p < 9; p++) {
        r = Math.floor((Math.random() * v.length));
        cells[blocks[i][p]] = v[r];
        cand[blocks[i][p]] = [];
        v.remove(v[r]);
    }  
}

function deleteCandidatebyBlock(i) {
    var p;
    for (p = 0; p < 9; p++) {            
        deleteCandidateRC(blocks[i][p],cells);  
    }
}

function deleteCandidateRC(c,ucells) {
    var row = cellrow[c];
    var col = cellcol[c];
    var p;
    cand[c] = [];
    for (p = 0; p < 9; p++) {
        cand[rows[row][p]].remove(ucells[c]);
        cand[cols[col][p]].remove(ucells[c]);
    }
}

function deleteCandidateRB(c,ucells) {
    var row = cellrow[c];
    var block = cellblock[c];
    var p;
    cand[c] = [];
    for (p = 0; p < 9; p++) {
        cand[rows[row][p]].remove(ucells[c]);
        cand[blocks[block][p]].remove(ucells[c]);
    }
}

function deleteCandidateCB(c,ucells) {
    var col = cellcol[c];
    var block = cellblock[c];
    var p;
    cand[c] = [];
    for (p = 0; p < 9; p++) {
        cand[cols[col][p]].remove(ucells[c]);
        cand[blocks[block][p]].remove(ucells[c]);
    }
}

function deleteCandidate(c,ucells) {
    var row = cellrow[c];
    var col = cellcol[c];
    var block = cellblock[c];
    var p;
    cand[c] = [];
    for (p = 0; p < 9; p++) {
        if (cand[rows[row][p]].length > 0)  { 
            cand[rows[row][p]].remove(ucells[c]);
        }
        if (cand[cols[col][p]].length > 0)  {
        cand[cols[col][p]].remove(ucells[c]);
        }
        if (cand[blocks[block][p]].length > 0)  {
        cand[blocks[block][p]].remove(ucells[c]);
        }
    }
}

function delsupCandidate(c,ucells) {
    var row = cellrow[c];
    var col = cellcol[c];
    var block = cellblock[c];
    var p;
    cand[c] = [];
    for (p = 0; p < 9; p++) {
        cand[rows[row][p]].remove(ucells[c]);
        if (cand[rows[row][p]].length == 1) {
            emptycells--;
            ucells[rows[row][p]] = cand[rows[row][p]][0];
            delsupCandidate(rows[row][p],ucells) 
        }
        cand[cols[col][p]].remove(ucells[c]);
        if (cand[cols[col][p]].length == 1) {
            emptycells--;
            ucells[cols[col][p]] = cand[cols[col][p]][0];
            delsupCandidate(cols[col][p],ucells) 
        }
        cand[blocks[block][p]].remove(ucells[c]);
        if (cand[blocks[block][p]].length == 1) {
            emptycells--;
            ucells[blocks[block][p]] = cand[blocks[block][p]][0];
            delsupCandidate(blocks[block][p],ucells) 
        }
    }
}

function delsupCandidateRC(c,ucells) {
    var row = cellrow[c];
    var col = cellcol[c];
    var p;
    cand[c] = [];
    for (p = 0; p < 9; p++) {
        cand[rows[row][p]].remove(ucells[c]);
        if (cand[rows[row][p]].length == 1) {
            emptycells--;
            ucells[rows[row][p]] = cand[rows[row][p]][0];
            delsupCandidate(rows[row][p],ucells) 
        }
        cand[cols[col][p]].remove(ucells[c]);
        if (cand[cols[col][p]].length == 1) {
            emptycells--;
            ucells[cols[col][p]] = cand[cols[col][p]][0];
            delsupCandidate(cols[col][p],ucells) 
        }
    }
}

function delsupCandidateRB(c,ucells) {
    var row = cellrow[c];
    var block = cellblock[c];
    var p;
    cand[c] = [];
    for (p = 0; p < 9; p++) {
        cand[rows[row][p]].remove(ucells[c]);
        if (cand[rows[row][p]].length == 1) {
            emptycells--;
            ucells[rows[row][p]] = cand[rows[row][p]][0];
            delsupCandidate(rows[row][p],ucells) 
        }
        cand[blocks[block][p]].remove(ucells[c]);
        if (cand[blocks[block][p]].length == 1) {
            emptycells--;
            ucells[blocks[block][p]] = cand[blocks[block][p]][0];
            delsupCandidate(blocks[block][p],ucells) 
        }
    }
}

function delsupCandidateCB(c,ucells) {
    var col = cellcol[c];
    var block = cellblock[c];
    var p;
    cand[c] = [];
    for (p = 0; p < 9; p++) {
        cand[cols[col][p]].remove(ucells[c]);
        if (cand[cols[col][p]].length == 1) {
            emptycells--;
            ucells[cols[col][p]] = cand[cols[col][p]][0];
            delsupCandidate(cols[col][p],ucells) 
        }
        cand[blocks[block][p]].remove(ucells[c]);
        if (cand[blocks[block][p]].length == 1) {
            emptycells--;
            ucells[blocks[block][p]] = cand[blocks[block][p]][0];
            delsupCandidate(blocks[block][p],ucells) 
        }
    }
}

function searchCellWithMinorCandidates() {
    var m = 10;
    var i = -1;
    var l;
    for (var p = 0; p < 81; p++) {
        l = cand[p].length;
        if (l > 0 && l < m) {
            i = p;
            m = l;
        } 
    } 
    return i;
}

function createRandomCell(pos) {
    var r = Math.floor((Math.random() * cand[pos].length));
    cells[pos] = cand[pos][r];
    deleteCandidate(pos,cells);
}

function isSudokuOk() {
   for (var p = 0; p < 81; p++) {
       if (cells[p] == 0) {
           return 0;
       } 
   }
   return 1; 
}

function initialCells(){
    initialcells = cells.slice(0); 
}

function byinitialCells(){
    cells = initialcells.slice(0);    
}

}

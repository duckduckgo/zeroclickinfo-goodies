DDH.life = DDH.life || {};

/*

     Conway's Game of Life

     a cellular automata IA

     see
     https://en.wikipedia.org/wiki/Conway's_Game_of_Life

     russell holt
*/

(function(env) {

    console.log("DDH.life.build");

    var w = 600,
        max_y = 40,
        max_x = 60,
        r = Math.floor(w / max_x);

    var shapes = {
        'point': {
            dim: 1,
            data: [ [ 1 ] ]
        },
        'glider': {
            dim: 3,
            data: [
                [ 1, 1, 0 ],
                [ 1, 0, 1 ],
                [ 1, 0, 0 ]
            ]
        },
        'spaceship' : {
            dim: 5,
            data: [
                [ 0, 0, 0, 0, 0 ],
                [ 1, 0, 0, 1, 0 ],
                [ 0, 0, 0, 0, 1 ],
                [ 1, 0, 0, 0, 1 ],
                [ 0, 1, 1, 1, 1 ]
            ]
        },
        // Gosper Glider Gun
        // data from http://www.argentum.freeserve.co.uk/lex_g.htm#gosperglidergun
        'gosper': {
            dim: 5,
            name: 'Gosper Glider Gun',
            data: [
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                [0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                [1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                [1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            ]
        }
    };




    /* generation
     *
     * returns a new array by applying f to the cells of the old array
     */
    var generation = function(oldarray, f) {
        var ya;
        var x,y;

        var blocks = new Array(max_y);

        for (y=0; y < max_y; y++) {

            ya = new Array(max_x);
            for (x=0; x < max_x; x++) {
                ya[x] = f(x, y, oldarray);
            }
            blocks[y] = ya;
        }
        return blocks;
    };


    /*
     *  blife - a generation cell function
     */
    var blife = function(x,y, a) {
        var n = 0,
            alive = a[y][x];

        // check out the neighbors
        // this version wraps around with modulus
        n += a[(y - 1 + max_y) % max_y][(x - 1 + max_x) % max_x];
        n += a[(y - 1 + max_y) % max_y][ x                     ];
        n += a[(y - 1 + max_y) % max_y][(x + 1 + max_x) % max_x];

        n += a[ y                     ][(x - 1 + max_x) % max_x];
        n += a[ y                     ][(x + 1 + max_x) % max_x];

        n += a[(y + 1 + max_y) % max_y][(x - 1 + max_x) % max_x];
        n += a[(y + 1 + max_y) % max_y][ x                     ];
        n += a[(y + 1 + max_y) % max_y][(x + 1 + max_x) % max_x];

        // apply the rules of life
        return (!alive && n == 3) ? 1 : (alive && n == 2 || n == 3) ? 1 : 0;
    }


    /*
     * draw the array onto the canvas
     */
    var draw = function (gen, canvas, ghost, prev) {
        var ctx = canvas.getContext("2d"),
            m = 20,
            x, y,
            rgb_alive = "rgb(30,30,30)",
            rgb_ghost = "rgba(255,255,255,0.7)",
            rgb_dead  = "rgb(255,255,255)";

        for (y=0; y < max_y; y++) {
            for (x=0; x < max_x; x++) {

                if (ghost) {
                    ctx.fillStyle = prev[y][x] ? rgb_ghost : rgb_dead;
                    ctx.fillRect(x*r, y*r, r, r);

                    if (gen[y][x]) {
                        ctx.fillStyle = rgb_alive;
                        ctx.fillRect(x*r, y*r, r, r);
                    }
                }
                else {
                    ctx.fillStyle = gen[y][x] ? rgb_alive : rgb_dead;
                    ctx.fillRect(x*r, y*r, r, r);
                }

            }
        }
    }


    var life_timer;
    var prevarray;
    var newarray;
    var canvas;
    var shape = 'glider';

    var life_setup = function() {
        if (canvas) {
            return;
        }

        canvas = document.getElementById('zci--life-canvas');

        canvas.addEventListener('click', function(e) {

            var rect = canvas.getBoundingClientRect(),
                x = e.clientX - rect.left,
                y = e.clientY - rect.top,
                xr = Math.floor(x/r),
                yr = Math.floor(y/r),
                i, j, obj, dimx, dimy;

            // special case for 'point' since we want to toggle. could be normal behavior for all shape points, but..
            if (shape == 'point') {
                prevarray[yr][xr] = ! prevarray[yr][xr];
            }
            else {
                obj = shapes[shape].data,
                dimy = obj.length, 
                dimx = shapes[shape].data[0].length; 

                for (i=0; i<dimy; i++) {
                    for (j=0; j<dimx; j++) {
                        prevarray[yr + i][xr + j] = obj[i][j];  // += would overlay, ie draw only alive cells. might xor to generalize.
                    }
                }
            }

            draw(prevarray, canvas);
        });

    };

    DDH.life.start = function() {
        life_setup();

        DDH.life.stop();
        life_timer = window.setInterval(DDH.life.step, 100);
    };

    DDH.life.step = function() {
        life_setup();
        newarray = generation(prevarray, blife);
        draw(newarray, canvas, 1, prevarray);
        prevarray = newarray;
    };

    DDH.life.stop = function() {
        if (life_timer)
            window.clearInterval(life_timer);
    };

    DDH.life.randomize = function() {
        life_setup();
        prevarray = generation(null, function() { return Math.random() > 0.6; } );
        draw(prevarray, canvas);
    };

    DDH.life.clear = function() {
        life_setup();
        prevarray = generation(null, function() { return false; } );
        DDH.life.step();
    };

    DDH.life.setShape = function(s) {
        console.log("set shape to %s", s);
        $(".zci--life-b").removeClass('zci--life-selected');
        $(".life-" + s).addClass('zci--life-selected');
        shape = s;
    };


    DDH.life.build = function(ops) {
        
        return {
            id: "life",
            meta: {
            },

            onShow: function() {
                life_setup();
                if (!prevarray) {
                    DDH.life.randomize();
                    DDH.life.start();
                }
            },
            
            templates: {
                group: 'base',
                item: 'DDH.life.content',
                detail: 0,
                // options: {
                //     content: 'DDH.life.content'
                // }
            }
            
        };
    };
})(DDH);

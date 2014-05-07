#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'calendartoday';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::CalendarToday
	)],
	'calendar nov 2014' => test_zci("
S M T W T F S      November 2014
                          1
  2   3   4   5   6   7   8
  9  10  11  12  13  14  15
 16  17  18  19  20  21  22
 23  24  25  26  27  28  29
 30
",
        html => qq(<style type='text/css'>table.calendar { text-align: center; }.calendar th, .calendar td { width:2.5em; text-align:center; }.calendar__header { vertical-align: top; height: 2em; font-size: 1.25em; }.calendar__today { color:white; background-color: #808080; }
</style>
<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2014</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td></tr><tr><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td></tr><tr><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td></tr><tr><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td></tr><tr><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td><td>29</td></tr><tr><td>30</td></tr></table>")
	),
	'2015 nov calendar' => test_zci("
S M T W T F S      November 2015
  1   2   3   4   5   6   7
  8   9  10  11  12  13  14
 15  16  17  18  19  20  21
 22  23  24  25  26  27  28
 29  30
",
        html => qq(<style type='text/css'>table.calendar { text-align: center; }.calendar th, .calendar td { width:2.5em; text-align:center; }.calendar__header { vertical-align: top; height: 2em; font-size: 1.25em; }.calendar__today { color:white; background-color: #808080; }
</style>
<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2015</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td>29</td><td>30</td></tr></table>)
	),
	'calendar 10 nov 2012' => test_zci("
S M T W T F S      November 2012
                  1   2   3
  4   5   6   7   8   9 |10|
 11  12  13  14  15  16  17
 18  19  20  21  22  23  24
 25  26  27  28  29  30
", 
		html => qq(<style type='text/css'>table.calendar { text-align: center; }.calendar th, .calendar td { width:2.5em; text-align:center; }.calendar__header { vertical-align: top; height: 2em; font-size: 1.25em; }.calendar__today { color:white; background-color: #808080; }
</style>
<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2012</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td><span class="class="calendar__today  circle">10</span></td></div></tr><tr><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td></tr><tr><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td></tr><tr><td>25</td><td>26</td><td>27</td><td>28</td><td>29</td><td>30</td></tr></table>)
	),
	'calendar 10.11.12' => test_zci("
S M T W T F S      November 2012
                  1   2   3
  4   5   6   7   8   9 |10|
 11  12  13  14  15  16  17
 18  19  20  21  22  23  24
 25  26  27  28  29  30 
", 
		html => qq(<style type='text/css'>table.calendar { text-align: center; }.calendar th, .calendar td { width:2.5em; text-align:center; }.calendar__header { vertical-align: top; height: 2em; font-size: 1.25em; }.calendar__today { color:white; background-color: #808080; }
</style>
<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2012</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td><span class="class="calendar__today  circle">10</span></td></div></tr><tr><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td></tr><tr><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td></tr><tr><td>25</td><td>26</td><td>27</td><td>28</td><td>29</td><td>30</td></tr></table>)
	),
	'calendar 2012-11-10' => test_zci("
S M T W T F S      November 2012
                  1   2   3
  4   5   6   7   8   9 |10|
 11  12  13  14  15  16  17
 18  19  20  21  22  23  24
 25  26  27  28  29  30
", 
		html => qq(<style type='text/css'>table.calendar { text-align: center; }.calendar th, .calendar td { width:2.5em; text-align:center; }.calendar__header { vertical-align: top; height: 2em; font-size: 1.25em; }.calendar__today { color:white; background-color: #808080; }
</style>
<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2012</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td><span class="class="calendar__today  circle">10</span></td></div></tr><tr><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td></tr><tr><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td></tr><tr><td>25</td><td>26</td><td>27</td><td>28</td><td>29</td><td>30</td></tr></table>)
	),
	'cal 29 2 2016' => test_zci("
S M T W T F S      February 2016
      1   2   3   4   5   6
  7   8   9  10  11  12  13
 14  15  16  17  18  19  20
 21  22  23  24  25  26  27
 28 |29|
", 
		html => qq(<style type='text/css'>table.calendar { text-align: center; }.calendar th, .calendar td { width:2.5em; text-align:center; }.calendar__header { vertical-align: top; height: 2em; font-size: 1.25em; }.calendar__today { color:white; background-color: #808080; }
</style>
<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>February 2016</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>&nbsp;</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td></tr><tr><td>14</td><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td></tr><tr><td>21</td><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td></tr><tr><td>28</td><td><span class="class="calendar__today  circle">29</span></td></div></tr></table>)
	),
	'cal 29 2 2015' => undef,
	'calendar nov 1899' => undef,
	'calendar nov asdf' => undef,
	'calendar 2015' => undef,
	'calendar next year' => undef,
	'next calendar' => undef,
	'julian calendar' => undef,
);

done_testing;

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
Sun Mon Tue Wed Thu Fri Sat      November 2014
                          1 
  2   3   4   5   6   7   8 
  9  10  11  12  13  14  15 
 16  17  18  19  20  21  22 
 23  24  25  26  27  28  29 
 30 
", 
		html => qq(<style type='text/css'>#zero_click_abstract table { text-align: center; }
#zero_click_abstract th { width:40px; text-align:center; }
#zero_click_abstract th.zero_click_abstract_header { width:150px; text-align:left; vertical-align: top; }
#zero_click_abstract td.zero_click_abstract_today { color:white; background-color: #808080; }
</style>
<table><tr><th class="zero_click_abstract_header" rowspan="7">November 2014</th><th>&nbsp;Sun</th><th>&nbsp;Mon</th><th>&nbsp;Tue</th><th>&nbsp;Wed</th><th>&nbsp;Thu</th><th>&nbsp;Fri</th><th>&nbsp;Sat</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td></tr><tr><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td></tr><tr><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td></tr><tr><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td></tr><tr><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td><td>29</td></tr><tr><td>30</td></tr></table>)
	),
	'2015 nov calendar' => test_zci("
Sun Mon Tue Wed Thu Fri Sat      November 2015
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
 29  30 
", 
		html => qq(<style type='text/css'>#zero_click_abstract table { text-align: center; }
#zero_click_abstract th { width:40px; text-align:center; }
#zero_click_abstract th.zero_click_abstract_header { width:150px; text-align:left; vertical-align: top; }
#zero_click_abstract td.zero_click_abstract_today { color:white; background-color: #808080; }
</style>
<table><tr><th class="zero_click_abstract_header" rowspan="7">November 2015</th><th>&nbsp;Sun</th><th>&nbsp;Mon</th><th>&nbsp;Tue</th><th>&nbsp;Wed</th><th>&nbsp;Thu</th><th>&nbsp;Fri</th><th>&nbsp;Sat</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td>29</td><td>30</td></tr></table>)
	),
	'calendar 10 nov 2012' => test_zci("
Sun Mon Tue Wed Thu Fri Sat      November 2012
                  1   2   3 
  4   5   6   7   8   9 |10|
 11  12  13  14  15  16  17 
 18  19  20  21  22  23  24 
 25  26  27  28  29  30 
", 
		html => qq(<style type='text/css'>#zero_click_abstract table { text-align: center; }
#zero_click_abstract th { width:40px; text-align:center; }
#zero_click_abstract th.zero_click_abstract_header { width:150px; text-align:left; vertical-align: top; }
#zero_click_abstract td.zero_click_abstract_today { color:white; background-color: #808080; }
</style>
<table><tr><th class="zero_click_abstract_header" rowspan="7">November 2012</th><th>&nbsp;Sun</th><th>&nbsp;Mon</th><th>&nbsp;Tue</th><th>&nbsp;Wed</th><th>&nbsp;Thu</th><th>&nbsp;Fri</th><th>&nbsp;Sat</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td class="zero_click_abstract_today">10</td></div></tr><tr><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td></tr><tr><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td></tr><tr><td>25</td><td>26</td><td>27</td><td>28</td><td>29</td><td>30</td></tr></table>)
	),
	'calendar 10.11.12' => test_zci("
Sun Mon Tue Wed Thu Fri Sat      November 2012
                  1   2   3 
  4   5   6   7   8   9 |10|
 11  12  13  14  15  16  17 
 18  19  20  21  22  23  24 
 25  26  27  28  29  30 
", 
		html => qq(<style type='text/css'>#zero_click_abstract table { text-align: center; }
#zero_click_abstract th { width:40px; text-align:center; }
#zero_click_abstract th.zero_click_abstract_header { width:150px; text-align:left; vertical-align: top; }
#zero_click_abstract td.zero_click_abstract_today { color:white; background-color: #808080; }
</style>
<table><tr><th class="zero_click_abstract_header" rowspan="7">November 2012</th><th>&nbsp;Sun</th><th>&nbsp;Mon</th><th>&nbsp;Tue</th><th>&nbsp;Wed</th><th>&nbsp;Thu</th><th>&nbsp;Fri</th><th>&nbsp;Sat</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td class="zero_click_abstract_today">10</td></div></tr><tr><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td></tr><tr><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td></tr><tr><td>25</td><td>26</td><td>27</td><td>28</td><td>29</td><td>30</td></tr></table>)
	),
	'calendar 2012-11-10' => test_zci("
Sun Mon Tue Wed Thu Fri Sat      November 2012
                  1   2   3 
  4   5   6   7   8   9 |10|
 11  12  13  14  15  16  17 
 18  19  20  21  22  23  24 
 25  26  27  28  29  30 
", 
		html => qq(<style type='text/css'>#zero_click_abstract table { text-align: center; }
#zero_click_abstract th { width:40px; text-align:center; }
#zero_click_abstract th.zero_click_abstract_header { width:150px; text-align:left; vertical-align: top; }
#zero_click_abstract td.zero_click_abstract_today { color:white; background-color: #808080; }
</style>
<table><tr><th class="zero_click_abstract_header" rowspan="7">November 2012</th><th>&nbsp;Sun</th><th>&nbsp;Mon</th><th>&nbsp;Tue</th><th>&nbsp;Wed</th><th>&nbsp;Thu</th><th>&nbsp;Fri</th><th>&nbsp;Sat</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td></tr><tr><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td class="zero_click_abstract_today">10</td></div></tr><tr><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td></tr><tr><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td></tr><tr><td>25</td><td>26</td><td>27</td><td>28</td><td>29</td><td>30</td></tr></table>)
	),
	'cal 29 2 2016' => test_zci("
Sun Mon Tue Wed Thu Fri Sat      February 2016
      1   2   3   4   5   6 
  7   8   9  10  11  12  13 
 14  15  16  17  18  19  20 
 21  22  23  24  25  26  27 
 28 |29|
", 
		html => qq(<style type='text/css'>#zero_click_abstract table { text-align: center; }
#zero_click_abstract th { width:40px; text-align:center; }
#zero_click_abstract th.zero_click_abstract_header { width:150px; text-align:left; vertical-align: top; }
#zero_click_abstract td.zero_click_abstract_today { color:white; background-color: #808080; }
</style>
<table><tr><th class="zero_click_abstract_header" rowspan="7">February 2016</th><th>&nbsp;Sun</th><th>&nbsp;Mon</th><th>&nbsp;Tue</th><th>&nbsp;Wed</th><th>&nbsp;Thu</th><th>&nbsp;Fri</th><th>&nbsp;Sat</th></tr><tr><td>&nbsp;</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td></tr><tr><td>7</td><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td></tr><tr><td>14</td><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td></tr><tr><td>21</td><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td></tr><tr><td>28</td><td class="zero_click_abstract_today">29</td></div></tr></table>)
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

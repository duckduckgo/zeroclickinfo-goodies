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
	'calendar feb 2001' => test_zci("
Sun Mon Tue Wed Thu Fri Sat      February 2001
                  1   2   3 
  4   5   6   7   8   9  10 
 11  12  13  14  15  16  17 
 18  19  20  21  22  23  24 
 25  26  27  28 
", 
		html => qq(<table style="text-align:center;"><tr><th style="width:150px; text-align:left;">February 2001</th><th style="width:40px; text-align:center;">Sun</th><th style="width:40px; text-align:center;">Mon</th><th style="width:40px; text-align:center;">Tue</th><th style="width:40px; text-align:center;">Wed</th><th style="width:40px; text-align:center;">Thu</th><th style="width:40px; text-align:center;">Fri</th><th style="width:40px; text-align:center;">Sat</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td></tr><tr><td>&nbsp;</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td>10</td></tr><tr><td>&nbsp;</td><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td></tr><tr><td>&nbsp;</td><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td><td>23</td><td>24</td></tr><tr><td>&nbsp;</td><td>25</td><td>26</td><td>27</td><td>28</td></tr></table>)
	),
	'calendar february 2016' => test_zci("
Sun Mon Tue Wed Thu Fri Sat      February 2016
      1   2   3   4   5   6 
  7   8   9  10  11  12  13 
 14  15  16  17  18  19  20 
 21  22  23  24  25  26  27 
 28  29 
", 
		html => qq(<table style="text-align:center;"><tr><th style="width:150px; text-align:left;">February 2016</th><th style="width:40px; text-align:center;">Sun</th><th style="width:40px; text-align:center;">Mon</th><th style="width:40px; text-align:center;">Tue</th><th style="width:40px; text-align:center;">Wed</th><th style="width:40px; text-align:center;">Thu</th><th style="width:40px; text-align:center;">Fri</th><th style="width:40px; text-align:center;">Sat</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td></tr><tr><td>&nbsp;</td><td>7</td><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td></tr><tr><td>&nbsp;</td><td>14</td><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td></tr><tr><td>&nbsp;</td><td>21</td><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td></tr><tr><td>&nbsp;</td><td>28</td><td>29</td></tr></table>)
	),
	'feb 2014 calendar' => test_zci("
Sun Mon Tue Wed Thu Fri Sat      February 2014
                          1 
  2   3   4   5   6   7   8 
  9  10  11  12  13  14  15 
 16  17  18  19  20  21  22 
 23  24  25  26  27  28 
", 
		html => qq(<table style="text-align:center;"><tr><th style="width:150px; text-align:left;">February 2014</th><th style="width:40px; text-align:center;">Sun</th><th style="width:40px; text-align:center;">Mon</th><th style="width:40px; text-align:center;">Tue</th><th style="width:40px; text-align:center;">Wed</th><th style="width:40px; text-align:center;">Thu</th><th style="width:40px; text-align:center;">Fri</th><th style="width:40px; text-align:center;">Sat</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td></tr><tr><td>&nbsp;</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td></tr><tr><td>&nbsp;</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td></tr><tr><td>&nbsp;</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td></tr><tr><td>&nbsp;</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr></table>)
	),
	'calendar 2015' => undef,
	'calendar asdf' => undef,
);

done_testing;

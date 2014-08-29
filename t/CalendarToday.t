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
    'calendar' => test_zci(qr/\nS M T W T F S[ ]+[A-Za-z]+ [0-9]{4}\n.+/, html => qr#<table class="calendar".+calendar__today.+</table>#),
    'calendar november' => test_zci(qr/\nS M T W T F S      November [0-9]{4}\n.+/, html => qr#<table class="calendar".+</table>#),
    'calendar last november' => test_zci(qr/\nS M T W T F S      November [0-9]{4}\n.+/, html => qr#<table class="calendar".+</table>#),
    'calendar next november' => test_zci(qr/\nS M T W T F S      November [0-9]{4}\n.+/, html => qr#<table class="calendar".+</table>#),
    'calendar november 2009' => test_zci("
S M T W T F S      November 2009
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
 29  30 
", html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2009</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td>29</td><td>30</td></tr></table>#),
    'calendar nov 2009' => test_zci("
S M T W T F S      November 2009
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
 29  30 
", html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2009</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td>29</td><td>30</td></tr></table>#),
    'calendar 29 nov 2015' => test_zci("
S M T W T F S      November 2015
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
|29| 30 
", html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2015</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td><span class="calendar__today circle">29</span></td><td>30</td></tr></table>#),
    'calendar 29.11.2015' => test_zci("
S M T W T F S      November 2015
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
|29| 30 
", html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2015</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td><span class="calendar__today circle">29</span></td><td>30</td></tr></table>#),
    'cal 1980-11-29' => test_zci("
S M T W T F S      November 1980
                          1 
  2   3   4   5   6   7   8 
  9  10  11  12  13  14  15 
 16  17  18  19  20  21  22 
 23  24  25  26  27  28 |29|
 30 
", html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 1980</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td></tr><tr><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td></tr><tr><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td></tr><tr><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td></tr><tr><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td><td><span class="calendar__today circle">29</span></td></tr><tr><td>30</td></tr></table>#),
);

done_testing;


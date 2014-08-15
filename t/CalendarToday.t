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
    'calendar' => test_zci(qr/.+/, html => qr#<table class="calendar".+</table>#),
    'calendar november' => test_zci(qr/.+/, html => qr#<table class="calendar".+</table>#),
    'calendar next november' => test_zci(qr/.+/, html => qr#<table class="calendar".+</table>#),
    'calendar november 2015' => test_zci(qr/.+/, html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2015</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td>29</td><td>30</td></tr></table>#),
    'calendar 29 nov 2015' => test_zci(qr/.+/, html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2015</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td><span class="calendar__today circle">29</span></td></div><td>30</td></tr></table>#),
    'calendar 29.11.2015' => test_zci(qr/.+/, html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 2015</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td></tr><tr><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td></tr><tr><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td></tr><tr><td>22</td><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td></tr><tr><td><span class="calendar__today circle">29</span></td></div><td>30</td></tr></table>#),
    'cal 1980-11-29' => test_zci(qr/.+/, html => qr#<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>November 1980</b></th></tr><tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>1</td></tr><tr><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td></tr><tr><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td></tr><tr><td>16</td><td>17</td><td>18</td><td>19</td><td>20</td><td>21</td><td>22</td></tr><tr><td>23</td><td>24</td><td>25</td><td>26</td><td>27</td><td>28</td><td><span class="calendar__today circle">29</span></td></div></tr><tr><td>30</td></tr></table>#),
);

done_testing;


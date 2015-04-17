#!/usr/bin/python
# -*- coding: utf-8 -*-
# 
# Released under the GPL v2 license
# https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
# 

import sys

__author__ = 'mcavallaro'

out_file = 'igem_cat.html'
in_file = 'igem_cat.txt'
with open(in_file, 'r') as f:
    with open(out_file, 'w') as e:
        e.write('<div class="igem-container">\n')
        e.write('\t<tr><b>Categories in iGem database</b></tr>\n')
        e.write('\t<div class="igem-column">\n')
        e.write('\t\t<table class="igem-table">\n')
        for lines in f.readlines():
            e.write('\t\t\t<tr><td>' + lines.strip('\n') + '</td></tr>\n')   #         Rect Select</td></tr>

        e.write('\t\t</table>\n')
        e.write('\t</div>\n')
        e.write('</div>\n')
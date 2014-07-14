#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'geometry';

#If someone knows a better way to include a share file here, let me know
my $markup = '<style type="text/css">
	#zci--geometry-svg{float: right; fill: transparent}
	#zci--geometry-svg:hover text{fill: black; text-anchor: middle}
	#zci--geometry-svg .stroke{stroke: black; stroke-width: 1.8; stroke-linejoin: round}
	#zci--geometry-svg .stroke.backface{stroke-width: 1}
	#zci--geometry-svg .stroke.special{stroke-dasharray: 5,5}
	#zci--geometry-svg .stroke[data-formula]:hover, #zci--geometry-svg .stroke.hover{stroke: #1168CE}
	#zci--geometry-svg .stroke.special:hover, #zci--geometry-svg .stroke.special.hover{stroke-dasharray: none}
	#zci--geometry-svg .fill:hover, #zci--geometry-svg .fill.hover{fill: #4C96EE}

	#zci--geometry-formulas div:hover, #zci--geometry-formulas div.hover{color: #1168CE}
</style>
<script type="text/javascript">
$(document).ready(function(){
	//get all formulas
	$("#zci--geometry-formulas div").each(function(){
		//get the svg shape (it has the data-formula attribute with the first letter of the formula)
		var svg = $("#zci--geometry-svg [data-formula=" + $(this).text()[0] + "]");
		var formula = this;
		//No svg shape for this formula
		if(!svg.length) return;
		//this is for the double-hover effect
		//if the formula is hovered, the class hover is added to the svg shape
		$(this).hover(function(){
			svg.each(function(){
				this.classList.add("hover");
			});
		}, function(){
			svg.each(function(){
				this.classList.remove("hover");
			});
		});

		//if the svg shape is hovered, the class hover is added to the formula
		svg.hover(function(){
			formula.classList.add("hover");
		}, function(){
			formula.classList.remove("hover");
		});
	});
});
</script>
<!-- Note: this SVG tag is closed by the goodie -->
<svg id="zci--geometry-svg" width="140" height="110">
';

sub makehtml {
	my ($html, $svg) = @_;
	return $markup.$svg.'</svg><div id="zci--geometry-formulas"><div>'.$html.'</div></div>';
}

ddg_goodie_test(
	['DDG::Goodie::Geometry'],
	'formula circle perimeter' => test_zci('u = 2'.chr(960).'r', html => makehtml('u = 2&pi;r', '<circle cx="70" cy="55" r="35" class="fill" data-formula="A"></circle>
			<circle cx="70" cy="55" r="35" class="stroke" data-formula="u"></circle>')),
	'calc circle area with radius = 3' => test_zci('A = '.chr(960).'r'.chr(178).' = 28.2743338823081', html => makehtml('A = &pi;r<sup>2</sup> = 28.2743338823081', '<circle cx="70" cy="55" r="35" class="fill" data-formula="A"></circle>
			<circle cx="70" cy="55" r="35" class="stroke" data-formula="u"></circle>')),
	'geometry cube volume length 50.6' => test_zci('V = a'.chr(179).' = 129554.216', html => makehtml('V = a<sup>3</sup> = 129554.216', '<path d="M 37,88 v -44 l 22,-22 h 44 v 44 l -22 22 z" class="fill" data-formula="A"></path>
			<path d="M 37,88 l 22,-22 v -44 v 44 h 44" class="stroke backface"></path>
			<path d="M 37,44 l 66,22" class="stroke special" data-formula="e"></path>
			<path d="M 37,88 v -44 l 22,-22 h 44 v 44 l -22 22 z" class="fill" data-formula="V"></path>
			<path d="M 37,44 h 44 v 44 h -44 v -44 l 22,-22 h 44 v 44 l -22,22 v -44 l 22,-22" class="stroke"></path>')),
	'calc equilateral triangle perimeter' => test_zci('u = 3a', html => makehtml('u = 3a', '<path d="M 70,20 l 40,70 h -80 z" class="stroke" data-formula="u"></path>
			<path d="M 70,20 l 40,70 h -80 z" class="fill" data-formula="A"></path>')),
	'formula ball volume' => test_zci('V = 4/3'.chr(960).'r'.chr(179), html => makehtml('V = 4/3&pi;r<sup>3</sup>', '<circle class="fill" cx="70" cy="55" r="35" data-formula="A"></circle>
			<path d="M 35,55 a 35 10 0 0 1 70,0" class="stroke backface"></path>
			<circle class="fill" cx="70" cy="55" r="35" data-formula="V"></circle>
			<path d="M 35,55 a 35 10 0 1 0 70,0 a 35 35 0 0 0 -70,0 a 35 35 0 0 0 70,0" class="stroke"></path>')),
	'geometry rectangle area a = 5,2, b = 10' => test_zci('A = ab = 52', html => makehtml('A = ab = 52', '<path d="M 20,20 h 100 v 70 h -100 z" class="fill" data-formula="A"></path>
			<path d="M 20,20 h 100 v 70 h -100 z" class="stroke" data-formula="u"></path>
			<path d="M 20,20 l 100,70" class="stroke special" data-formula="e"></path>')),
	'geometry cuboid volume a: 5; b: 3; c: 4' => test_zci('V = abc = 60', html => makehtml('V = abc = 60', '<path d="M 20,90 v -50 l 20,-20 h 80 v 50 l -20 20 z" class="fill" data-formula="A"></path>
			<path d="M 20,90 l 20,-20 v -50 v 50 h 80" class="stroke backface"></path>
			<path d="M 20,40 l 100,30" class="stroke special" data-formula="e"></path>
			<path d="M 20,90 v -50 l 20,-20 h 80 v 50 l -20 20 z" class="fill" data-formula="V"></path>
			<path d="M 20,40 h 80 v 50 h -80 v -50 l 20,-20 h 80 v 50 l -20,20 v -50 l 20,-20" class="stroke"></path>'))
);

done_testing;

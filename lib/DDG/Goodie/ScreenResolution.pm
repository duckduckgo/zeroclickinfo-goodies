package DDG::Goodie::ScreenResolution;
#ABSTRACT: Displays the screen resolution.

use DDG::Goodie;
use warnings;
use strict;

name 'ScreenResolution';
description 'Displays the screen resolution';
category 'computing_info';
topics 'everyday', 'computing';
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/ScreenResolution.pm";
attribution web => ["http://nishanths.github.io", "Nishanth Shanmugham"],
    		github => [ "https://github.com/nishanths", "Nishanth Shanmugham"],
    		twitter => ["nshanmugham", "Nishanth Shanmugham"];
zci answer_type => 'screen_resolution';

sub create_html_and_js {
	# No input parameters
	# Returns a string that contains the HTML, CSS styles and JavaScript to display the answer
	my $html = 
	qq(
		<style type="text/css">
		.goodie_screen-resolution-nums {
			font-size: 1.2em;
		}
		#goodie_screen-resolution-android-issue {
			font-size: 0.8em;
		}
		</style>
		<div>
			<span id="goodie_screen-resolution-display">
				<span id="goodie_screen-resolution-horizontal" class="goodie_screen-resolution-nums"></span>
				<span>x</span>
				<span id="goodie_screen-resolution-vertical" class="goodie_screen-resolution-nums"></span>
				pixels&nbsp;
				(<span id="goodie_screen-resolution-ratio1"></span>:<span id="goodie_screen-resolution-ratio2"></span>)
			</span>
				<span id="goodie_screen-resolution-android-issue"></span>
		</div>
		<script type="text/javascript">
			(function(){
				// Dealing with the Android screen resolution issue
				var ua = window.navigator.userAgent;
				if (ua.indexOf('Android') !== -1) { // user-agent is Android if the expression is true 
					document.getElementById("goodie_screen-resolution-android-issue").innerHTML = "<div>[This answer may be inaccurate on your Android device]</div>";
					// uncomment the next two lines to not display ANY resolution numbers on Androids
					// document.getElementById('goodie_screen-resolution-display').style.display = 'none';
					// return;
				}
				// Resolution
				var goodie_screen_resolution_horizontal = screen.width;
				var goodie_screen_resolution_vertical = screen.height;
				document.getElementById("goodie_screen-resolution-horizontal").innerHTML = goodie_screen_resolution_horizontal;
				document.getElementById("goodie_screen-resolution-vertical").innerHTML = goodie_screen_resolution_vertical;
				// Aspect ratio
				var goodie_screen_resolution_denom = goodie_screen_resolution_gcd(goodie_screen_resolution_horizontal, goodie_screen_resolution_vertical);
				var goodie_screen_resolution_ratio1 = goodie_screen_resolution_horizontal / goodie_screen_resolution_denom;
				var goodie_screen_resolution_ratio2 = goodie_screen_resolution_vertical / goodie_screen_resolution_denom;
				document.getElementById("goodie_screen-resolution-ratio1").innerHTML = goodie_screen_resolution_ratio1;
				document.getElementById("goodie_screen-resolution-ratio2").innerHTML = goodie_screen_resolution_ratio2;

				function goodie_screen_resolution_gcd(m,n) {
					if (n == 0) {
						return m;
					} return goodie_screen_resolution_gcd(n, m % n);
				}
			})();
		</script>
	);
	return $html;
};

triggers start => 'screen resolution', 'display resolution';
primary_example_queries 'screen resolution', 'display resolution', 'screen resolution  ';

handle remainder => sub {
	$_ =~ s/^\s*//g;					# remove any leading whitespace in the remainder
	return if $_; 						# query has more stuff than just the trigger that brought us in here
	my $html = create_html_and_js();
	return "Screen resolution", html => $html;
};
1;

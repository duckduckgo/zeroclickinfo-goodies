#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'screen_resolution';

ddg_goodie_test(
	[qw(DDG::Goodie::ScreenResolution)],

	# Test 1
		'screen resolution' => test_zci(
		"Screen resolution",
		html =>
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
	),
	),

	# Test 2
		'display resolution' => test_zci(
		"Screen resolution",
		html => 
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
	),
	),

	# Test 3
		'screen resolution ' => test_zci(
		"Screen resolution",
		html => 
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
	),
	),


);

done_testing;

package DDG::Goodie::TestJavascript;

use DDG::Goodie;

triggers start => 'test';

handle remainder => sub {
	if($_){
		return html => "<script>
</script>
<p>Click the button to trigger a function.</p>

<button onclick='alert(" . $_ . ")'>Click me</button>
";
	}
    return;
};
1;

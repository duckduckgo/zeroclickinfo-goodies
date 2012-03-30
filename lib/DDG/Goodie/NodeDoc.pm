package DDG::Goodie::NodeDoc;
# ABSTRACT: Returns Node.js Documentation
# github.com/runexec

use 5.010;
use DDG::Goodie;

triggers start => 'nodedoc';

handle remainder => sub {
	my $nodeModule = $_;
	given( $nodeModule ) {
		when( 'globals' ) 		{ return '<a href="http://nodejs.org/api/globals.html">Node.js Globals</a>'; }
		when( 'stdio' ) 		{ return '<a href="http://nodejs.org/api/stdio.html">Node.js STDIO</a>'; }
		when( 'timers' ) 		{ return '<a href="http://nodejs.org/api/timers.html">Node.js Timers</a>'; }
		when( 'modules' )		{ return '<a href="http://nodejs.org/api/modules.html">Node.js Modules</a>'; }
		when( 'process' ) 		{ return '<a href="http://nodejs.org/api/process.html">Node.js Process</a>'; }
		when( 'utilities' ) 	{ return '<a href="http://nodejs.org/api/util.html">Node.js Utilities</a>'; }
		when( 'events' ) 		{ return '<a href="http://nodejs.org/api/events.html">Node.js Events</a>'; }
		when( 'buffer' ) 		{ return '<a href="http://nodejs.org/api/buffer.html">Node.js Buffer</a>'; }
		when( 'stream' ) 		{ return '<a href="http://nodejs.org/api/stream.html">Node.js Stream</a>'; }
		when( 'crypto' ) 		{ return '<a href="http://nodejs.org/api/crypto.html">Node.js Crypto</a>'; }
		when( 'tls' ) 			{ return '<a href="http://nodejs.org/api/tls.html">Node.js TLS/SSL</a>'; }
		when( 'filesystem' ) 	{ return '<a href="http://nodejs.org/api/fs.html">Node.js Filesystem</a>'; }
		when( 'path' ) 			{ return '<a href="http://nodejs.org/api/path.html">Node.js Path</a>'; }
		when( 'net' ) 			{ return '<a href="http://nodejs.org/api/net.html">Node.js Net</a>'; }
		when( 'dgram' ) 		{ return '<a href="http://nodejs.org/api/dgram.html">Node.js UDP</a>'; }
		when( 'dns' ) 			{ return '<a href="http://nodejs.org/api/dns.html">Node.js DNS</a>'; }
		when( 'http' ) 			{ return '<a href="http://nodejs.org/api/http.html">Node.js HTTP</a>'; }
		when( 'https' ) 		{ return '<a href="http://nodejs.org/api/https.html">Node.js HTTPS</a>'; }
		when( 'url' ) 			{ return '<a href="http://nodejs.org/api/url.html">Node.js URL</a>'; }
		when( 'querystring' ) 	{ return '<a href="http://nodejs.org/api/querystring.html">Node.js Query Strings</a>'; }
		when( 'readline' ) 		{ return '<a href="http://nodejs.org/api/readline.html">Node.js ReadLine</a>'; }
		when( 'repl' ) 			{ return '<a href="http://nodejs.org/api/repl.html">Node.js REPL</a>'; }
		when( 'vm' ) 			{ return '<a href="http://nodejs.org/api/vm.html">Node.js VirtualMachine</a>'; }
		when( 'child_process' ) { return '<a href="http://nodejs.org/api/child_process.html">Node.js Child Process</a>'; }
		when( 'assert' ) 		{ return '<a href="http://nodejs.org/api/assert.html">Node.js Assert</a>'; }
		when( 'tty' ) 			{ return '<a href="http://nodejs.org/api/tty.html">Node.js TTY</a>'; }
		when( 'zlib' ) 			{ return '<a href="http://nodejs.org/api/zlib.html">Node.js ZLIB</a>'; }
		when( 'os' )			{ return '<a href="http://nodejs.org/api/os.html">Node.js OS</a>'; }
		when( 'debugger' ) 		{ return '<a href="http://nodejs.org/api/debugger.html">Node.js Debugger</a>'; }
		when( 'cluster' ) 		{ return '<a href="http://nodejs.org/api/cluster.html">Node.js Cluster</a>'; }
		default					{ return '<a href="http://nodejs.org/api/index.html">Node.js API</a>'; }
	}
	return;
};

zci is_cached => 1;

1;

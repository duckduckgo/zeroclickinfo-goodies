package DDG::Goodie::Notepad;

use DDG::Goodie;

triggers start => 'notepad', 'editor', 'writing space', 'jotter', 'textarea';
handle remainder => sub{
	return "You can view a notepad on the web",html => scalar share("notepad.html")->slurp;
};

1;

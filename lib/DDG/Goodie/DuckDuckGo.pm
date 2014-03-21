package DDG::Goodie::DuckDuckGo;
# ABSTRACT: Return hard-coded descriptions for DuckDuckGo terms

use DDG::Goodie;

primary_example_queries 'help';
secondary_example_queries 'Zero-Click Info', 'zeroclick';
description 'DuckDuckGo help and quick links';
name 'DuckDuckGo';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DuckDuckGo.pm';
category 'cheat_sheets';
topics 'everyday';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

triggers startend => "duckduckgo", "ddg", "zeroclickinfo";

my %data_html = (
    goodies			=> "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-goodies'>Goodie repository</a>",
    spice			=> "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-spice'>Spice repository</a>",
    longtail			=> "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-longtail'>Longtail repository</a>",
    fathead			=> "DuckDuckGo's <a href='https://github.com/duckduckgo/zeroclickinfo-fathead'>Fathead repository</a>",
    help			=> "Need help? Visit our <a href='http://dukgo.com/help/'>help page</a>.",
    roboduck			=> "DuckDuckGo's official <a href='https://github.com/Getty/duckduckgo-roboduck'>IRC bot</a>.",
    privacy			=> "DuckDuckGo's <a href='https://duckduckgo.com/privacy'>privacy policy</a>..",
    xmpp			=> "DuckDuckGo's <a href='https://duck.co/blog/using-pidgin-with-xmpp-jabber'>XMPP service</a>.",
    tor				=> "DuckDuckGo's <a href='https://3g2upl4pq6kufc4m.onion'>Tor hidden service</a>.",
    'hidden service'		=> "DuckDuckGo's <a href='https://3g2upl4pq6kufc4m.onion'>Tor hidden service</a>.",
    'tor hidden service'	=> "DuckDuckGo's <a href='https://3g2upl4pq6kufc4m.onion'>Tor hidden service</a>.",
    contributing		=> "<a href='https://duck.co/help/community/contributing'>Contributing to DuckDuckGo</a>",
    'open source'		=> "DuckDuckGo's <a href='https://duck.co/help/open-source/opensource-overview'>open source projects</a>.",
    'business model'		=> "<a href='https://duck.co/help/company/advertising-and-affiliates'>Advertising and Affiliates on DuckDuckGo</a>.",
    advertisements		=> "<a href='https://duck.co/help/company/advertising-and-affiliates'>Advertising and Affiliates on DuckDuckGo</a>.",
    ads				=> "<a href='https://duck.co/help/company/advertising-and-affiliates'>Advertising and Affiliates on DuckDuckGo</a>.",
    press			=> "DuckDuckGo's <a href='https://duck.co/help/company/press'>press page</a>.",
    traffic			=> "DuckDuckGo's <a href='https://duckduckgo.com/traffic.html'>traffic page</a>.",
    firefox			=> "DuckDuckGo's <a href='https://duck.co/help/desktop/firefox'>Firefox help page</a>.",
    chrome			=> "DuckDuckGo's <a href='https://duck.co/help/desktop/chrome'>Chrome help page</a>.",
    safari			=> "DuckDuckGo's <a href='https://duck.co/help/desktop/safari'>Safari help page</a>.",
    'internet explorer'		=> "DuckDuckGo's <a href='https://duck.co/help/desktop/internet-explorer'>Internet Explorer help page</a>.",
    ie				=> "DuckDuckGo's <a href='https://duck.co/help/desktop/internet-explorer'>Internet Explorer help page</a>.",
    opera			=> "DuckDuckGo's <a href='https://duck.co/help/desktop/opera'>Opera help page</a>.",
    spread			=> "DuckDuckGo's <a href='https://duckduckgo.com/supportus.html'>Spread page</a>.",
    syntax			=> "DuckDuckGo's <a href='https://duck.co/help/results/syntax'>available search syntax</a>.",
    app				=> "DuckDuckGo's <a href='https://duckduckgo.com/app/'>mobile app</a>.",
    ios				=> "DuckDuckGo's <a href='https://duckduckgo.com/app/'>mobile app</a>.",
    android			=> "DuckDuckGo's <a href='https://duckduckgo.com/app/'>mobile app</a>.",
    mobile			=> "DuckDuckGo's <a href='https://duckduckgo.com/app/'>mobile app</a>.",
    blog			=> "DuckDuckGo's <a href='https://duck.co/blog'>official blog</a>.",
    translation			=> "Help <a href='https://duck.co/translate'>translate DuckDuckGo</a> or adjust your language in the <a href='https://duckduckgo.com/settings'>settings menu</a>.",
    translations		=> "Help <a href='https://duck.co/translate'>translate DuckDuckGo</a> or adjust your language in the <a href='https://duckduckgo.com/settings'>settings menu</a>.",
    language			=> "Help <a href='https://duck.co/translate'>translate DuckDuckGo</a> or adjust your language in the <a href='https://duckduckgo.com/settings'>settings menu</a>.",
    languages			=> "Help <a href='https://duck.co/translate'>translate DuckDuckGo</a> or adjust your language in the <a href='https://duckduckgo.com/settings'>settings menu</a>.",
    settings			=> "DuckDuckGo's <a href='https://duckduckgo.com/settings'>settings</a>.",
    partnership			=> "<a href='https://duckduckgo.com/settings'>Partnering with DuckDuckGo</a>.",
    api				=> "DuckDuckGo's <a href='https://duckduckgo.com/api'>API</a>.",
    about			=> "DuckDuckGo's <a href='https://duckduckgo.com/about'>about page</a>.",
    'short url'			=> "DuckDuckGo's short URL: <a href='http://ddg.gg/'>http://ddg.gg/</a>.",
    'short domain'		=> "DuckDuckGo's short URL: <a href='http://ddg.gg/'>http://ddg.gg/</a>.",
    'instant answers' 		=> "DuckDuckGo's instant answers display helpful information at the top of the search page (like this box).<br>Suggest or develop them on <a href='http://duckduckhack.com/'>DuckDuckHack</a> and see all the current instant answers on the <a href='https://duckduckgo.com/goodies'>Goodies page</a>.",
    ia				=> "DuckDuckGo's instant answers display helpful information at the top of the search page (like this box).<br>Suggest or develop them on <a href='http://duckduckhack.com/'>DuckDuckHack</a> and see all the current instant answers on the <a href='https://duckduckgo.com/goodies'>Goodies page</a>.",
    hiring			=> "Check out the <a href='https://duck.co/help/company/hiring'>DuckDuckGo hiring article</a>.",
    job				=> "Check out the <a href='https://duck.co/help/company/hiring'>DuckDuckGo hiring article</a>.",
    jobs			=> "Check out the <a href='https://duck.co/help/company/hiring'>DuckDuckGo hiring article</a>.",
    twitter			=> "Follow us on <a href='https://twitter.com/duckduckgo'>\@duckduckgo</a>.",
    facebook			=> "Like us on <a href='https://twitter.com/duckduckgo'>Facebook</a>.",
    community			=> "Join our <a href='https://duck.co/'>growing community</a>!",
    doodle			=> "Take a look at our <a href='https://duck.co/help/settings/holiday-logos'>holiday logos</a>!",
    swag			=> "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items.",
    merch			=> "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items.",
    merchandise			=> "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items.",
    shirt			=> "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items.",
    sticker			=> "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items.",
    stickers			=> "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items.",
    duck			=> "<img src='https://duckduckgo.com/assets/logo_header.v101.png' alt='Dax' /><br/>I am the duck. Dax the duck.",
    dax				=> "<img src='https://duckduckgo.com/assets/logo_header.v101.png' alt='Dax' /><br/>I am the duck. Dax the duck.",
    irc				=> "DuckDuckGo's official IRC channel is #duckduckgo on irc.freenode.net",
    remove			=> "To remove DuckDuckGo from your browser, take a look <a href='https://duck.co/help/desktop'>here</a>. Please <a href='https://duckduckgo.com/feedback'>let us know</a> why you are leaving!",
    removing			=> "To remove DuckDuckGo from your browser, take a look <a href='https://duck.co/help/desktop'>here</a>. Please <a href='https://duckduckgo.com/feedback'>let us know</a> why you are leaving!",
    removal			=> "To remove DuckDuckGo from your browser, take a look <a href='https://duck.co/help/desktop'>here</a>. Please <a href='https://duckduckgo.com/feedback'>let us know</a> why you are leaving!",
    (map {
        $_ => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
     } "zeroclickinfo", "zeroclick", "0click", "0clickinfo", "zero 0")
);

zci is_cached => 1;
handle remainder => sub {
    if(defined $data_html{$_}) {
	return "", html => $data_html{$_};
    }
    return;
};

1;

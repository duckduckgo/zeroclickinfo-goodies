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

zci is_cached => 1;

my %data = (
    goodies			=> "DuckDuckGo's Goodie repository: https://github.com/duckduckgo/zeroclickinfo-goodies",
    spice			=> "DuckDuckGo's Spice repository: https://github.com/duckduckgo/zeroclickinfo-spice",
    longtail			=> "DuckDuckGo's Longtail repository: https://github.com/duckduckgo/zeroclickinfo-longtail",
    fathead			=> "DuckDuckGo's Fathead repository: https://github.com/duckduckgo/zeroclickinfo-fathead",
    help			=> "Need help? Visit our help page: http://dukgo.com/help/",
    roboduck			=> "DuckDuckGo's official IRC bot: https://github.com/Getty/duckduckgo-roboduck",
    privacy			=> "DuckDuckGo's privacy policy: https://duckduckgo.com/privacy",
    xmpp			=> "DuckDuckGo's XMPP service: https://duck.co/blog/using-pidgin-with-xmpp-jabber",
    tor				=> "DuckDuckGo's Tor hidden service: https://3g2upl4pq6kufc4m.onion",
    'hidden service'		=> "DuckDuckGo's Tor hidden service: https://3g2upl4pq6kufc4m.onion",
    'tor hidden service'	=> "DuckDuckGo's Tor hidden service: https://3g2upl4pq6kufc4m.onion",
    contributing		=> "Contributing to DuckDuckGo: https://duck.co/help/community/contributing",
    'open source'		=> "DuckDuckGo's open source projects: https://duck.co/help/open-source/opensource-overview",
    'business model'		=> "Advertising and Affiliates on DuckDuckGo: https://duck.co/help/company/advertising-and-affiliates",
    advertisements		=> "Advertising and Affiliates on DuckDuckGo: https://duck.co/help/company/advertising-and-affiliates",
    ads				=> "Advertising and Affiliates on DuckDuckGo: https://duck.co/help/company/advertising-and-affiliates",
    press			=> "DuckDuckGo's press page: https://duck.co/help/company/press",
    traffic			=> "DuckDuckGo's traffic page: https://duckduckgo.com/traffic.html",
    firefox			=> "DuckDuckGo's Firefox help page: https://duck.co/help/desktop/firefox",
    chrome			=> "DuckDuckGo's Chrome help page: https://duck.co/help/desktop/chrome",
    safari			=> "DuckDuckGo's Safari help page: https://duck.co/help/desktop/safari",
    'internet explorer'		=> "DuckDuckGo's Internet Explorer help page: https://duck.co/help/desktop/internet-explorer",
    ie				=> "DuckDuckGo's Internet Explorer help page: https://duck.co/help/desktop/internet-explorer",
    opera			=> "DuckDuckGo's Opera help page: https://duck.co/help/desktop/opera",
    spread			=> "DuckDuckGo's Spread page: https://duckduckgo.com/supportus.html",
    syntax			=> "DuckDuckGo's available search syntax: https://duck.co/help/results/syntax",
    app				=> "DuckDuckGo's mobile app: https://duckduckgo.com/app/",
    ios				=> "DuckDuckGo's mobile app: https://duckduckgo.com/app/",
    android			=> "DuckDuckGo's mobile app: https://duckduckgo.com/app/",
    mobile			=> "DuckDuckGo's mobile app: https://duckduckgo.com/app/",
    blog			=> "DuckDuckGo's official blog: https://duck.co/blog",
    translation			=> "Help translate DuckDuckGo (https://duck.co/translate) or adjust your language in the settings menu (https://duckduckgo.com/settings).",
    translations		=> "Help translate DuckDuckGo (https://duck.co/translate) or adjust your language in the settings menu (https://duckduckgo.com/settings).",
    language			=> "Help translate DuckDuckGo (https://duck.co/translate) or adjust your language in the settings menu (https://duckduckgo.com/settings).",
    languages			=> "Help translate DuckDuckGo (https://duck.co/translate) or adjust your language in the settings menu (https://duckduckgo.com/settings).",
    settings			=> "DuckDuckGo's settings: https://duckduckgo.com/settings",
    partnership			=> "Partnering with DuckDuckGo: https://duck.co/help/company/partnerships",
    api				=> "DuckDuckGo's API: https://duckduckgo.com/api",
    about			=> "DuckDuckGo's about page: https://duckduckgo.com/about",
    'short url'			=> "DuckDuckGo's short URL: http://ddg.gg/",
    'short domain'		=> "DuckDuckGo's short URL: http://ddg.gg/",
    'instant answers'		=> "DuckDuckGo's instant answers display helpful information at the top of the search page (like this box).\nSuggest or develop them on http://duckduckhack.com and see all the current instant answers on the Goodies page (https://duckduckgo.com/goodies).",
    ia				=> "DuckDuckGo's instant answers display helpful information at the top of the search page (like this box).\nSuggest or develop them on http://duckduckhack.com and see all the current instant answers on the Goodies page (https://duckduckgo.com/goodies).",
    hiring			=> "Check out the DuckDuckGo hiring article: https://duck.co/help/company/hiring",
    job				=> "Check out the DuckDuckGo hiring article: https://duck.co/help/company/hiring",
    jobs			=> "Check out the DuckDuckGo hiring article: https://duck.co/help/company/hiring",
    twitter			=> 'Follow us on @duckduckgo',
    facebook			=> "Like us on https://www.facebook.com/duckduckgo",
    community			=> "Join our growing community: https://duck.co/",
    doodle			=> "Take a look at our holiday logos! https://duck.co/help/settings/holiday-logos",
    swag			=> "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items. https://duck.co/help/community/swag",
    merch			=> "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items. https://duck.co/help/community/swag",
    merchandise			=> "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items. https://duck.co/help/community/swag",
    shirt			=> "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items. https://duck.co/help/community/swag",
    sticker			=> "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items. https://duck.co/help/community/swag",
    stickers			=> "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items. https://duck.co/help/community/swag",
    duck			=> "I am the duck. Dax the duck.",
    dax				=> "I am the duck. Dax the duck.",
    irc				=> "DuckDuckGo's official IRC channel is #duckduckgo on irc.freenode.net.",
    remove			=> "To remove DuckDuckGo from your browser, take a look at https://duck.co/help/desktop. Please let us know why you are leaving at https://duckduckgo.com/feedback!",
    removing			=> "To remove DuckDuckGo from your browser, take a look at https://duck.co/help/desktop. Please let us know why you are leaving at https://duckduckgo.com/feedback!",
    removal			=> "To remove DuckDuckGo from your browser, take a look at https://duck.co/help/desktop. Please let us know why you are leaving at https://duckduckgo.com/feedback!",
    (map {
        $_ => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
     } "zeroclickinfo", "zeroclick", "0click", "0clickinfo", "zero 0", "zero click info", "zero-click info")
);

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
    facebook			=> "Like us on <a href='https://www.facebook.com/duckduckgo'>Facebook</a>.",
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
    irc				=> "DuckDuckGo's official IRC channel is <a href='http://webchat.freenode.net/?channels=duckduckgo'>#duckduckgo</a> on <a href='http://freenode.net/'>irc.freenode.net</a>",
    remove			=> "To remove DuckDuckGo from your browser, take a look <a href='https://duck.co/help/desktop'>here</a>. Please <a href='https://duckduckgo.com/feedback'>let us know</a> why you are leaving!",
    removing			=> "To remove DuckDuckGo from your browser, take a look <a href='https://duck.co/help/desktop'>here</a>. Please <a href='https://duckduckgo.com/feedback'>let us know</a> why you are leaving!",
    removal			=> "To remove DuckDuckGo from your browser, take a look <a href='https://duck.co/help/desktop'>here</a>. Please <a href='https://duckduckgo.com/feedback'>let us know</a> why you are leaving!",
    (map {
        $_ => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
     } "zeroclickinfo", "zeroclick", "0click", "0clickinfo", "zero 0", "zero click info", "zero-click info")
);

handle remainder => sub {
    if(defined $data_html{lc $_} && defined $data{lc $_}) {
	return $data{lc $_}, html => $data_html{lc $_};
    }
    return;
};

1;

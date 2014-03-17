package DDG::Goodie::DuckDuckGo;
# ABSTRACT: Return hard-coded descriptions for DuckDuckGo terms

primary_example_queries 'help';
secondary_example_queries 'Zero-Click Info', 'zeroclick';
description 'DuckDuckGo help and quick links';
name 'DuckDuckGo';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DuckDuckGo.pm';
category 'cheat_sheets';
topics 'everyday';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

use DDG::Goodie;

my %data = (
    goodies             => "DuckDuckGo's goodie repository: https://github.com/duckduckgo/zeroclickinfo-goodies",
    spice               => "DuckDuckGo's spice repository: https://github.com/duckduckgo/zeroclickinfo-spice",
    longtail            => "DuckDuckGo's longtail repository: https://github.com/duckduckgo/zeroclickinfo-longtail",
    fathead             => "DuckDuckGo's fathead repository: https://github.com/duckduckgo/zeroclickinfo-fathead",
    help                => "DuckDuckGo's help website: https://duck.co/help/",
    roboduck            => "DuckDuckGo's official IRC bot: https://github.com/Getty/duckduckgo-roboduck",
    privacy             => "DuckDuckGo's privacy policy: https://duckduckgo.com/privacy",
    xmpp                => "DuckDuckGo's XMPP service: https://duck.co/blog/using-pidgin-with-xmpp-jabber",
    tor                 => "DuckDuckGo's TOR hidden service: https://3g2upl4pq6kufc4m.onion",
    tor_html            => qq(DuckDuckGo's TOR hidden service: <a href="https://3g2upl4pq6kufc4m.onion">https://3g2upl4pq6kufc4m.onion</a>),
    hiddenservice       => \"tor",
    hidden_service_html => \"tor_html",
    torhiddenservice    => \"tor",
    tor_hidden_service_html => \"tor_html",
    contributing        => "Contributing to DuckDuckGo: https://duck.co/help/community/contributing",
    opensource          => "DuckDuckGo's open source projects: https://duck.co/help/open-source/opensource-overview",
    businessmodel       => "Advertising and Affiliates on DuckDuckGo: https://duck.co/help/company/advertising-and-affiliates",
    advertisements      => "DuckDuckGo's official IRC bot: https://github.com/Getty/duckduckgo-roboduck",
    press               => "DuckDuckGo's press page: https://duck.co/help/company/press",
    traffic             => "DuckDuckGo's traffic is public at: https://duckduckgo.com/traffic.html",
    firefox             => "DuckDuckGo's Firefox help page: https://duck.co/help/desktop/firefox",
    chrome              => "DuckDuckGo's Chrome help page: https://duck.co/help/desktop/chrome",
    safari              => "DuckDuckGo's Safari help page: https://duck.co/help/desktop/safari",
    internetexplorer    => "DuckDuckGo's Internet Explorer help page: https://duck.co/help/desktop/internet-explorer",
    internet_explorer_html => qq(DuckDuckGo's Internet Explorer <a href="https://duck.co/help/desktop/internet-explorer">Internet Explorer help page</a>),    
    ie                  => \"internet explorer",
    ie_html             => \"internet_explorer_html",
    opera               => "DuckDuckGo's Opera help page: https://duck.co/help/desktop/opera",
    spread              => "DuckDuckGo's Spread page: https://duckduckgo.com/supportus.html",
    syntax              => "DuckDuckGo's available search syntax: https://duck.co/help/results/syntax",
    relevancy           => "Bad relevancy for your search? Suggest an instant answer to help fix it: https://duck.co/ideas",
    app                 => "DuckDuckGo's mobile app: https://duckduckgo.com/app/",
    ios                 => "DuckDuckGo's mobile app: https://duckduckgo.com/app/",
    android             => "DuckDuckGo's mobile app: https://duckduckgo.com/app/",
    blog                => "DuckDuckGo's official blog: https://duck.co/blog",
    translation         => "Help translate DuckDuckGo: https://duck.co/translate or adjust your language in the settings menu: https://duckduckgo.com/settings",
    translation_html    => qq(Help <a href="https://duck.co/translate">translate DuckDuckGo</a><br/><a href="https://duckduckgo.com/settings">Adjust your language or region in the settings menu</a><br/>),
    translations        => \"translation",
    translations_html   => \"translation_html",
    language            => \"translation",
    language_html       => \"translation_html",
    languages           => \"translation",
    languages_html      => \"translation_html",
    mobile              => "DuckDuckGo's mobile app: https://duckduckgo.com/app/",
    settings            => "DuckDuckGo's settings: https://duckduckgo.com/settings",
    partnerships        => "Partnering with DuckDuckGo: https://duck.co/help/company/partnerships",
    api                 => "DuckDuckGo's API: https://duckduckgo.com/api",
    about               => "DuckDuckGo's about page: https://duckduckgo.com/about",
    shorturl            => "DuckDuckGo's short URL: http://ddg.gg/ which will take you to https://duckduckgo.com/",
    shortdomain         => "DuckDuckGo's short URL: http://ddg.gg/ which will take you to https://duckduckgo.com/",
    instantanswers      => "DuckDuckGo's instant answers display helpful information at the top of the search page (like this box). Suggest or develop them at: http://duckduckhack.com/ and see all the current instant answers at: https://duckduckgo.com/goodies",
    instant_answers_html => qq(DuckDuckGo's instant answers display helpful information at the top of the search page (like this box). <br/><a href="http://duckduckhack.com/">Develop them!</a><br/><a href="https://duck.co/ideas">Suggest them!</a><br/><a href="https://duckduckgo.com/goodies">See all available Instant Answers</a>),    
    ia                  => \"instant answers",
    ia_html             => \"instant_answers_html",
    instantanswers      => \"instant answers",
    instantanswers_html => \"instant_answers_html",
    hiring              => "Check out the DuckDuckGo hiring article: https://duck.co/help/company/hiring",
    hiring_html         => qq(<a href="https://duck.co/help/company/hiring">Check out the DuckDuckGo hiring article</a>),    
    job                 => \"hiring",
    job_html            => \"hiring_html",
    jobs                => \"hiring",
    jobs_html           => \"hiring_html",
    twitter             => "DuckDuckGo's official Twitter account: https://twitter.com/duckduckgo",
    facebook            => "DuckDuckGo's official Facebook account: https://www.facebook.com/duckduckgo",
    community           => "DuckDuckGo's community site: https://duck.co/",
    doodle              => "DuckDuckGo often does special logos for significant days. Check the past ones out here: https://duck.co/help/settings/holiday-logos",
    swag                => "Thanks for the support! You can find DuckDuckGo t-shirts, stickers, and other items here: https://duck.co/help/community/swag",
    swag_html           => qq(Thanks for the support! You can find DuckDuckGo t-shirts, stickers, and other items <a href="https://duck.co/help/community/swag">here</a>),
    merchandise         => \"swag",
    merchandise_html    => \"swag_html",
    shirt               => \"swag",
    shirt_html          => \"swag_html",
    t-shirts            => \"swag",
    t-shirts_html       => \"swag_html",
    sticker             => \"swag",
    sticker_html        => \"swag_html",
    stickers            => \"swag",
    stickers_html       => \"swag_html",
    quackandhack        => "QUACK!",
    duck                => "I am the duck. Dax the duck.",
    dax                 => "I am the duck. Dax the duck.",
    irc                 => "DuckDuckGo's official IRC channel is #duckduckgo on irc.freenode.net",
    remove              => "To remove DuckDuckGo from your browser, take a look at https://duck.co/help/desktop. Let us know why you are leaving: https://duckduckgo.com/feedback",
    remove_html         => qq(To remove DuckDuckGo from your browser, look <a href="https://duck.co/help/desktop">here</a> for your web browser.<br/>In short, check your browser's addons/extensions for DuckDuckGo, then check the search settings.<br/>Please <a href="https://duckduckgo.com/feedback">let us know</a> why you are leaving!),
    removing            => \"remove",
    removing_html       => \"remove_html",
    removal             => \"remove",
    removal_html        => \"remove_html",
    (map {
        $_              => "Zero Click Info is another term for our instant answers (this box is one of them), which often provide useful information above traditional results. Read more about that here: http://duckduckhack.com/",
        } qw/zeroclickinfo zeroclick 0click 0clickinfo zci/),
);

triggers any => keys %data, qw/zero 0/;

zci is_cached => 1;

handle query_lc => sub {
    s/\W//g;
    return if $_ eq 'irc';
    s/^?(?:ddg|duckduckgo)\$?|repo(?:sitory)?//g;
    $_ = ${$data{$_}} if ref $data{$_};
    return unless my $answer = $data{$_};
    return $answer unless exists $data{"${_}_html"};
    return $answer, html => $data{"${_}_html"};
};

1;

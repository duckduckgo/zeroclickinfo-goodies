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
            cpan    => 'CRZEDPSYC';

triggers startend => "duckduckgo", "ddg", "zeroclickinfo";

zci is_cached => 1;

# If the text and HTML versions can be reasonably generated from the same format
# use base_format.  If info_url is included, the words surrounded with [] will be linked
# in the HTML version.  The url will be appended to the text version.
#
# Otherwise, include both text and html keys.
#
# If more than one keyword applies, add an aliases key with an array ref of string aliases.
my %responses = (
    about => {
        base_format => "DuckDuckGo's [about page]",
        info_url    => 'https://duckduckgo.com/about',
    },
    ads => {
        base_format => "[Advertising and Affiliates on DuckDuckGo]",
        info_url    => 'https://duck.co/help/company/advertising-and-affiliates',
        aliases     => [qw( businessmodel advertisements )],
    },
    api => {
        base_format => "DuckDuckGo's [API]",
        info_url    => 'https://duckduckgo.com/api',
    },
    app => {
        base_format => "DuckDuckGo's [mobile app]",
        info_url    => 'https://duckduckgo.com/app/',
        aliases     => [qw( ios android mobile )],
    },
    blog => {
        base_format => "DuckDuckGo's [official blog]",
        info_url    => 'https://duck.co/blog',
    },
    chrome => {
        base_format => "DuckDuckGo's [Chrome help page]",
        info_url    => 'https://duck.co/help/desktop/chrome',
    },
    contributing => {
        base_format => '[Contributing to DuckDuckGo]',
        info_url    => 'https://duck.co/help/community/contributing',
    },
    community => {
        base_format => 'Join our [growing community]',
        info_url    => 'https://duck.co/',
    },
    doodle => {
        base_format => "Take a look at our [holiday logos]",
        info_url    => 'https://duck.co/help/settings/holiday-logos',
    },
    duck => {
        text    => "I am the duck. Dax the duck.",
        html    => "<img src='https://duckduckgo.com/assets/logo_header.v101.png' alt='Dax' /><br/>I am the duck. Dax the duck.",
        aliases => [qw( dax whosdax whoisdax whostheduck whoistheduck mirrormirroronthewallwhosthefairestofthemall )],
    },
    facebook => {
        base_format => "Like us on [Facebook]",
        info_url    => 'https://www.facebook.com/duckduckgo'
    },
    fathead => {
        base_format => "DuckDuckGo's [Fathead repository]",
        info_url    => 'https://github.com/duckduckgo/zeroclickinfo-fathead',
    },
    firefox => {
        base_format => "DuckDuckGo's [Firefox help page]",
        info_url    => 'https://duck.co/help/desktop/firefox',
    },
    goodies => {
        base_format => "DuckDuckGo's [Goodie repository]",
        info_url    => 'https://github.com/duckduckgo/zeroclickinfo-goodies',
    },
    help => {
        base_format => "Need help? Visit our [help page]",
        info_url    => 'http://dukgo.com/help/',
    },
    hiring => {
        base_format => "Check out the DuckDuckGo [hiring article]",
        info_url    => 'https://duck.co/help/company/hiring',
        aliases     => [qw( job jobs )],
    },
    ia => {
        text =>
          "DuckDuckGo's instant answers display helpful information at the top of the search page (like this box).\nSuggest or develop them on http://duckduckhack.com and see all the current instant answers on the Goodies page (https://duckduckgo.com/goodies).",
        html =>
          "DuckDuckGo's instant answers display helpful information at the top of the search page (like this box).<br>Suggest or develop them on <a href='http://duckduckhack.com/'>DuckDuckHack</a> and see all the current instant answers on the <a href='https://duckduckgo.com/goodies'>Goodies page</a>.",
        aliases => [qw( instantanswer instantanswers )],
    },
    ie => {
        base_format => "DuckDuckGo's [Internet Explorer help page]",
        info_url    => 'https://duck.co/help/desktop/internet-explorer',
        aliases     => [qw( internetexplorer )],
    },
    irc => {
        text => "DuckDuckGo's official IRC channel is #duckduckgo on irc.freenode.net.",
        html =>
          "DuckDuckGo's official IRC channel is <a href='http://webchat.freenode.net/?channels=duckduckgo'>#duckduckgo</a> on <a href='http://freenode.net/'>irc.freenode.net</a>",
    },
    longtail => {
        base_format => "DuckDuckGo's [Longtail repository]",
        info_url    => 'https://github.com/duckduckgo/zeroclickinfo-longtail',
    },
    opensource => {
        base_format => "DuckDuckGo's [open source projects]",
        info_url    => 'https://duck.co/help/open-source/opensource-overview',
    },
    opera => {
        base_format => "DuckDuckGo's [Opera help page]",
        info_url    => 'https://duck.co/help/desktop/opera',
    },
    partnership => {
        base_format => "[Partnering with DuckDuckGo]",
        info_url    => 'https://duck.co/help/company/partnerships',
    },
    press => {
        base_format => "DuckDuckGo's [press page]",
        info_url    => 'https://duck.co/help/company/press',
    },
    privacy => {
        base_format => "DuckDuckGo's [privacy policy]",
        info_url    => 'https://duckduckgo.com/privacy',
    },
    remove => {
        text =>
          "To remove DuckDuckGo from your browser, take a look at https://duck.co/help/desktop. Please let us know why you are leaving at https://duckduckgo.com/feedback!",
        html =>
          "To remove DuckDuckGo from your browser, take a look <a href='https://duck.co/help/desktop'>here</a>. Please <a href='https://duckduckgo.com/feedback'>let us know</a> why you are leaving!",
        aliases => [qw( removing removal )],
    },
    roboduck => {
        base_format => "DuckDuckGo's official [IRC bot]",
        info_url    => 'https://github.com/Getty/duckduckgo-roboduck',
    },
    safari => {
        base_format => "DuckDuckGo's [Safari help page]",
        info_url    => 'https://duck.co/help/desktop/safari',
    },
    settings => {
        base_format => "DuckDuckGo [settings]",
        info_url    => 'https://duckduckgo.com/settings',
    },
    short => {
        text    => "DuckDuckGo's short URL: http://ddg.gg/",
        html    => "DuckDuckGo's short URL: <a href='http://ddg.gg/'>http://ddg.gg/</a>.",
        aliases => [qw( shorturl shortdomain )],
    },
    spice => {
        base_format => "DuckDuckGo's [Spice repository]",
        info_url    => 'https://github.com/duckduckgo/zeroclickinfo-spice',
    },
    spread => {
        base_format => "DuckDuckGo's [Spread page]",
        info_url    => 'https://duckduckgo.com/supportus.html',
    },
    swag => {
        base_format => "Thanks for the support! Check out the [DuckDuckGo store] for t-shirts, stickers, and other items",
        info_url    => 'https://duck.co/help/community/swag',
        aliases     => [qw( merch merchandise shirt shirts sticker stickers )],
    },
    syntax => {
        base_format => "DuckDuckGo's [available search syntax]",
        info_url    => 'https://duck.co/help/results/syntax',
    },
    tor => {
        base_format => "DuckDuckGo's [Tor hidden service]",
        info_url    => 'https://3g2upl4pq6kufc4m.onion',
        aliases     => [qw( hiddenservice torhiddenservice )],
    },
    traffic => {
        base_format => "DuckDuckGo's [traffic page]",
        info_url    => 'https://duckduckgo.com/traffic.html',
    },
    translation => {
        text =>
          "Help translate DuckDuckGo (https://duck.co/translate) or adjust your language in the settings menu (https://duckduckgo.com/settings).",
        html =>
          "Help <a href='https://duck.co/translate'>translate DuckDuckGo</a> or adjust your language in the <a href='https://duckduckgo.com/settings'>settings menu</a>.",
        aliases => [qw( translations language languages )],
    },
    twitter => {
        base_format => 'Follow us on [@duckduckgo]',
        info_url    => 'https://twitter.com/duckduckgo',
    },
    xmpp => {
        base_format => "DuckDuckGo's [XMPP service]",
        info_url    => 'https://duck.co/blog/using-pidgin-with-xmpp-jabber',
    },
    zci => {
        base_format => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
        aliases => ["zeroclickinfo", "zeroclick", "0click", "0clickinfo", "zero 0", "zero click info", "zero-click info"],
    },
);

# Above is intended to be human-friendly.
# Now we make it computer-friendly.
foreach my $keyword (keys %responses) {
    my $response = $responses{$keyword};
    if (my $base_format = $response->{base_format}) {
        # We need to produce the output for each version.
        if (my $info_url = $response->{info_url}) {
            $response->{text} = $base_format;
            $response->{text} =~ s/[\[\]]//g;    # No internal linking.
            $response->{text} .= ': ' . $response->{info_url};    # Stick the link on the end.

            $response->{html} = $base_format;
            $response->{html} =~ s#\[#<a href='$info_url'>#;      # Insert link.
            $response->{html} =~ s#\]#</a>#;
            $response->{html} .= '.';
        } else {
            # No link to insert, so it must be ready for both.
            $response->{text} = $response->{html} = $response->{base_format};
        }
    }
    if (ref($response->{aliases}) eq 'ARRAY') {
        foreach my $alias (@{$response->{aliases}}) {
            # Assume we didn't add an alias for an existing keyword.
            $responses{$alias} = $response;
        }
    }
    foreach my $key (keys %$response) {
        # No matter what they added above, we only use the following keys for the actual response.
        delete $response->{$key} unless (grep { $key eq $_ } (qw(text html)));
    }
}

handle remainder => sub {
    s/\W+//g;
    my $key = lc;

    my $response = $responses{$key};

    return unless ($response);
    return $response->{text}, html => $response->{html};
};

1;

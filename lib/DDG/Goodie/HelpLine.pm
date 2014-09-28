package DDG::Goodie::HelpLine;
# ABSTRACT: Provide localized suicide intervention phone numbers.

use DDG::Goodie;

my @triggers = (
    'suicide',
    'suicide hotline',
    'kill myself',
    'suicidal thoughts',
    'end my life',
    'suicidal thoughts',
    'suicidal',
    'suicidal ideation',
    'i want to kill myself',
    'commit suicide',
    'suicide pills',
    'suicide pill',
    'suicide prevention',
    'kill myself',
    'suicide phone number',
    'suicide hot line',
    'suicide lifeline',
    'suicide life line',
    'crisis intervention',
    'i want to die',
    'committing suicide',
    'killing myself',
    'hang myself',
    'shoot myself',
    'fastest way to kill myself',
    'i\'m suicidal',
    'how to make suicide pill',
    'how to make suicide pills',
    'make suicide pills',
    'make suicide pill',
    'best way to kill myself',
    'easiest suicide method',
    'i want to end my life',
    'suicide help',
    'suicide intervention',
    'suicide method',
    'suicide methods',
    'how to kill myself',
    'ways to kill myself',
);

triggers any => @triggers;

zci answer_type => 'helpline';

primary_example_queries 'suicide hotline';
description 'Checks if a query with the word "suicide" was made and returns a 24 hr suicide hotline.';
attribution github => ['https://github.com/conorfl', 'conorfl'],
twitter => '@areuhappylucia';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Helpline.pm';
topics 'everyday';
category 'special';
source 'https://en.wikipedia.org/wiki/List_of_suicide_crisis_lines';

my %helpline = (
    # http://www.lifeline.org.au/Get-Help/I-Need-Help-Now and http://www.kidshelp.com.au/grownups/about-this-site.php
    AU => ['13 11 14 or 1800 55 1800 (kids)', 'Australia'],
    # http://www.suicidepreventionlifeline.org/ and http://org.kidshelpphone.ca/en
    CA => ['1-800-273-8255 or 1-800-668-6868 (kids)', 'Canada'],
    # http://samaritans.org.hk/24-hour-telephone-hotline (supports English, Cantonese and Mandarin)
    HK => [ '2896 0000', 'Hong Kong'],
    # http://www.samaritans.org/how-we-can-help-you/contact-us
    IE => ['1850 60 90 90', 'Ireland'],
    # http://www.lifeline.org.nz/corp_Home_378_2001.aspx
    NZ => ['0800 543 354', 'New Zealand'],
    # http://www.papyrus-uk.org/, http://www.samaritans.org/, and http://www.thecalmzone.net/help/helpline/helpline-nationwide/
    GB => ['0800 068 41 41, 08457 90 90 90, or 0800 58 58 58', 'the UK'],
    # http://www.samaritans.org.sg/contact/confide.htm#call_us
    SG => ['1800-221 4444', 'Singapore'],
    # http://www.suicidepreventionlifeline.org/
    US => ['1-800-273-TALK (8255)', 'the U.S.'],
);

handle query_lc => sub {
    my $query = shift;

    # Check if the query matches exatly the trigger word.
    my %suicide_phrases = map { $_ => 1 } @triggers;
    return unless exists $suicide_phrases{$query};

    # Display the result.
    my $code = $loc->country_code;
    return "24 Hour Suicide Hotline in " .  $helpline{$code}[1] . ": " . $helpline{$code}[0]
        if exists $helpline{$code}[0];
};

1;

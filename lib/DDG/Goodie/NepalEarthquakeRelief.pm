package DDG::Goodie::NepalEarthquakeRelief;
# ABSTRACT: Provide ways to help Nepal earthquake relief

use DDG::Goodie;

zci answer_type => "nepal_earthquake_relief";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "NepalEarthquakeRelief";
description "Provide ways to help Nepal earthquake relief";
primary_example_queries "Nepal earthquake", "Nepal relief";
category "special";
topics "trivia";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/NepalEarthquakeRelief.pm";
attribution github => ["https://github.com/wongalvis", "wongalvis"];

# Triggers
triggers any => "nepal earthquake", "nepal relief";

# Handle statement
handle remainder => sub {
    
    return "Help Nepal Earthquake Relief",
    html => "
            <h3>Ways to help Nepal earthquake relief:</h3>
            
            <h6>1. Save the Children</h6>
            <p>Save the Children has worked in Nepal since 1976 and already have extensive programs throughout the country. They have launched a disaster response on the ground and need your generous gifts to support their efforts.</p>
            <p><a href='https://secure.savethechildren.org/site/c.8rKLIXMGIpI4E/b.9274575/k.FD90/Nepal_Earthquake_Childrens_Relief_Fund/apps/ka/sd/donor.asp'>Donate to their Relief Fund here.</a></p>
            
            <h6>2. Red Cross</h6>
            <p>Red Cross has extensive experience in responding to natural disasters and is already providing first aid, search and rescue and blood to medical facilities in the capital and support to first responders.</p>
            <p><a href='https://www.redcross.org/combined-donate?donationProdId=prod9150029&campname=donateNepalEarthquake'>Donate to their Nepal Earthquake Relief Fund here.</a></p>
            
            <h6>3. #SupportNepal</h6>
            <p>Raising awareness about the need for funds and spreading the message is also important. Share this information with others by posting on Facebook, Twitter, Instagram and all your social media platforms using the <a href='https://twitter.com/search?q=%23supportnepal&src=typd'>#SupportNepal</a> hashtag to encourage others to donate and help as well. </p>
            
            <h4>Read More:</h4>
            <p><a href='http://time.com/3836242/nepal-earthquake-donations-disaster-relief/'>TIME 6 Ways You Can Give to Nepal Earthquake Relief</a></p>
            <p><a href='http://mariashriver.com/blog/2015/04/8-ways-you-can-help-nepal-earthquake-victims/'>8 Ways You Can Help Nepal Earthquake Victims BY MARIASHRIVER.COM</a></p>
            
            ";
    
};

1;

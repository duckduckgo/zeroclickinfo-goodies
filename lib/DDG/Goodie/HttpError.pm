package DDG::Goodie::HTTP_error;
# ABSTRACT:inputing  HTML error message should show results for resolutions.

use DDG::Goodie;
use strict;

zci answer_type => "http_error";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "HTTP errors";
description "Will display the description for HTTP Errors";
primary_example_queries "http error 404", "http error 500";

category "reference";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
 topics "web_design","sysadmin";
code_url "https://github.com/gautamkrishnar/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HTTP_error.pm";
attribution github => ["gautamkrishnar", "Gautam Krishna R"],
            twitter => "gautamkrishnar";

# Triggers
triggers start => 'http error','error';

# Handle statement
handle remainder => sub {
    return "Web browser is able to connect to the web server, but the webpage can't be found because of a problem with the web address (URL). This error message often happens because the website address is typed incorrectly. Make sure the address is correct and try again."  if($_=="400");
    return "Web browser is able to connect to the website, but doesn't have permission to display the webpage. This can happen for a variety of reasons. The website's administrator has to give you permission to view the page or the web server doesn't accept public webpage requests. If this is a website that you should have access to, contact the website administrator. "  if($_=="403");
    return "Web browser is able to connect to the website, but the webpage isn't found. This error is sometimes caused because the webpage is temporarily unavailable (in which case, you can try again later) or because the webpage has been deleted. . "  if($_=="404");
    return "Web browser is able to connect to the website, but the webpage content can't be downloaded to your computer. This is usually caused by a problem in the way the webpage was programmed.. "  if($_=="405");
    return "Web browser is able to receive information from the website but the information isn't in a format that the browser can display.. "  if($_=="406");
    return "The server took too long to display the webpage or there were too many people requesting the same page. Try again later.. "  if($_=="408");
    return "The server took too long to display the webpage or there were too many people requesting the same page. Try again later.. "  if($_=="409");
    return "Web browser is able to connect to the website, but the webpage can't be found. Unlike HTTP error 404, this error is permanent and was turned on by the website administrator. It's sometimes used for limited-time offers or promotional information.. "  if($_=="410");
    return "The website you're visiting had a server problem that prevented the webpage from displaying. It often occurs as a result of website maintenance or because of a programming error on interactive websites that use scripting.. "  if($_=="500");
    return "Implies 'Not Implemented', means that the website you're visiting isn't set up to display the content your browser is requesting. For example, the browser is asking for a file with a video extension (.AVI), but is telling the website it's looking for an HTML page.. "  if($_=="501");
    return "Implies 'Version Not Supported', means the website doesn't support the version of the HTTP protocol your browser uses to request the webpage (HTTP/1.1 being the most common). " if($_=="505");
    return;
};
1;

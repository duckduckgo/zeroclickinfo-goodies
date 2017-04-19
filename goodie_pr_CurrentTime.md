# Goodie Pull Request Template

We ask that you please use this template when submitting an instant answer pull request so we can better understand it and help you along when necessary.

**What does your instant answer do?**
    Responds with current time, date, and zone in specified time zone.

**What problem does your instant answer solve (Why is it better than organic links)?**
    Someone just wants to know what time it is somewhere. We can provide an instant answer to that question rather than have them search another page for it.

**What is the data source for your instant answer? (Provide a link if possible)**
    Data source is the tz file on the server, the Olson timezone list, leveraged through DateTime.

**Why did you choose this data source?**
    It's native and it's fast.

**Are there any other alternative (better) data sources?**
    Not really, anything else that runs native or runs this fast is using the same ultimate source.

**What are some example queries that trigger this instant answer?**
    primary_example_queries "current time in Tokyo", "time in New York";
    secondary_example_queries "London time", "what time is it in chicago";

**Which communities will this instant answer be especially useful for? (gamers, book lovers, etc)**
    anybody who is traveling or has friends/coworkers/clients in another location

**Is this instant answer connected to an [Ideas.DuckDuckHack](https://duckduckhack.uservoice.com/forums/5168-ideas-for-duckduckgo-instant-answer-plugins) or [Duck.co](http://duck.co/) thread?**
    yes, it's at <a href="https://dukgo.com/ideas/idea/38/use-other-source-or-develop-as-a-goodie-current" target="_blank">https://dukgo.com/ideas/idea/38/use-other-source-or-develop-as-a-goodie-current</a>

**Which existing instant answers will this one supercede/overlap with?**
    There is currently an instant answer which queries Wolfram Alpha for current time information. This goodie was requested in uservoice because the current instant answer is slow loading on the page and results in a single line of text which DDG could easily provide without the extra overhead.

**Are you having any problems? Do you need our help with anything?**
    I am having problems with automated testing due to the dynamic nature of this instant answer. How does one tell a script what time it will be in advance? I would certainly appreciate any pointers, particularly with the knotty problem of a vague query asking for time resulting in multiple time zone matches, still working on how to handle that situation.

**\*\*Note:** Please attach a screenshot for new instant answer pull requests, and for pull requests which modify the look/design of existing instant answers.

##Checklist
Please place a ✔ where appropriate.

    My test file fails because these answers are dynamic and I don't know how to tell them what answer to expect because the time will change with each test command. This is certainly somewhere that I could use a little help :) Also, I haven't figured out how to test on other browsers with the VM all sandboxed. I haven't been able to install any browsers nor can I access the VM server from my host machine.

    So I haven't fully tested yet but wanted to get a pull request in so I could get some feedback and make sure I'm on the right track. I've run dzil test and I haven't broken anything so that's a good sign. I don't have access to most of these browsers, but as this Instant Answer provides a single line of text with one span of font-style:italic and one possible <br /> tag I don't foresee a problem.

```
[✔] Added metadata and attribution information
[] Wrote test file and added to t/ directory
[✔] Verified that instant answer adheres to design guidelines(https://github.com/duckduckgo/duckduckgo-documentation/blob/master/duckduckhack/styleguides/design_styleguide.md)
[] Tested cross-browser compatability

    Please let us know which browsers/devices you've tested on:
    - Linux, Ubuntu 12.04.2 LTS
        [✔] Firefox

    - Windows 8
        [] Google Chrome   
        [] Firefox         
        [] Opera           
        [] IE 10           

    - Windows 7
        [] Google Chrome   
        [] Firefox         
        [] Opera           
        [] IE 8            
        [] IE 9            
        [] IE 10           

    - Windows XP
        [] IE 7            
        [] IE 8            

    - Mac OSX
        [] Google Chrome   
        [] Firefox         
        [] Opera           
        [] Safari          

    - iOS (iPhone)
        [] Safari Mobile   
        [] Google Chrome   
        [] Opera           

    - iOS (iPad)
        [] Safari Mobile   
        [] Google Chrome   
        [] Opera            

    - Android
        [] Firefox         
        [] Native Browser  
        [] Google Chrome   
        [] Opera
```

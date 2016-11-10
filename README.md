# Welcome to DuckDuckHack!
We're a community of open source developers from around the world, contributing code to improve the DuckDuckGo search engine.


### The Programming Mission
We want every programming search to have great results, providing the information you need instantly. The Programming Mission empowers the community to create Instant Answers for reference, libraries, help, and tools.

For now, we are **only accepting Pull Requests and Issues related to the Programming Mission**.


## How to contribute
- [**Create new Goodie Instant Answers, and improve existing ones**](https://github.com/duckduckgo/zeroclickinfo-goodies/issues?q=is%3Aopen+is%3Aissue+label%3A"Mission%3A+Programming")
    - **Note**: Goodies are written in Perl (back-end) and JavaScript (front-end). They can also typically use CSS, and [Handlebars](http://handlebarsjs.com) Templates.
- [**Visit DuckDuckHack.com**](https://duckduckhack.com) to learn more about the Programming Mission, and how you can help us **analyze Instant Answer performance data** to determine new projects


### What are Goodie Instant Answers?
Goodies do not retrieve data from a third party API. Goodies provide their results entirely through server-side code. They may use a static data file stored on DuckDuckGo's server, but they do not call external resources.

#### Example: NPM Goodie
- [Code](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/JsMinify.pm) | [Example Query](https://duckduckgo.com/?q=js+minifier&ia=answer) | [Instant Answer Page](https://duck.co/ia/view/js_minify)

![javascript minifier search](https://cloud.githubusercontent.com/assets/873785/20068349/626d9036-a4e6-11e6-945b-790bae2d2cdc.png)


## Resources
- Join the [DuckDuckHack Slack channel](https://quackslack.herokuapp.com/) to ask questions
- Join the [DuckDuckHack Forum](https://forum.duckduckhack.com/) to discuss project planning and Instant Answer metrics
- Read the [Goodie documentation](https://docs.duckduckhack.com/walkthroughs/calculation.html) for technical help
- View the list of [all live Goodie Instant Answers](https://duck.co/ia?repo=goodies&topic=programming) to see more examples

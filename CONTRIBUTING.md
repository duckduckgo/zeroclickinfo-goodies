# Contributing an Instant Answer to DuckDuckGo.com

> You can find the full [DuckDuckHack documentation here](http://docs.duckduckhack.com)

Have an idea [that no one has done yet](https://duck.co/ia)? Improving an [existing Instant Answer](https://duck.co/ia/dev/issues)? 

1. **Before coding, [create an Instant Answer Page](https://duck.co/ia/new_ia) for your idea.** If you're fixing an existing Instant Answer, [locate its existing page](https://duck.co/ia).

	> Instant Answer Pages are the "home base" for each Instant Answer. They are where the community plans, collaborates, and tracks the [life cycle](http://docs.duckduckhack.com/submitting/long-term.html) of all Instant Answers. It's where we aggregate pull requests, issues, attribution, and feedback.

2. **Hack away, keeping the [Instant Answer Production Guidelines](http://docs.duckduckhack.com/submitting/checklist.html) in mind.**

3. **[Submit a pull request](http://docs.duckduckhack.com/submitting/pull-request.html).** 

	> Make sure to paste your Instant Answer page URL in the description. This will automatically link the two.

We're excited to meet you and support you along the way - and it's never too early to say hello. Join us on [Slack](mailto:QuackSlack@duckduckgo.com?subject=AddMe) or [email](mailto:open@duckduckgo.com). 

*The opportunities to contribute don't stop here. Learn about [keeping your IA awesome](http://docs.duckduckhack.com/submitting/long-term.html).*


## Pull Request Format

When submitting a pull request, the following guidelines help speed up the review process:

If your IA is new, use the format: `"New {IA TOPIC} {IA TYPE}"`. For example:

	- "New Instagram Spice"
	- "New Firefox Cheat Sheet"
	
If you're submitting a fix, use the title format: `"{IA NAME}: Brief explanation`. For example:
	
	- "PeopleInSpace: Use smaller local image, fallback to API when needed."
	
Include the issue number in the description (conveniently, this will automatically resolve the issue upon merging). Describe your motivation, thought process, and solution in the description. For example:

	- "**Fixes #2038.** The images used by the API are very large and don't change often. I've but a smaller version of each image (and a 2x version for retina screens) in the share directory. The callback will try and load a local image based on the astronauts name and fallback to using the API's image if one does not exist."

**Finally, don't forget to paste the relevant [Instant Answer Page URL](https://duck.co/ia/new_ia) in the description field**, while creating new pull requests. This will automatically link the two.

> **IMPORTANT:** Don't worry if you get an initial error regarding failing Travis tests. The reason is that your IA page hasn't yet been moved out of the "Planning" status - which only community leaders/staff can do. As long as the ID in your IA page matches the ID in your code, and you've pasted the URL to your IA page, you can ignore this initial error.
	

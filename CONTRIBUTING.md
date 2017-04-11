<center>
    <a href="https://duckduckhack.com/issues">
        <img src="https://duckduckgo.com/assets/logo_homepage.normal.v107.svg" alt="duckduckgo">
    </a>
</center>

# Contributing to DuckDuckGo

We're an open source community dedicated to improving search results with _Instant Answers_. Instant Answers use the Web's most trust APIs and data to solve searches in few or zero clicks. Together and openly, we can create the best search engine for every type of search. We hope you'll join us!

## Contents

  - [Our Core Values](#our-core-values)
  - [Reporting Issues]()
  - [Making Pull Requests](#pull-requests)
      - [New Instant Answers](#new-instant-answers)
      - [Improvements](#improvements)
  - [Reviewing Pull Requests](#reviewing-pull-requests)
  - [Not following these guidelines](#not-following-these-guidelines)
  - [Not Sure?](#not-sure)
  

## Our Core Values

We are open source to the core. By collaborating with our users we can crowd source the highest quality Instant Answers. Contributing to DuckDuckHack has a direct impact on the end user. In light of this, we ask you to keep our core values in mind. In everything we do, we:

    - Build Trust
    - Question Assumptions
    - Validate Direction

## Reporting Issues

Reporting issues is a great opportunity to highlight problems or improvements to the community. We have an established practice we adhere to, and we encourage you to follow these to ensure that it is dealt with swiftly and appropriately. 

1. Use the Issues Template provided for you in the issues repo
2. Be as descriptive as possible. How can another person reproduce this issue?
3. If it's an issue with an Instant Answer, make sure it belongs to that repo.
4. Mention the maintainer and other developers of interests to so they aware.

## Pull Requests

When submitting a pull request, the following guidelines help speed up the review process:

### New Instant Answers

1. New IAs should be titled as follows: **`New {IA TOPIC} {IA TYPE}`**. For example, `New Instagram Spice` or `New Firefox Cheat Sheet`

2. Paste the relevant [Instant Answer Page URL](https://duck.co/ia/new_ia) in the description field. This will automatically link the PR to the Instant Answer.
    
### Improvements

1. Fixes should be titled as follows: **`{IA NAME}: Brief explanation`**. For example: `PeopleInSpace: Use smaller local image, fallback to API when needed.`

2. Paste the relevant [Instant Answer Page URL](https://duck.co/ia/new_ia) in the description field. This will automatically link the PR to the Instant Answer.

3. Include the issue number in the description (conveniently, this will automatically resolve the issue upon merging). Describe your motivation, thought process, and solution in the description. For example:

    "**Fixes #2038.** The images used by the API are very large and don't change often. I've put a smaller version of each image (and a 2x version for retina screens) in the share directory. The callback will try and load a local image based on the astronauts name and fallback to using the API's image if one does not exist."

> **IMPORTANT:** Don't worry if you get an initial error regarding failing Travis tests. The reason is that your IA page hasn't yet been moved out of the "Planning" status - which only community leaders/staff can do. As long as the ID in your IA page matches the ID in your code, and you've pasted the URL to your IA page, you can ignore this initial error.

## Reviewing Pull Requests

Reviewing Pull Requests is another impactful way to contribute to DuckDuckHack. Community developers benefit and value feedback from each other and non-technical users. Please **be friendly**, **be timely** if requested for a review and **seek help** if you're uncomfortable with any of the above.

Some questions to keep in mind before approving / merging:

 - Does this PR solve the problem?
 - Has every new line of code been checked?
 - What is not clear from the code?
 - Is this code commented appropriately?
 - Is no harm done by testing the changes thoroughly?
 - Are there any quick wins that improve the implementation?

## Not following these guidelines

DuckDuckHack's guidelines are important and have been enforced for a reason. If you are reading this, you have probably been linked to this paragraph. Not following the above guidelines costs both staff and volunteers time which results in a loss of productivity. Once you have made the following adjustments, please ping a community leader to remove the `on-hold` status of your issue / pull request. If you are not sure, we will be happy to help.

## Not Sure?
- Join the [DuckDuckHack Slack channel](https://quackslack.herokuapp.com/) to ask questions
- Join the [DuckDuckHack Forum](https://forum.duckduckhack.com/) to discuss project planning
- Read the [documentation](https://docs.duckduckhack.com/) for technical help
- View the list of [all live Goodie Instant Answers](https://duck.co/ia) to see more examples


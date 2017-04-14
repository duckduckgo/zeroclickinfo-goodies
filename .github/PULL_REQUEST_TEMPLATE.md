<!-- 

~~ WARNING: PLEASE READ ALL COMMENTARY BEFORE SUBMITTING ~~ 

This PR template is not optional. The DuckDuckGo community and employees
have a set of standards which we all adhere to. Please take the time to
review this repo's CONTRIBUTING.md and follow the instructions in this
template. Failure to do so may result in your PR being closed or put
on hold. The sections in this PR template are:

1. THE PULL REQUEST TITLE
2. THE DESCRIPTION
3. RELATED ISSUES AND DISCUSSIONS
4. PEOPLE TO NOTIFY
5. TESTING & REVIEW
6. THE INSTANT ANSWER PAGE


~~ 1. THE PULL REQUEST TITLE

Use the appropriate format for your Pull Request title above ^^^^^:

If this is a bug fix:
{IA Name}: {Description of change}

If this is a New Instant Answer:
New {IA Name} Goodie

If this is something else:
{Tests/Docs/Other}: {Short Description}

-->


<!--
~~ 2. THE DESCRIPTION

What does this new Instant Answer do? 
What changes does this PR introduce?
Would including screenshots help convey your message?
Is this a work in progress, or do you think it's ready to be merged?
-->
## Description of new Instant Answer, or changes


<!--
~~ 3. RELATED ISSUES AND DISCUSSIONS

Link related issues here to automatically close them when PR is merged 
E.g. "Fixes #1234"
-->
## Related Issues and Discussions


<!-- 
~~ 4. PEOPLE TO NOTIFY

Please @mention any relevant people/groups under the following heading.
If you need your work deployed to Beta, please ping @moollaza
-->
## People to notify



<!-- 
~~ 5. TESTING AND REVIEW

DuckDuckGo aims to Build trust, Question Assumptions and Validate Direction in everything we do. Holistic and rigorous testing is is an important part of our 
culture and community. The following section is aimed at community leaders and
DDG staff to review.

-->
## Testing & Review
To be completed by Community Leader (or DDG Staff) when reviewing Pull Requests. 

**Pull Request**
- [ ] Title follows correct format (Specifies Instant Answer + Purpose)
- [ ] Description contains a valid Instant Answer Page Link (e.g. https://duck.co/ia/view/my_ia)

**Instant Answer Page** (for new Instant Answers)
- [ ] Instant Answer page is correctly filled out and contains:
    - The **Title** is appropriately named and formatted
    - The **IA topics** are present and appropriate
    - The **Description** is clear and coherent
    - **Source Name** exists if applicable
    - All **Example Queries** trigger on [Beta](https://beta.duckduckgo.com/)

**Code**
- [ ] Does this PR solve the intended problem?
- [ ] Has every line of new code been reviewed?
- [ ] Adheres to the [DuckDuckGo Style Guide](https://docs.duckduckhack.com/resources/code-style-guide.html)
- [ ] Behaviour is appropriately tested. If improvement, tests are adequately extended.
- [ ] There is no unnecessary files in place (such as editor config files)
- [ ] There is no API keys / secrets present
- [ ] This PR does no harm to the original IA
- [ ] Tests are passing (run `$ duckpan test <fathead_id>`)
    - Tester should report any failures

**Ready to merge?**

- [ ] Has this IA been deployed to and tested on [beta.duckduckgo.com](https://beta.duckduckgo.com/)?
- [ ] For larger commits, has this been approved be more than one community member?
- [ ] The number of reviews is appropriate for this type of PR
- [ ] The commit message is clear, coherent and fitting

**Pull Request Review Guidelines**: https://docs.duckduckhack.com/programming-mission/pr-review.html

<!-- 
~~ 6. THE INSTANT ANSWER PAGE

Please update the url below. This is needed for fetching metadata related to the IA.
The ID can be found by clicking the `?` icon beside the Instant Answer result on DuckDuckGo.com.

-->
---

Instant Answer Page: https://duck.co/ia/view/{ID}
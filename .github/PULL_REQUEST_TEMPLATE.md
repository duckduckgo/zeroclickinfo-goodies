<!-- Use the appropriate format for your Pull Request title above ^^^^^:

If this is a bug fix:
{IA Name}: {Description of change}

If this is a New Instant Answer:
New {IA Name} Goodie

If this is something else:
{Tests/Docs/Other}: {Short Description}

-->


## Description of new Instant Answer, or changes
<!-- What does this new Instant Answer do? What changes does this PR introduce? -->


## Related Issues and Discussions
<!-- Link related issues here to automatically close them when PR is merged -->
<!-- E.g. "Fixes #1234" -->


## People to notify
<!-- Please @mention any relevant people/organizations here: -->


## Testing & Review
To be completed by Community Leader (or DDG Staff) when reviewing Pull Request

**Pull Request**
- [ ] Title follows correct format (Specifies Instant Answer + Purpose)
- [ ] Description contains a valid Instant Answer Page Link (e.g. https://duck.co/ia/view/my_ia)

**Instant Answer Page** (for new Instant Answers)
- [ ] Instant Answer page is correctly filled out and contains:
    - The **Title** is appropriately named and formatted
    - The **IA topics** are present and appropriate
    - The **Description** is clear and coherent
    - **Source Name** exists if applicable (for "More at {source_name}" link)
    - All **Example Queries** trigger on [Beta](https://beta.duckduckgo.com/)

**Code**
- [ ] Adheres to the [DuckDuckGo Style Guide](https://docs.duckduckhack.com/resources/code-style-guide.html)
- [ ] Behaviour is appropriately tested. If improvement, tests are adequately extended.
- [ ] There is no unnecessary files in place (such as editor config files)
- [ ] There is no API keys / secrets present
- [ ] Tests are passing (run `$ duckpan test <fathead_id>`)
    - Tester should report any failures

**Ready to merge?**

- [ ] Has this IA been deployed to and tested on [beta.duckduckgo.com](https://beta.duckduckgo.com/)?
- [ ] For larger commits, has this been approved be more than one community member?
- [ ] The number of reviews is appropriate for this type of PR
- [ ] The commit message is clear, coherent and fitting

**Pull Request Review Guidelines**: https://docs.duckduckhack.com/programming-mission/pr-review.html

<!-- DO NOT REMOVE -->
---

<!-- The Instant Answer ID can be found by clicking the `?` icon beside the Instant Answer result on DuckDuckGo.com -->
Instant Answer Page: https://duck.co/ia/view/{ID}
<!-- FILL THIS IN:                           ^^^^ -->

# Contributing to Goodie

At DuckDuckGo, we truly appreciate our community members taking the time to contribute to our open-source repositories. In an effort to ensure contributions are easy for you to make and for us to manage, we have written some guidelines that we ask our contributors to follow so that we can handle pull requests in a timely manner with as little friction as possible.

## Getting Started

Before you can do anything, you first need a [GitHub account](https://github.com/signup/free). This is required because we use GitHub to handle all incoming *Pull Requests* (code modifications) and *Issues* (bug reports) which cannot be made without a GitHub account.

## Submitting a **Bug** or **Suggestion**

- Firstly, please make sure the bug is related to the Goodie repository. If this bug is about the DuckDuckGo API, or the relevancy of our search results, please visit our feedback page at <https://duckduckgo.com/feedback>. If you're unsure, its best to use the feedback page (your message will be passed along to the correct people).

- Check the Goodie [issues](https://github.com/duckduckgo/zeroclickinfo-goodies/issues) to see if an issue already exists for the given bug or suggestion
  - If one doesn't exist, create a GitHub issue in the Goodie repository
    - Clearly describe the bug/improvemnt, including steps to reproduce when it is a bug
  - If one already exists, please add any additional comments you have regarding the matter

If you're submitting a **pull request** (bugfix/addition):
- Fork the Goodie repository on GitHub

## Making Changes

- Before making any changes, refer to the [DuckDuckHack Styleguide](https://dukgo.com/duckduckhack/styleguide_overview) to ensure your changes are made in the correct fashion
- Make sure your commits are of a reasonable size. They shouldn't be too big (or too small)
- Make sure your commit messages effectively explain what changes have been made, and please identify which instant answer or file has been modified:

  ```shell
  CONTRIBUTING.md - Added the example commit message because it was missing
  ```

  is much better than:

  ```shell
  <bad_commit_example>
  ```

- Make sure you have added the necessary tests for your changes
    - When modifying the triggers, update existing tests and add some new tests to show it works as expected
    - When modifying the result, update existing tests accordingly
- Run `dzil test` (executes all tests in t/) to ensure nothing else was accidentally broken
- If your change affects an instant answer, remember to add yourself to the Metadata attribution list in the appropriate `.pm` file

## Submitting Changes

1. Commit your changes.

  ```shell
  git commit -a -m "My first instant answer that does X is ready to go!"
  ```

2. Get your commit history [how you like it](http://book.git-scm.com/4_interactive_rebasing.html).

  ```shell
  git rebase -i origin/master
  ```

  or

  ```shell
  git pull --rebase origin/master
  ```

3. Push your forked repository back to GitHub.

  ```shell
  git push
  ```

4. Add your info to the instant answer so we can give you credit for it on the [Goodies page](https://duckduckgo.com/goodies). You'll see your name or handle on the live site!
Check out the [Metadata documentation](https://dukgo.com/duckduckhack/metadata) for detailed instructions on how to include your name and links.

5. Go into GitHub and submit a [pull request!](http://help.github.com/send-pull-requests/) to the Goodie repository, making sure to use the Goodie repository's **[Pull Request Template](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/pull_request_template_goodie.md)**. This will let us know about your changes and start the conversation about integrating it into the live code.

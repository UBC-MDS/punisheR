# Contributor Guidelines

### 1. External Contributors 

If you would like to propose an update or report a bug to `punisheR`, please check out the repo's [issues](https://github.com/UBC-MDS/punisheR/issues) to see if it's in our backlog. You can create a new issue to report the bug (use `bug` label), to ask a question (use `question` label), or to propose an update to enhance the code (use `enhancement` label). 

To contribute to `punisheR`, you must fork the repo and make changes in the forked version:

```
https://github.com/yourusername/punisheR
```

Please follow the [Google style guide](https://google.github.io/styleguide/Rguide.xml) for R syntax and documentation.

Once you have made all of your proposed updates, submit a **pull request** and reference the appropriate `issue` that you have tackled.

**Note:** As a contributor, you must adhere to the terms outlined in our [Contributor Code of Conduct](CONDUCT.md).


### 2. Core Contributors

- All core contributors should work locally and push into their *own-dev* branch.

- When a contributor wants to merge with the *master* branch, they should create a pull request and assign it to a fellow contributor for verifying.

- The user who created the pull request should not merge the request with the *master* branch.

- **Requirements for merging a PR:**
    - All pull requests must pass the TravisCI build in order to be merged.
    - All code must pass `devtools::check()` without errors before being merged. 
    - It is recommended that contributors run [lintr](https://github.com/jimhester/lintr) before submitting a PR.
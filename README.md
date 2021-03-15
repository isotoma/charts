# Charts

Isotoma Public Helm Charts

Charts hosted here: https://isotoma.github.io/charts/

## Contributing

- Make sure that what you are contributing is OK to be public
- Open a PR to change/add/remove a chart
- Linting happens in CI, which checks various (fairly strict) things
    - And installs the chart in a test k8s cluster
    - Make sure the default values allow the chart to be installed (or CI will fail)
    - And make sure you bump the chart version number (or CI will fail)
- Can run linting locally with `./tools/lint.sh`
    - By default, this compares the current branch with `main`, akin to the CI for a PR
    - Can pass `--all` to lint all charts, but ignoring checks for changes against `main`, eg version bumps
        - See https://github.com/helm/chart-testing/blob/master/doc/ct_lint.md#options for all options

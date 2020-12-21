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

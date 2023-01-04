# Cronjobber Helm Chart

Built on https://github.com/hiddeco/cronjobber/tree/master/chart

Cronjobber is the cronjob controller from Kubernetes patched with time zone support.

## Configuration

The following table lists the configurable parameters of the cronjobber chart and their default values.

| Parameter                                    | Description                                      | Default                                                             |
|----------------------------------------------|--------------------------------------------------|---------------------------------------------------------------------|
| `nameOverride`                               |                                                  |                                                                     |
| `fullnameOverride`                           |                                                  |                                                                     |
| `serviceAccount.annotations`                 |                                                  | `{}`                                                                |
| `image.repository`                           | Container image name                             | `quay.io/hiddeco/cronjobber`                                        |
| `image.tag`                                  | Container image tag                              | `0.3.0`                                                             |
| `replicas`                                   | Number of replicas                               | `1`                                                                 |
| `resources.requests.cpu`                     | CPU request for the main container               | `50m`                                                               |
| `resources.requests.memory`                  | Memory request for the main container            | `64Mi`                                                              |
| `sidecar.enabled`                            | Sidecar to keep the timezone database up-to-date | `False`                                                             |
| `sidecar.image.repository`                   | Sidecar and init container image name            | `quay.io/hiddeco/cronjobber-updatetz`                               |
| `sidecar.image.tag`                          | Sidecar and init container image tag             | `0.1.1`                                                             |
| `sidecar.resources.requests.cpu`             | Sidecar and init container cpu request           | `100m`                                                              |
| `sidecar.resources.requests.memory`          | Sidecar and init container memory request        | `64Mi`                                                              |
| `rbac.apiVersion`                            | Specify an API version for RBAC resources        |                                                                     |
| `rbac.apiVersionPolicy.newestAvailable`      | Use the newest candidate version available       | `false`                                                             |
| `rbac.apiVersionPolicy.candidateApiVersions` | List of API versions to check for, old to new    | `rbac.authorization.k8s.io/v1beta1`, `rbac.authorization.k8s.io/v1` |
| `crd.apiVersion`                             | Specify an API version for the CRD resource      |                                                                     |
| `crd.apiVersionPolicy.newestAvailable`       | Use the newest candidate version available       | `false`                                                             |
| `crd.apiVersionPolicy.candidateApiVersions`  | List of API versions to check for, old to new    | `apiextensions.k8s.io/v1beta1`, `apiextensions.k8s.io/v1`           |

## Usage

Instead of creating a [`CronJob`](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/)
like you normally would, you create a `TZCronJob`, which works exactly
the same but supports an additional field: `.spec.timezone`. Set this
to the time zone you wish to schedule your jobs in and Cronjobber will
take care of the rest.

```yaml
apiVersion: cronjobber.hidde.co/v1alpha1
kind: TZCronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  timezone: "Europe/Amsterdam"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo "Hello, World!"
          restartPolicy: OnFailure
```

{{/*
Dynamic apiVersion resolution
*/}}
{{- define "cronjobber._dynamicApiVersionResolution" -}}
{{- /* use an explicit version if set */ -}}
{{- if ._args.apiVersion -}}
  {{- ._args.apiVersion -}}
{{- else -}}
  {{- /* otherwise, check the candidate versions, and pick the first match found, starting from the top or the bottom of the list, depending on apiVersionPolicy.newestAvailable */ -}}
  {{- $matchingApiVersion := "" -}}
  {{- $resourceType := ._args._resourceType }}
  {{- range $candidateApiVersion := (._args.apiVersionPolicy.newestAvailable | ternary (reverse ._args.apiVersionPolicy.candidateApiVersions) ._args.apiVersionPolicy.candidateApiVersions) -}}
    {{- if not $matchingApiVersion }}
      {{- if $.Capabilities.APIVersions.Has (printf "%s/%s" $candidateApiVersion $resourceType) -}}
        {{- $matchingApiVersion = $candidateApiVersion -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $matchingApiVersion -}}
  {{- end -}}
{{- end -}}

{{/*
RBAC apiVersion
*/}}
{{- define "cronjobber.rbacApiVersion" -}}
{{- $_ := set . "_args" (.Values.rbac | deepCopy | merge (dict "_resourceType" "ClusterRole")) -}}
{{- include "cronjobber._dynamicApiVersionResolution" . }}
{{- $_ := unset . "_args" -}}
{{- end -}}

{{/*
CRD apiVersion
*/}}
{{- define "cronjobber.crdApiVersion" -}}
{{- $_ := set . "_args" (.Values.crd | deepCopy | merge (dict "_resourceType" "CustomResourceDefinition")) -}}
{{- include "cronjobber._dynamicApiVersionResolution" . }}
{{- $_ := unset . "_args" -}}
{{- end -}}

{{/*
CRD additional printer columns
*/}}
{{- define "cronjobber.crdAdditionalPrinterColumns" -}}
{{- $apiVersion := (include "cronjobber.crdApiVersion" .) | required "Unable to determine apiVersion for CustomResourceDefinition and none explicitly set." -}}
{{- $jsonPath := (eq $apiVersion "apiextensions.k8s.io/v1beta1") | ternary "JSONPath" "jsonPath" -}}
- name: Schedule
  type: string
  description: The schedule defining the interval a TZCronJob is run
  {{ $jsonPath }}: .spec.schedule
- name: Time zone
  type: string
  description: The time zone the interval of a TZCronJob is calculated in
  {{ $jsonPath }}: .spec.timezone
- name: Last schedule
  type: date
  description: The last time a Job was scheduled by a TZCronJob
  {{ $jsonPath }}: .status.lastScheduleTime
- name: Age
  type: date
  {{ $jsonPath }}: .metadata.creationTimestamp
{{- end -}}

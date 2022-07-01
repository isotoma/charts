{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "efs-provisioner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "efs-provisioner.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified chart name.
*/}}
{{- define "efs-provisioner.chartname" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "efs-provisioner.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "efs-provisioner.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
StorageClass apiVersion
*/}}
{{- define "efs-provisioner.storageClassApiVersion" -}}
{{- with .Values.efsProvisioner.storageClass }}
{{- /* use an explicit version if set */ -}}
{{- if .apiVersion -}}
  {{- .apiVersion -}}
{{- else -}}
  {{- /* otherwise, check the candidate versions, and pick the first match found, starting from the top or the bottom of the list, depending on apiVersionPolicy.newestAvailable */ -}}
  {{- $matchingApiVersion := "" -}}
  {{- range $candidateApiVersion := (.apiVersionPolicy.newestAvailable | ternary (reverse .apiVersionPolicy.candidateApiVersions) .apiVersionPolicy.candidateApiVersions) -}}
    {{- if not $matchingApiVersion }}
      {{- if $.Capabilities.APIVersions.Has (printf "%s/StorageClass" $candidateApiVersion) -}}
        {{- $matchingApiVersion = $candidateApiVersion -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $matchingApiVersion -}}
  {{- end -}}
{{- end -}}
{{- end -}}
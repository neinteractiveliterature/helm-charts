{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "intercode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "intercode.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "intercode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "intercode.databaseConfig" -}}
- name: DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-postgresql
      key: postgresql-password
- name: DATABASE_URL
  value: "postgres://{{ .Values.postgresql.postgresqlUsername }}:$(DATABASE_PASSWORD)@{{ .Release.Name }}-postgresql:{{ .Values.postgresql.service.port }}/{{ .Values.databaseName }}"
{{- end -}}

{{- define "intercode.env" -}}
{{ include "intercode.databaseConfig" . }}
- name: AWS_REGION
  value: {{ .Values.awsRegion | quote }}
- name: AWS_S3_BUCKET
  value: {{ .Values.awsS3Bucket | quote }}
- name: AWS_ACCESS_KEY_ID
  value: {{ .Values.awsAccessKeyId | quote }}
- name: AWS_SECRET_ACCESS_KEY
  value: {{ .Values.awsSecretAccessKey | quote }}
- name: INTERCODE_HOST
  value: {{ .Values.intercodeHost | quote }}
- name: RAILS_ENV
  value: {{ .Values.railsEnv | quote }}
- name: RAILS_LOG_TO_STDOUT
  value: enabled
- name: RAILS_MAX_THREADS
  value: {{ .Values.railsMaxThreads | quote }}
- name: RAILS_SERVE_STATIC_FILES
  value: enabled
{{- end -}}

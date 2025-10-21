{{/*
Expand the name of the chart.
*/}}
{{- define "sourcebot.name" -}}
{{- default $.Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sourcebot.fullname" -}}
{{- if $.Values.fullnameOverride }}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default $.Chart.Name $.Values.nameOverride }}
{{- if contains $name $.Release.Name }}
{{- $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $.Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sourcebot.chart" -}}
{{- printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sourcebot.labels" -}}
helm.sh/chart: {{ include "sourcebot.chart" $ }}
{{ include "sourcebot.selectorLabels" $ }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
{{- with $.Values.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sourcebot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sourcebot.name" $ }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{/*
Create the image to use for the container.
*/}}
{{- define "sourcebot.image" -}}
{{- if $.Values.sourcebot.image.digest -}}
"{{ $.Values.sourcebot.image.repository }}@{{ $.Values.sourcebot.image.digest }}"
{{- else if $.Values.sourcebot.image.tag -}}
"{{ $.Values.sourcebot.image.repository }}:{{ $.Values.sourcebot.image.tag }}"
{{- else -}}
"{{ $.Values.sourcebot.image.repository }}:{{ $.Chart.AppVersion }}"
{{- end -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sourcebot.serviceAccountName" -}}
{{- if $.Values.sourcebot.serviceAccount.create }}
{{- default (include "sourcebot.fullname" $) $.Values.sourcebot.serviceAccount.name }}
{{- else }}
{{- default "default" $.Values.sourcebot.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return PostgreSQL hostname
*/}}
{{- define "sourcebot.postgresql.hostname" -}}
{{- if .Values.postgresql.host }}
{{- .Values.postgresql.host }}
{{- else if .Values.postgresql.deploy }}
{{- printf "%s-postgresql" (include "sourcebot.fullname" .) -}}
{{- end }}
{{- end }}

{{/*
Return Redis hostname
*/}}
{{- define "sourcebot.redis.hostname" -}}
{{- if .Values.redis.host }}
{{- .Values.redis.host }}
{{- else if .Values.redis.deploy }}
{{- printf "%s-redis-primary" (include "sourcebot.fullname" .) -}}
{{- end }}
{{- end }}

{{/*
Helper to get value or secret reference
Returns either a direct value or a valueFrom secretKeyRef
*/}}
{{- define "sourcebot.getValueOrSecret" -}}
{{- if .value.existingSecret }}
valueFrom:
  secretKeyRef:
    name: {{ .value.existingSecret }}
    key: {{ .value.existingSecretKey }}
{{- else if .value.value }}
value: {{ .value.value | quote }}
{{- end }}
{{- end }}

{{/*
Database environment variables
Builds DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_ARGS
These will be assembled into DATABASE_URL by the entrypoint.sh script
*/}}
{{- define "sourcebot.databaseEnv" -}}
- name: DATABASE_HOST
  value: {{ include "sourcebot.postgresql.hostname" . | quote }}
- name: DATABASE_PORT
  value: {{ .Values.postgresql.port | quote }}
- name: DATABASE_USERNAME
  value: {{ .Values.postgresql.auth.username | quote }}
- name: DATABASE_PASSWORD
{{- if .Values.postgresql.auth.existingSecret }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.postgresql.auth.existingSecret }}
      key: {{ .Values.postgresql.auth.secretKeys.userPasswordKey }}
{{- else }}
  value: {{ required "postgresql.auth.password is required when existingSecret is not set" .Values.postgresql.auth.password | quote }}
{{- end }}
- name: DATABASE_NAME
  value: {{ .Values.postgresql.auth.database | quote }}
{{- if .Values.postgresql.auth.args }}
- name: DATABASE_ARGS
  value: {{ .Values.postgresql.auth.args | quote }}
{{- end }}
{{- end -}}

{{/*
Redis environment variables
Builds REDIS_URL connection string
*/}}
{{- define "sourcebot.redisEnv" -}}
{{- $redisPassword := "" -}}
{{- if .Values.redis.auth.existingSecret }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.redis.auth.existingSecret }}
      key: {{ .Values.redis.auth.existingSecretPasswordKey }}
- name: REDIS_URL
  value: "redis://{{ .Values.redis.auth.username }}:$(REDIS_PASSWORD)@{{ include "sourcebot.redis.hostname" . }}:{{ .Values.redis.port }}/{{ .Values.redis.auth.database }}"
{{- else }}
{{- $redisPassword = required "redis.auth.password is required when existingSecret is not set" .Values.redis.auth.password -}}
- name: REDIS_URL
  value: "redis://{{ .Values.redis.auth.username }}:{{ $redisPassword }}@{{ include "sourcebot.redis.hostname" . }}:{{ .Values.redis.port }}/{{ .Values.redis.auth.database }}"
{{- end }}
{{- end -}}

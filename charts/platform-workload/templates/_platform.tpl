{{/*
===============================================================================
Platform Injection Engine

This file contains helper templates used to build platform-owned resources.

It DOES NOT create Kubernetes resources.

Platform-owned resources:
- platform-config
- platform-secret

Future:
- annotations
- volumes
- volumeMounts
- serviceAccount
===============================================================================
*/}}

{{/*
===============================================================================
Platform ConfigMap data
===============================================================================
*/}}

{{- define "platform.config.data" -}}

{{- if .Values.platform.postgres.enabled }}
- name: POSTGRES_HOST
  value: {{ .Values.platformDefaults.postgres.host | quote }}

- name: POSTGRES_PORT
  value: {{ .Values.platformDefaults.postgres.port | quote }}
{{- end }}

{{- if .Values.platform.redpanda.enabled }}
- name: REDPANDA_BROKERS
  value: {{ .Values.platformDefaults.redpanda.brokers | quote }}
{{- end }}

{{- end }}

{{/*
===============================================================================
Platform Secret data
===============================================================================
*/}}

{{- define "platform.secret.data" -}}

{{- if .Values.platform.postgres.enabled }}
- name: POSTGRES_USER
  value: {{ .Values.platformDefaults.postgres.username | quote }}

- name: POSTGRES_PASSWORD
  value: {{ .Values.platformDefaults.postgres.password | quote }}
{{- end }}

{{- end }}

{{/*
===============================================================================
Should platform ConfigMap be created?
===============================================================================
*/}}

{{- define "platform.config.enabled" -}}

{{- if or
      .Values.platform.postgres.enabled
      .Values.platform.redpanda.enabled
}}

true

{{- end }}

{{- end }}

{{/*
===============================================================================
Should platform Secret be created?
===============================================================================
*/}}

{{- define "platform.secret.enabled" -}}

{{- if .Values.platform.postgres.enabled }}

true

{{- end }}

{{- end }}
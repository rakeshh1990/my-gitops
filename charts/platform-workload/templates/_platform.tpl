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
Platform Environment Variables

Inject non-sensitive platform configuration directly into the Pod.
===============================================================================
*/}}

{{- define "platform.env" -}}

{{- if .Values.platform.postgres.enabled }}
- name: POSTGRES_HOST
  value: {{ .Values.platformDefaults.postgres.host | quote }}

- name: POSTGRES_PORT
  value: {{ .Values.platformDefaults.postgres.port | quote }}
{{- end }}

{{- if .Values.platform.redpanda.enabled }}
- name: KAFKA_BROKER
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
POSTGRES_USER: {{ .Values.platformDefaults.postgres.username | quote }}
POSTGRES_PASSWORD: {{ .Values.platformDefaults.postgres.password | quote }}
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
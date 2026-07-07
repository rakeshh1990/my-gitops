{{/*
===============================================================================
Platform Capability Engine

This file provides helper templates used by workloads to
inject platform capabilities.

Current capabilities:
- PostgreSQL
- Redpanda

Platform secrets are provided by External Secrets.
Platform constants are injected directly as environment variables.

Future capabilities:
- Observability
- AI
- Redis
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
Should platform Secret be injected?
===============================================================================
*/}}

{{- define "platform.secret.enabled" -}}

{{- if .Values.platform.postgres.enabled }}

true

{{- end }}

{{- end }}
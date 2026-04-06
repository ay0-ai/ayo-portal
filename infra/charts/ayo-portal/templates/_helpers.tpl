{{- define "ayo-portal.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ayo-portal.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ayo-portal.labels" -}}
app.kubernetes.io/name: {{ include "ayo-portal.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{- define "ayo-portal.image" -}}
{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- end }}


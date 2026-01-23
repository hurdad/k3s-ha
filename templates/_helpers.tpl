{{- define "k3s-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "k3s-server.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "k3s-server.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "k3s-server.labels" -}}
app.kubernetes.io/name: {{ include "k3s-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote }}
{{- end -}}

{{- define "k3s-server.annotations" -}}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote }}
{{- end -}}

{{- define "k3s-server.apiServiceName" -}}
{{- printf "%s-api" (include "k3s-server.fullname" .) -}}
{{- end -}}

{{- define "k3s-server.apiServiceHost" -}}
{{- printf "%s.%s.svc" (include "k3s-server.apiServiceName" .) .Release.Namespace -}}
{{- end -}}

{{- define "k3s-server.headlessServiceName" -}}
{{- include "k3s-server.fullname" . -}}
{{- end -}}

{{- define "k3s-server.headlessServiceHost" -}}
{{- printf "%s.%s.svc" (include "k3s-server.headlessServiceName" .) .Release.Namespace -}}
{{- end -}}

{{- define "k3s-server.advertiseAddress" -}}
{{- if .Values.k3s.advertiseAddress -}}
{{- .Values.k3s.advertiseAddress -}}
{{- else -}}
{{- printf "${POD_NAME}.%s" (include "k3s-server.headlessServiceHost" .) -}}
{{- end -}}
{{- end -}}

{{- define "k3s-server.advertisePort" -}}
{{- if .Values.k3s.advertisePort -}}
{{- .Values.k3s.advertisePort -}}
{{- else -}}
{{- .Values.k3s.apiPort -}}
{{- end -}}
{{- end -}}

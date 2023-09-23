{{/* Шаблоны */}}
{{- define "marmarks-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Имя и версия чарта
*/}}
{{- define "marmarks-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 60 | trimSuffix "-" -}}
{{- end -}}

{{/*
Метки
*/}}
{{- define "marmarks-chart.labels" -}}
helm.sh/chart: {{ include "marmarks-chart.chart" . }}
{{ include "marmarks-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Обновление при изменении секретов или конфигураций
Определение функции вычисления хэш суммы
*/}}
{{- define "marmarks-chart.propertiesHash" -}}
{{- $producerSecrets := include (print $.Template.BasePath "/producer-secrets.yaml") . | sha256sum -}}
{{- $consumerSecrets := include (print $.Template.BasePath "/consumer-secrets.yaml") . | sha256sum -}}
{{- $producerConfig := include (print $.Template.BasePath "/producer-config.yaml") . | sha256sum -}}
{{- $consumerConfig := include (print $.Template.BasePath "/consumer-config.yaml") . | sha256sum -}}
{{ print $producerSecrets $producerConfig $consumerSecrets $consumerConfig | sha256sum }}
{{- end -}}

{{/*
Имена компонентов отправителя
*/}}
{{- define "marmarks-chart.producer.defaultName" -}}
{{- printf "producer-%s" .Release.Name -}}
{{- end -}}

{{- define "marmarks-chart.producer.deployment.name" -}}
{{- default (include "marmarks-chart.producer.defaultName" .) .Values.producer.deployment.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "marmarks-chart.producer.container.name" -}}
{{- default (include "marmarks-chart.producer.defaultName" .) .Values.producer.container.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "marmarks-chart.producer.service.name" -}}
{{- default (include "marmarks-chart.producer.defaultName" .) .Values.producer.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Имена компонентов получателя
*/}}
{{- define "marmarks-chart.consumer.defaultName" -}}
{{- printf "consumer-%s" .Release.Name -}}
{{- end -}}

{{- define "marmarks-chart.consumer.deployment.name" -}}
{{- default (include "marmarks-chart.consumer.defaultName" .) .Values.consumer.deployment.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "marmarks-chart.consumer.container.name" -}}
{{- default (include "marmarks-chart.consumer.defaultName" .) .Values.consumer.container.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "marmarks-chart.consumer.service.name" -}}
{{- default (include "marmarks-chart.consumer.defaultName" .) .Values.consumer.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Имена прочих компонентов компонентов (секретов, конфигов)
*/}}
{{- define "marmarks-chart.producerSecrets.defaultName" -}}
{{- printf "producer-secrets-%s" .Release.Name -}}
{{- end -}}

{{- define "marmarks-chart.consumerSecrets.defaultName" -}}
{{- printf "consumer-secrets-%s" .Release.Name -}}
{{- end -}}

{{- define "marmarks-chart.producerConfig.defaultName" -}}
{{- printf "producer-config-%s" .Release.Name -}}
{{- end -}}

{{- define "marmarks-chart.consumerConfig.defaultName" -}}
{{- printf "consumer-config-%s" .Release.Name -}}
{{- end -}}


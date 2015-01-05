#
# Cookbook Name:: oe-monitoring
# Recipe:: datadog_alarm
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#
# This recipe will issue a library function to generate alarms on DataDog
# based on attributes. An example:
#
# "datadog": {
#   "alerts": [
#     { 
#       "name":           "Alert name",
#       "message":        "Message body",
#       "aggregator":     "aggregator_string",  # avg|min|max|sum
#       "period":         "period_string",      # last_((5|10|15|30)m)|[124]h
#       "metric":         "<metric_string>",    # Valid metric
#       "group_by":       "tags",
#       "threshold":      "<threshold_string>", # '> 10', '< 100'
#       "enable_multi":   true|false
#     },
#     { ... }
#   ]
# }
#

chef_gem 'dogapi'

metric_data = node['datadog']['alerts'].each { |alarm|
  alarm_data = Hash.new
  alarm.map { |k,v| alarm_data[k.to_sym] = v }

  Snoopy.create_alert(alarm_data)
} unless node['datadog']['alerts'].nil?

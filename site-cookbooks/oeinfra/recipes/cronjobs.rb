#
# Cookbook Name:: oe-postgresql
# Recipe:: cron
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#
# Required attributes:
#   - schedule: c'mon ! it's self explanatory this one
#   - script: script to run
#
# Optional attributes:
#   - user: which user will run the cronjob
#   - opts: additional options to the script
#   - template: If this is defined, the script will load
#               a script template from 
#               oeinfra/templates/default/scripts/cron
#
# "cronjobs": {
#   "some_file": [
#     {
#       "schedule": "0 * * * *",
#       "script":   "/some/script"
#     },
#     {
#       "schedule": "0 1 * * *",
#       "user":     "user",
#       "script":   "/some/other/script",
#       "opts":     "--list --of --options",
#       "template": "some_script.sh.erb"
#     }
#   ]
# }
#

node['cronjobs'].keys.each { |cron_file|

  jobs = Array.new

  # Go through the list of jobs related to this cron file
  node['cronjobs'][cron_file].each { |job|

    if job['schedule'].nil? then
      Chef::Log.warn("Schedule not defined. Job entry data: #{job}")
      next
    end

    if job['script'].nil? then
      Chef::Log.warn("Script not defined. Job entry data: #{job}")
      next
    end

    job_user   = job['user'] || 'root'

    unless job['template'].nil? then
      template job['script'] do
        action  :create
        owner   'root'
        mode    0755
        source  "scripts/cron/#{job['template']}"
      end
    end

    jobs.concat(Array("#{job['schedule']} #{job_user} #{job['script']}"))
  }

  cnt = jobs.join("\n")
  file "/etc/cron.d/#{cron_file}" do
    action  :create
    owner   'root'
    group   'root'
    mode    0644
    content "#{cnt}\n"
  end if not jobs.empty?

}



class Chef::Recipe::Snoopy

  def self.get_alerts(search_key = nil, search_value = nil)
    
    require 'dogapi'

    @api_key = 'cb048854cdca01c056ce5881726478c1'
    @app_key = '7bb4bb0cfe3123671edea0ed4722ea6cf16eca02'
    @snoopy  = Dogapi::Client.new(@api_key, @app_key)

    status, alerts_arr = @snoopy.get_all_alerts()
    alerts = Hash.new
    alerts_arr['alerts'].each { |k| alerts[k['id'].to_s] = k }
    
    if search_key and search_value then
      alert_found = alerts.select { |k| alerts[k][search_key] == search_value }
      return alert_found.empty? ? false : true
    end
    
  end

  def self.create_alert(data = {}, search_key = 'name')
     require 'dogapi'

    @api_key = 'cb048854cdca01c056ce5881726478c1'
    @app_key = '7bb4bb0cfe3123671edea0ed4722ea6cf16eca02'
    @snoopy  = Dogapi::Client.new(@api_key, @app_key)

   
    aggregator = [ :avg, :min, :max, :sum ]
    period     = [ :last_5m, :last_10m, :last_15m, :last_30m, :last_1h, :last_2h, :last_4h ]
    
    # Validate some fields
    if not aggregator.include?(data[:aggregator].to_sym) then
      Chef::Log.error("Aggregator must be one of #{aggregator}")
      Chef::Log.error("Alert #{data[:name]} not created")
      return
    end
    
    if not period.include?(data[:period].to_sym) then
      Chef::Log.error("Period must be one of #{period}")
      Chef::Log.error("Alert #{data[:name]} not created")
      return
    end
    
    # Build query
    str   = "#{data[:aggregator]}(#{data[:period]}):#{data[:aggregator]}:"
    str <<= "#{data[:metric]}{#{data[:group_by]}} "
    str <<= "#{data[:enable_multi] ? 'by {host} ' : ''}"
    str <<= "#{data[:threshold]}"
    
    if self.get_alerts(search_key = search_key, search_value = data[search_key.to_sym]) then
      Chef::Log.warn("Query #{str} exists")
      return
    end

    status, alarm_data = @snoopy.alert(
      str,
      :notify_no_data => true,
      :name           => data[:name],
      :message        => data[:message],
    )
    
    Chef::Log.warn("Status: #{status}")
    Chef::Log.warn("Alarm data; #{alarm_data}")
  end

end

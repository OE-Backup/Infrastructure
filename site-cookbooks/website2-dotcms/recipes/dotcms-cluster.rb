#
# Cookbook Name:: website2-dotcms
# Recipe:: dotcms-cluster
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "website2-dotcms::dotcms"

indexed = false

#Search dotCMS nodes in the environment
pool_members = search("node", "role:app-ws2-cms-node AND chef_environment:#{node.chef_environment}") || []

#Check if node 1 is already set
indices = Array.new
pool_members.each do |ip|
  log ip.ipaddress
  if ip["dotcms"]["indexId"].is_a?Numeric 
    indexed = true
    indices.push(ip["dotcms"]["indexId"])
  end
end

if indexed == false
    log "Setting #{node.name} as member 1"
    node.normal["dotcms"]["indexId"] = 1
end

#Generate indexId number
if indices.length > 0 and node["dotcms"]["indexId"] == nil
    log "Indices.max: #{indices.max}"
    node.normal["dotcms"]["indexId"] = Integer(indices.max) + 1
    log "Settings #{node.name} as member #{node["dotcms"]["indexId"]}"
else
    log "Node indexId is already set to #{node["dotcms"]["indexId"]}"
end
indices.sort!

template "/opt/dotcms/dotserver/plugins/com.dotcms.config/conf/dotmarketing-config-ext.properties" do
  user "dotcms"
  group "dotcms"
  mode "0644"
  variables ({
    :dist_indexation_enabled => node["dotcms"]["dist_indexation_enabled"],
    :dist_indexation_server_id => node["dotcms"]["indexId"],
    :dist_indexation_servers_ids => indices.join(","),
    :cache_cluster_through_db => node["dotcms"]["cache_cluster_through_db"],
    :cache_force_ipv4 => node["dotcms"]["cache_force_ipv4"],
    :cache_protocol => node["dotcms"]["cache_protocol"],
    :cache_bindport => node["dotcms"]["cache_bindport"],
    :cache_bindaddress => node.ipaddress,
    :cache_tcp_initial_hosts => pool_members.map { |i| "#{i.ipaddress}[#{node['dotcms']['cache_bindport']}]"}.join(','),
    :es_cluster_name => node.chef_environment.to_s,
    :es_network_host => node.ipaddress,
    :es_transport_tcp_port => node["dotcms"]["es_transport_tcp_port"],
    :es_network_port => node["dotcms"]["es_network_port"],
    :es_http_enabled => node["dotcms"]["es_http_enabled"],
    :es_http_port => node["dotcms"]["es_http_port"],
    :es_discovery_zen_ping_multicast_enabled => node["dotcms"]["es_discovery_zen_ping_multicast_enabled"],
    :es_discovery_zen_ping_timeout => node["dotcms"]["es_discovery_zen_ping_timeout"],
    :es_discovery_zen_ping_unicast_hosts => pool_members.map { |i| "#{i.ipaddress}:#{node["dotcms"]["es_transport_tcp_port"]}"}.join(','),
    :elasticsearch_use_filters_for_searching => node["dotcms"]["elasticsearch_use_filters_for_searching"]
  })
end

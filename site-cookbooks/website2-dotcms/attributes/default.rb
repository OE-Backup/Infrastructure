default["dotcms"]["indexId"] = ""
default["dotcms"]["version"] = "2.5.2"
default["dotcms"]["dist_indexation_enabled"] = true
default["dotcms"]["cache_cluster_through_db"] = false
default["dotcms"]["cache_force_ipv4"] = true
default["dotcms"]["cache_protocol"] = "tcp"
default["dotcms"]["cache_bindport"] = "7800"
default["dotcms"]["es_transport_tcp_port"] = "9301"
default["dotcms"]["es_network_port"] = "9302"
default["dotcms"]["es_http_enabled"] = "false"
default["dotcms"]["es_http_port"] = "9303"
default["dotcms"]["es_discovery_zen_ping_multicast_enabled"] = false
default["dotcms"]["es_discovery_zen_ping_timeout"] = "15s"
default["dotcms"]["es_discovery_zen_minimum_master_nodes"] = "1"
default["dotcms"]["es_index_number_of_replicas"] = "2"
default["dotcms"]["es_index_number_of_shards"] = "1"
default["dotcms"]["es_gateway_recover_after_nodes"] = "1"
default["dotcms"]["es_gateway_recover_after_time"] = "2m"
default["dotcms"]["es_gateway_expected_nodes"] = "2"
default["dotcms"]["elasticsearch_use_filters_for_searching"] = true
default["dotcms"]["log4j_logger"]["com_bradmcevoy_http"] = "warn"
default["dotcms"]["log4j_logger"]["com_liferay_portal_action_LoginAction"] = "warn"
default["dotcms"]["log4j_logger"]["com_liferay_portal_action_LogoutAction"] = "warn"
default["dotcms"]["log4j_logger"]["com_liferay_portal_action_LoginAsAction"] = "warn"
default["dotcms"]["log4j_logger"]["com_liferay_portal_action_LogoutAsAction"] = "warn"
default["dotcms"]["log4j_logger"]["org_apache_nutch"] = "warn"
default["dotcms"]["log4j_logger"]["org_apache_hadoop"] = "warn"
default["dotcms"]["log4j_logger"]["com_dotmarketing_util_SecurityLogger"] = "warn"
default["dotcms"]["log4j_logger"]["com_dotmarketing_util_AdminLogger"] = "warn"
default["dotcms"]["log4j_logger"]["com_dotmarketing_util_ActivityLogger"] = "warn"
default["dotcms"]["log4j_logger"]["com_dotmarketing_servlets_test_ServletTestRunner"] = "warn"
default["dotcms"]["log4j_logger"]["com_dotmarketing_util_PushPublishLogger"] = "warn"
default["dotcms"]["log4j_logger"]["com_dotmarketing_velocity_VelocityServlet"] = "warn"
default["dotcms"]["log4j_logger"]["com_dotmarketing_viewtools"] = "warn"
default["dotcms"]["log4j_logger"]["com_sun_jersey_spi_container_servlet_WebComponent"] = "warn"
default["dotcms"]["log4j_logger"]["dotcms_log"]["MaxFileSize"] = "512MB"
default["dotcms"]["log4j_logger"]["dotcms_log"]["MaxBackupIndex"] = "30"
default["dotcms"]["log4j_logger"]["dotcms_velocity_log"]["MaxFileSize"] = "512MB"
default["dotcms"]["log4j_logger"]["dotcms_velocity_log"]["MaxBackupIndex"] = "30"
# -Xmx6G -Xms6G -Xmn512m -XX:MaxPermSize=512m 
default['dotcms']['java_mem'] = nil
default['dotcms']['java_jmx_opts'] = "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=true -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
default['dotcms']['java_jmx_rmi_registry_port'] = "39193"
default['dotcms']['java_jmx_rmi_server_port'] = "39194"
default['dotcms']['java_opts'] = "-Djava.awt.headless=true -Xverify:none -Dfile.encoding=UTF8 -server -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -javaagent:dotCMS/WEB-INF/lib/jamm-0.2.5.jar -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true"

default['dotcms']['jmx_jar_fs_path'] = "/opt/dotcms/dotserver/tomcat/lib"
default['dotcms']['tomcat_libs_bucket_path'] = "https://s3.amazonaws.com/infra-packages/tomcat-libs"
default['dotcms']['jmx_jar_file'] = "catalina-jmx-remote.jar"
default['dotcms']['plugin_response_headers_origin'] = "http://www2-elb.thinkglish.com,http://www2-br-elb.thinkglish.com,https://www2-elb.thinkglish.com,https://www2-br-elb.thinkglish.com,http://aprender.thinkglish.com,https://aprender.thinkglish.com,http://stg-website20-node1.thinkglish.com,https://stg-website20-node1.thinkglish.com,http://stg-website20-node2.thinkglish.com,https://stg-website20-node2.thinkglish.com,http://stage.thinkglish.com,http://stage-m.thinkglish.com"
default['oe-logs']['services']['tomcat'] = {
  'log' => {
    'prefix'  => '/mnt/dotcms/logs',
    'symlink' => '/opt/dotcms/dotserver/tomcat/logs',
    'owner'   => 'dotcms',
    'group'   => 'dotcms'
  }
}
default["oeinfra"]["openfiles"] = 65536


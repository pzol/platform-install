server {
  listen						8088;
  server_name				localhost;
  root 							/var/www/root;
  error_log  				<%= log_path %>/ruby_error.log;
  access_log  			<%= log_path %>/ruby_access.log;
  passenger_enabled on;
  passenger_min_instances 2;

  include 					/var/www/root/*/../nginx.conf;			# this includes all apps
  rack_env 					development;
}


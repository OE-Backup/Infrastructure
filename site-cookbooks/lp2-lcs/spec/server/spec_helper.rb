require 'serverspec'

@servers = {
  :webserver => {
    :pkg     => 'apache2',
    :service => 'apache2',
    :ports   => [ 80, 443 ],
  }

}

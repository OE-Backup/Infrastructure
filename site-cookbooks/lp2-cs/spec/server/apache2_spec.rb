
require 'spec_helper'

server = @servers[:webserver]

describe package(server[:pkg]) do
  it { should be_installed }
end

describe service(server[:service]) do
  it { should be_enabled }
  it { should be_running }
end

server[:ports].each { |p|
  describe port(p) do
    it { should be_listening }
  end
}


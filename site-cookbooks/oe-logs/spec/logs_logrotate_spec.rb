
require 'spec_helper'
require 'chef'

os = @platforms['Ubuntu 12.04']

describe 'oe-logs::logrotate' do

  let(:chef_run) { runner(attributes = os, environment = os[:environment]) }
  
  context 'Render logrotate templates for services' do
   
    before do
      #Chef::DataBag.stub(:load).with('').and_return(os[:data_bags][:])
      #Chef::EncryptedDataBagItem.stub(:load).with('', '').and_return(os[:data_bags][:][''])
    end
    
    os['oe-logs']['services'].each { |k,v|
      it "Should create a logrotate file for #{k} " do
        logrotate_conf = "#{os['oe-logs']['logrotate']['prefix']}/#{k}"
        chef_run.converge(described_recipe)
        expect(chef_run).to create_template(logrotate_conf).with(
          variables: { :service => k, :cfg => v['logrotate'] }
        )
      end
    }
  end

end


require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-monitoring::loggly' do

  let(:chef_run) { runner(attributes = os, environment = os[:environment]) }
  
  context 'Under normal situations' do

    before do
      Chef::EncryptedDataBagItem.stub(:load).with( 
        'third-party', 'loggly' 
      ).and_return(os[:data_bags]['third-party']['loggly'])
    end
    
    os['monitoring']['loggly']['services'].each { |k,v|
    
      it "Should create a rsyslog file for #{k} " do
        chef_run.converge(described_recipe)
        expect(chef_run).to render_file("#{chef_run.node['monitoring']['loggly']['prefix']}/#{k}")
      end
      
    }

  end

end

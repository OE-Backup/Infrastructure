
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-logs::log' do

  let(:chef_run) { runner(attributes = os, environment = os[:environment]) }
  
  context 'Setup logs' do
   
    before do
      #Chef::DataBag.stub(:load).with('').and_return(os[:data_bags][:])
      #Chef::EncryptedDataBagItem.stub(:load).with('', '').and_return(os[:data_bags][:][''])
    end
    
    os['oe-logs']['services'].each { |k,v|
      it "Should setup log for #{k} " do
        #logrotate_conf = "#{os['oe-logs']['logs']['prefix']}/#{k}"
        chef_run.converge(described_recipe)
        expect(chef_run).to create_directory(v['log']['prefix']).with(
          owner: v['log']['owner'],
          group: v['log']['group'],
        )
        # FIXME test ruby block
        expect(chef_run).to create_link(v['log']['symlink']).with({
          link_type: :symbolic,
          to:        v['log']['prefix'],
        })
      end
    }
  end

end

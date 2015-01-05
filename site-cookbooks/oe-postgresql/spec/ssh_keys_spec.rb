
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::ssh_keys' do

  let(:chef_run) { runner(attributes = os, environment = os[:environment]) }
  
  context '' do
   
    before do
      Chef::DataBag.stub(:load).with('ssh_keys').and_return(os[:data_bags][:ssh_keys])
      Chef::EncryptedDataBagItem.stub(:load).with('ssh_keys', 'user1').and_return(
        os[:data_bags][:ssh_keys]['user1']
      )
      chef_run.node.set['postgresql']['ssh_keys']['user'] = 'user1'
    end
    
    it "Should create .ssh directory" do
      chef_run.converge(described_recipe)
      expect(chef_run).to create_directory("#{os['etc']['passwd']['user1']['dir']}/.ssh")
    end
    
    it "Should create private key id_rsa" do
      chef_run.converge(described_recipe)
      expect(chef_run).to render_file("#{os['etc']['passwd']['user1']['dir']}/.ssh/id_rsa")
    end

    it "Should create authorized keys" do
      chef_run.converge(described_recipe)
      expect(chef_run).to render_file("#{os['etc']['passwd']['user1']['dir']}/.ssh/authorized_keys")
    end
    
  end

end

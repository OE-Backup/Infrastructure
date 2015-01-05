
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::pgpass' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  context 'Under normal situations:' do

    before do
      Chef::EncryptedDataBagItem.stub(:load).with(
        chef_run.node['postgresql']['data_bag']['users'],
        chef_run.node['postgresql']['data_bag_item']['users']
      ).and_return(os[:data_bags][:db][:users])
      chef_run.converge(described_recipe)
    end
    
    it 'Should render pgpass password file' do
      expect(chef_run).to render_file(
        "#{chef_run.node['postgresql']['prefix']['home']}/.pgpass"
      ).with_content(/repmgr:user1_password/)
    end

  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end


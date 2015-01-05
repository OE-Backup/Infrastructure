
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::default' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  context 'Under normal situations:' do

    before do
      Chef::EncryptedDataBagItem.stub(:load).with(
        chef_run.node['postgresql']['data_bag']['users'],
        chef_run.node['postgresql']['data_bag_item']['users']
      ).and_return(os[:data_bags][:db][:users])
      
      chef_run.node.set['oe-logs'] = os['oe-logs']
    end
    
    it 'Should include postgresql::server' do
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-postgresql::server')
    end

    it 'Should include postgresql::pgpass' do
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-postgresql::pgpass')
    end

    it 'Should include postgresql::server_type' do
      chef_run.node.set['postgresql']['server']['type'] = 'master'
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-postgresql::server_type')
    end

    it 'Should include oe-postgresql::log' do
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-postgresql::log')
    end

    it 'Should include oe-postgresql::sysctl' do
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-postgresql::sysctl')
    end

  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end


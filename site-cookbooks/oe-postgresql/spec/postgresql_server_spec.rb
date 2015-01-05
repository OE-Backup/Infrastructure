
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::server' do

  let(:chef_run) {
    runner(attributes = os)
  }
    
  context 'Under normal situations:' do

    before do
      Chef::EncryptedDataBagItem.stub(:load).with(
        chef_run.node['postgresql']['data_bag']['users'],
        chef_run.node['postgresql']['data_bag_item']['users']
      ).and_return(os[:data_bags][:db][:users])
      
      chef_run.node.set['oe-logs'] = os['oe-logs']
      chef_run.converge(described_recipe)
    end
    
    it 'Should create configuration directories' do
      os[:postgresql]['prefix'].each { |k, v|
        expect(chef_run).to create_directory(v)
      }
    end

  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end



require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::server_type' do

  let(:chef_run) {
    runner(attributes = os)
  }
    
  context 'Under normal situations:' do

    before do
      #Chef::DataBag.stub(:load).with(os[:data_bags])
      #Chef::DataBagItem.stub(:load).with( # , # ).and_return(dbi)
    end
    
    it 'Should include master recipe with server type master' do
      chef_run.node.set['postgresql']['server']['type'] = 'master'
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-postgresql::server_master')
    end

    it 'Should include recipe slave with server type slave' do
      chef_run.node.set['postgresql']['server']['type'] = 'slave'
      chef_run.node.set['postgresql']['master']         = 'a.b.c'
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-postgresql::server_slave')
    end

    it 'Should include recipe ro with server type ro' do
      chef_run.node.set['postgresql']['server']['type'] = 'ro'
      chef_run.node.set['postgresql']['master']         = 'a.b.c'
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-postgresql::server_ro')
    end

  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end


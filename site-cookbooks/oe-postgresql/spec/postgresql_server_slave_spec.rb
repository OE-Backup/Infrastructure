
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::server_slave' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  context 'Under normal situations:' do

    before do
      #Chef::DataBag.stub(:load).with(os[:data_bags])
      #Chef::DataBagItem.stub(:load).with( # , # ).and_return(dbi)
    end
    
    it 'Should execute repmgr' do
      chef_run.node.set['postgresql']['server']['type'] = 'slave'
      chef_run.node.set['postgresql']['master']         = 'host.bogus.com'
      chef_run.converge(described_recipe)
      expect(chef_run).to run_execute('slave-clone-db')
    end
    
  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end


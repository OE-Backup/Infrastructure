
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::log' do

  let(:chef_run) {
    runner(attributes = os)
  }
    
  context 'Under normal situations:' do

    before do
      #Chef::DataBag.stub(:load).with(os[:data_bags])
      #Chef::DataBagItem.stub(:load).with( # , # ).and_return(dbi)
    end
    
    it 'Should include oe-logs::log' do
      chef_run.node.set['oe-logs'] = os['oe-logs']
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-logs::log')
    end

    it 'Should include oe-logs::logrotate' do
      chef_run.node.set['oe-logs'] = os['oe-logs']
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe('oe-logs::logrotate')
    end

  end

end


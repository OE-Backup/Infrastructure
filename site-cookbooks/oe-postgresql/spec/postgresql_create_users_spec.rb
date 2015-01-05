
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::create_users' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  context 'Under normal situations' do

    before do
      Chef::EncryptedDataBagItem.stub(:load).with(
        chef_run.node['postgresql']['data_bag']['users'],
        chef_run.node['postgresql']['data_bag_item']['users']
      ).and_return(os[:data_bags][:db][:users])

      #stub_command("echo \"SELECT usename FROM pg_catalog.pg_user WHERE usename = 'repmgr';\"| psql -t | grep 'repmgr'").and_return(false)
    end
    
    os[:data_bags][:db][:users]['stg'].keys.each { |k,v|
      it "Should create user #{k}" do
        #stub_command("echo \"SELECT usename FROM pg_catalog.pg_user WHERE usename = '#{k}';\"| psql -t | grep '#{k}'").and_return(false)
        ChefSpec::Stubs::CommandStub.initialize("echo \"SELECT usename FROM pg_catalog.pg_user WHERE usename = '#{k}';\"| psql -t | grep '#{k}'").and_return(false)
        chef_run.converge(described_recipe)
        expect(chef_run).to run_execute("create-db-user-#{k}")
      end
    }
    #pending "TODO stub_command"

  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end


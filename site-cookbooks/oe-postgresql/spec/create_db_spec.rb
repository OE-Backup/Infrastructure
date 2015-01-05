
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::create_db' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  before do
    Chef::EncryptedDataBagItem.stub(:load).with(
      chef_run.node['postgresql']['data_bag']['users'],
      chef_run.node['postgresql']['data_bag_item']['users']
    ).and_return(os[:data_bags][:db][:users])
  end

  context 'When databases dont exist' do
   
    os[:postgresql]['databases'].each { |db|
      it "Should create database #{db['name']}" do
        stub_command("echo \"SELECT datname FROM pg_database WHERE datname = '#{db['name']}';\" | psql -t | grep '#{db['name']}'").and_return(false)
        
        chef_run.converge(described_recipe)
        expect(chef_run).to run_execute("create-db-#{db['name']}")
      end
    }

  end

  context 'When databases exist' do
     os[:postgresql]['databases'].each { |db|
      it "Should not create database #{db['name']}" do
        stub_command("echo \"SELECT datname FROM pg_database WHERE datname = '#{db['name']}';\" | psql -t | grep '#{db['name']}'").and_return(true)
        
        chef_run.converge(described_recipe)
        expect(chef_run).not_to run_execute("create-db-#{db['name']}")
      end
    }
  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end


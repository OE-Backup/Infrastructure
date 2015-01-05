
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'lp2-sfo::default' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  context '' do

    db_fqdn = os[:ssl]['fqdn'].gsub(/\./,'_')
    before do
      # SSL certificates
      Chef::DataBagItem.stub(:load).with(
        'ssl',
        db_fqdn
      ).and_return(os[:databags]['ssl'][db_fqdn])
      # SSL private certificate
      Chef::EncryptedDataBagItem.stub(:load).with(
        'ssl-keys', 
        db_fqdn
      ).and_return(os[:databags]['ssl-keys'][db_fqdn])
      # Tomcat users
      Chef::DataBag.stub(:load).with('tomcat_users').and_return(os[:databags]['tomcat_users'])
      Chef::EncryptedDataBagItem.stub(:load).with(
        'tomcat_users',
        'rspec'
      ).and_return(os[:databags]['tomcat_users']['rspec'])
      chef_run.converge(described_recipe)
    end

    it 'Should include oe-ssl' do
      expect(chef_run).to include_recipe('oe-ssl')
    end

    it 'Should include oe-tomcat' do
      expect(chef_run).to include_recipe('oe-tomcat')
    end

  end
   
end


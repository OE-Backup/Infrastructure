
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-ssl::default' do

  let(:chef_run) {
    runner(attributes = os)
  }

  context '' do
   
    dbi_domain = os[:ssl]['fqdn'].gsub(/\./, '_')
    dbi        = os[:databags]['ssl'][dbi_domain]
    dbi_enc    = os[:databags]['ssl-keys'][dbi_domain]

    before do
      Chef::DataBag.stub(:load).with(os[:data_bags])
      Chef::DataBagItem.stub(:load).with('ssl', dbi_domain).and_return(dbi)
      Chef::EncryptedDataBagItem.stub(:load).with('ssl-keys', dbi_domain).and_return(dbi_enc)
    end

    it "Should include recipe pem" do
      chef_run.node.set['ssl']['type'] = 'pem'
      chef_run.converge(described_recipe)
      
      expect(chef_run).to     include_recipe('oe-ssl::pem')
      expect(chef_run).not_to include_recipe('oe-ssl::keystore')
      expect(chef_run).not_to include_recipe('oe-ssl::pkcs12')
    end

    it "Should include recipe pkcs12" do
      chef_run.node.set['ssl']['type'] = 'pkcs12'
      chef_run.converge(described_recipe)
      
      expect(chef_run).to     include_recipe('oe-ssl::pkcs12')
      expect(chef_run).to     include_recipe('oe-ssl::pem')
      expect(chef_run).not_to include_recipe('oe-ssl::keystore')
    end

    it "Should include recipe keystore" do
      chef_run.node.set['ssl']['type'] = 'keystore'
      chef_run.converge(described_recipe)
      
      expect(chef_run).to     include_recipe('oe-ssl::keystore')
      expect(chef_run).to     include_recipe('oe-ssl::pem')
      expect(chef_run).to     include_recipe('oe-ssl::pkcs12')
    end

  end

end


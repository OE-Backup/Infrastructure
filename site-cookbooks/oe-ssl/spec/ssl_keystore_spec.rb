
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-ssl::keystore' do

  let(:chef_run) {
    runner(attributes = os)
  }

  fqdn     = os[:ssl]['fqdn']
  dbi_fqdn = fqdn.gsub(/\./, '_')
  dbi      = os[:databags]['ssl'][dbi_fqdn]
  dbi_enc  = os[:databags]['ssl-keys'][dbi_fqdn]

  prefix = "#{os[:ssl]['keystore']['prefix']}/#{fqdn}/#{fqdn}"

  context '' do
   
    before do
      Chef::DataBag.stub(:load).with(os[:databags])
      Chef::DataBagItem.stub(:load).with('ssl', dbi_fqdn).and_return(dbi)
      Chef::EncryptedDataBagItem.stub(:load).with('ssl-keys', dbi_fqdn).and_return(dbi_enc)
    end
    
    it 'Should create a keystore file' do
      chef_run.converge(described_recipe)
      
      expect(chef_run).to include_recipe('oe-ssl::pem')
      expect(chef_run).to include_recipe('oe-ssl::pkcs12')
    end

    #it "Should raise an exception if storepass is not defined" do
    #  Chef::EncryptedDataBagItem.stub(:load).with('ssl_key', dbi_fqdn).and_return({ 
    #    'id'  => '',
    #    'key' => 'ASDASDASD',
    #  })
    #  chef_run.converge(described_recipe)
    #  expect {
    #    chef_run
    #  }.to raise_error
    #end

  end

end


require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-ssl::pem' do

  let(:chef_run) {
    runner(attributes = os)
  }

  fqdn     = os[:ssl]['fqdn']
  dbi_fqdn = fqdn.gsub(/\./, '_')
  dbi      = os[:databags]['ssl'][dbi_fqdn]
  dbi_enc  = os[:databags]['ssl-keys'][dbi_fqdn]

  prefix = "#{os[:ssl]['pem']['prefix']}/#{fqdn}"

  context '' do
   
    before do
      #Chef::DataBag.stub(:load).with(os[:databags])
      Chef::DataBagItem.stub(:load).with('ssl', dbi_fqdn).and_return(dbi)
      Chef::EncryptedDataBagItem.stub(:load).with('ssl-keys', dbi_fqdn).and_return(dbi_enc)
    end
    
    it "Should create certs directory #{dbi['id']}" do
      chef_run.converge(described_recipe)
      
      expect(chef_run).to create_directory("#{prefix}")
    end

    [ 'cert', 'ca', 'chaincert' ].each { |f|
      it "Should create #{f} for #{dbi['id']}" do
        chef_run.converge(described_recipe)
        
        expect(chef_run).to create_file("#{prefix}/#{fqdn}.#{f}")
        expect(chef_run).to render_file("#{prefix}/#{fqdn}.#{f}").with_content("#{dbi[f]}")
      end
    }

    it "Should create key for #{dbi['id']}" do
      chef_run.converge(described_recipe)
      
      expect(chef_run).to create_file("#{prefix}/#{fqdn}.key")
      expect(chef_run).to render_file("#{prefix}/#{fqdn}.key").with_content(dbi_enc['key'])
    end

  end

end 


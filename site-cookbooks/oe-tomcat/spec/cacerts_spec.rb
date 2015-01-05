
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-tomcat::cacerts' do

  let(:chef_run) {
    runner(attributes = os)
  }
    
  context '' do

    dbi = os[:data_bags]['ssl']['cacerts']
    
    before do
      Chef::DataBag.stub(:load).with(os[:data_bags])
      Chef::DataBagItem.stub(:load).with('ssl', 'cacerts').and_return(dbi)
    end
    
    it "Should update java's cacerts" do
      #chef_run.node.set['tomcat']['ssl']['certs_dir'] = os[:tomcat_ssl_cacert_dir]
      chef_run.converge(described_recipe)
      expect(chef_run).to create_directory(os[:tomcat]['ssl']['certs_dir'])
      dbi.each { |k,v|
        expect(chef_run).to create_file("#{os[:tomcat]['ssl']['certs_dir']}/#{k}.pem")
        expect(chef_run).to create_file("#{os[:tomcat]['ssl']['certs_dir']}/#{k}.pem").with_content(v)
        # Rspec test execute
      }
    end

  end

end


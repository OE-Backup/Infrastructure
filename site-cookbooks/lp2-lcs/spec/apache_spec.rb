
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'lp2-lcs::apache' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  context '' do

    before do
      #Chef::EncryptedDataBagItem.stub(:load).with(
      #,
      #).and_return()
    end

    %w(
      apache2::default
      apache2::mod_proxy_http
      apache2::mod_rewrite
      apache2::mod_ssl
      apache2::mod_expires
      apache2::mod_status
    ).each { |recipe|
      it "Should include #{recipe}" do
        chef_run.converge(described_recipe)
        expect(chef_run).to include_recipe(recipe)
      end
    }

    os[:apache]['vhosts'].each { |vhost|
      it "Render template for #{vhost}" do
        chef_run.converge(described_recipe)
        expect(chef_run).to render_file("#{os[:apache]['dir']}/sites-available/#{vhost}")
      end
    }
  
  end
   
end


require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-tomcat::propfiles' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  context '' do

    before do
      Chef::DataBag.stub(:load).with('tomcat_properties').and_return(
        os[:data_bags][:tomcat_properties]
      )
      Chef::EncryptedDataBagItem.stub(:load).with(
        'tomcat_properties', 'account_service'
      ).and_return(os[:data_bags][:tomcat_properties]['account_service'])
      chef_run.converge(described_recipe)
    end
    
    it 'It should create propfiles directory' do
      expect(chef_run).to create_directory(os[:tomcat]['propfiles_prefix'])
    end

    it 'It should create file with databag contents' do
      expect(chef_run).to render_file(
        "#{os[:tomcat]['propfiles_prefix']}/#{os[:tomcat]['propfiles'][0]['src']}"
      )#.with_content(/^# Chef generated property file\nVAR1=asd\nVAR2=dfg\nVAR3=qwe/)
    end

    #it 'It should NOT create file' do
    #  expect(chef_run).not_to render_file(
    #    "#{os[:tomcat]['propfiles_prefix']}/#{os[:tomcat]['propfiles'][1][:src]}"
    #  )
    #end

    it "It should replace default/tomcat7 with oe-tomcat's sourced file" do
      expect(chef_run).to render_file(os[:tomcat]['default'])
      #.with_content(
      #  /#{os[:tomcat]['propfiles_prefix']}\/#{os[:tomcat]['propfiles'][0][:src]} \|\| true$/
      #)
    end

  end

end


require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-tomcat::config' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }

  context "" do
   
    before do
      chef_run.converge(described_recipe)
    end
    
    os[:tomcat]['dirs'].each { |k,d|
      it "Should create directory #{k}:#{d}" do
        chef_run.converge(described_recipe)
        expect(chef_run).to create_directory(d)
      end
    }

    it 'Should render server.xml' do
      expect(chef_run).to render_file("#{os[:tomcat]['dirs']['config']}/server.xml")
    end
    
  end
  
end


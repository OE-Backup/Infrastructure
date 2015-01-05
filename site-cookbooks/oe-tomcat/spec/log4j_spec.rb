require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-tomcat::log4j' do
  
  let(:chef_run) {
    runner(attributes = os)
  }
  
  context '' do
    
    before do
      # ...
      chef_run.converge(described_recipe)
    end
    
    it 'Should render template' do
      expect(chef_run).to render_file(os[:tomcat]['log4j']['filename'])
    end
    
  end
  
end

